import ddf.minim.*;
import ddf.minim.analysis.*;
int HEIGHT=720;
int SMOOTHING_WINDOW = 10;
int MARGIN;

float compute_flatness(FFT fft, float sum_of_spectrum){   
  // using several products will get overflow;
  // so instead of computing the harmonic mean, 
  // we compute the exponential of the average of the logarithms
   float sum_of_logs = 0;    
   float flatness;
   for(int i = 0; i < fft.specSize(); i++)
   {
     sum_of_logs += log(fft.getBand(i));      
   }
   flatness = exp(sum_of_logs/fft.specSize()) / 
                 (0.000001+sum_of_spectrum/fft.specSize());
   return flatness;
}

float compute_centroid(FFT fft, float sum_of_spectrum, 
                                        float[] freqs){
   float centroid=0;
    for(int i = 0; i < fft.specSize(); i++){
      centroid += freqs[i]*fft.getBand(i);
    }
    return centroid/(0.00001+sum_of_spectrum);
}

float compute_spread(FFT fft, float centroid, float sum_of_bands, float[] freqs){
  float spread=0;
  for (int i=0; i<fft.specSize(); i++){
     spread+= pow(freqs[i]-centroid,2)*fft.getBand(i);
  }
  return sqrt(spread/(0.000001+sum_of_bands));
}

float compute_skewness(FFT fft, float centroid, float spread, float[] freqs){
  float skewness=0;
  for (int i=0; i<fft.specSize(); i++){
     skewness+= pow(freqs[i]-centroid,3)*fft.getBand(i);
  }
  return skewness/(0.00001+fft.specSize()*pow(spread,3));
}

float compute_entropy(FFT fft){
  float entropy =0;
  for (int i=1; i<fft.specSize(); i++){
     entropy+= fft.getBand(i)*log(0.00001+fft.getBand(i));
  }
  return entropy/log(fft.specSize());
}

float compute_sum_of_spectrum(FFT fft){
  float sum_of=0;
  for(int i = 0; i < fft.specSize(); i++)
   {
     sum_of += fft.getBand(i);      
   }
  return sum_of+1e-15; // adding a little displacement to avoid division by zero
}

float[] compute_peak_band_and_freq(FFT fft, float[] freqs){
  float val=0;
  float maxPeakVal=0;
  float maxFreqVal=0;
  float[] peak_band_freq= new float[2];
  peak_band_freq[0]=0.; // peak band
  peak_band_freq[1]=0.; // peak freq
  
  for(int i = 0; i < fft.specSize(); i++){
    val=fft.getBand(i);
    if(val>maxPeakVal){ 
      maxPeakVal=val;
      peak_band_freq[0]=1.0*i;
    }
    if(val>maxFreqVal && freqs[i]>20.){ 
      // if new max in the audible spectrum
      peak_band_freq[1]=freqs[i];
      maxFreqVal=val;
    }
  }   
  
  return peak_band_freq;
}

float get_average(float[] buffer){
  float average=0;
  for(int i=0; i<buffer.length; i++){
      average+=buffer[i];
  }
  return average/buffer.length;
}
float compute_energy(FFT fft) {    
  float energy = 0;
  for(int i = 0; i < fft.specSize(); i++){
    energy+=pow(fft.getBand(i),2);      
  }   
  return energy;
}
class AgentFeature { 
  int index_buffer=0;
  int index_spectrogram=0;
  int bufferSize;
  float sampleRate;
  int specSize;
  FFT fft;
  BeatDetect beat;
  
  
  float[] freqs;
  float sum_of_bands;
  float centroid;
  float spread;
  float energy;
  float skewness;
  float entropy;
  float flatness;
  boolean isBeat;
  float lambda_smooth;
  AgentFeature(int bufferSize, float sampleRate){
    this.bufferSize=bufferSize;
    this.sampleRate=sampleRate;
    this.fft = new FFT(bufferSize, sampleRate);
    this.fft.window(FFT.HAMMING);
    this.specSize=this.fft.specSize();
    this.beat = new BeatDetect();
    
    this.lambda_smooth = 0.1;
    this.freqs=new float[this.specSize];
    for(int i=0; i<this.specSize; i++){
      this.freqs[i]= 0.5*(1.0*i/this.specSize)*this.sampleRate;
    }
    
    this.isBeat=false;
    this.centroid=0;
    this.spread=0;
    this.sum_of_bands = 0;
    this.skewness=0;    
    this.entropy=0;
    this.energy=0;
  }
  float smooth_filter(float old_value, float new_value){
    /* Try to implement a smoothing filter using this.lambda_smooth*/
    return this.lambda_smooth*new_value+(1-this.lambda_smooth)*old_value;
  }
  void reasoning(AudioBuffer mix){
     this.fft.forward(mix);
     this.beat.detect(mix);
     float sum_of_bands = compute_sum_of_spectrum(this.fft);
     float centroid = compute_centroid(this.fft,sum_of_bands,this.freqs);
     float flatness = compute_flatness(this.fft, sum_of_bands);
     float spread = compute_spread(this.fft, centroid, sum_of_bands, this.freqs);                                  
     float skewness= compute_skewness(this.fft, centroid, spread, this.freqs);
     float entropy = compute_entropy(this.fft);     
     float energy = compute_energy(this.fft);
     
     this.index_buffer = (this.index_buffer+1)%SMOOTHING_WINDOW;
     this.centroid = this.smooth_filter(this.centroid, centroid);    
     this.energy = this.smooth_filter(this.energy, energy);
     this.flatness = this.smooth_filter(this.flatness, flatness);
     this.spread = this.smooth_filter(this.spread, spread);
     this.skewness = this.smooth_filter(this.skewness, skewness);
     this.entropy = this.smooth_filter(this.entropy, entropy);
     this.isBeat = this.beat.isOnset();
  }   
} 

class AgentDrawer{
  AgentFeature feat;
  int numFeatures;
  float heightFeatures;
  float maxWidth;
  int textSpace;
  boolean first_frame=true;
  int wait_frames=10;
  int marginLeft;
  float maxFeatures[];
  float minFeatures[];
  String[] labels={"ENERGY","CENTR", "SPREAD", "SKEW", "ENTR", "FLAT"};
  color[] colors={color(255,255,0), color(255,0,255), color(0,255,255),
                  color(255,0,0), color(0,255,0), color(255,128,0)};
  AgentDrawer(AgentFeature feat, int numFeatures){
    this.feat=feat;
    MARGIN=int(0.05*height);
    
    this.numFeatures=numFeatures;
    this.heightFeatures= 1.0*(height-2*MARGIN)-((this.numFeatures-1)*MARGIN);
    this.heightFeatures/=numFeatures;
    this.textSpace= int(this.heightFeatures*4);
    this.marginLeft= MARGIN+this.textSpace;
    this.maxWidth= width-MARGIN-this.marginLeft;
    this.maxFeatures = new float[numFeatures];
    this.minFeatures = new float[numFeatures];
    for(int i=0; i<this.numFeatures; i++){
      /*
      Since we don't know the value of the features in advance, 
      we will keep estimating the minimum and maximum values for 
      each of them
      */
      this.maxFeatures[i]=0; 
      this.minFeatures[i]=0;
    }
  }
  void action(){
    float[] values=new float[this.numFeatures];
    values[0]=this.feat.energy;
    values[1]=this.feat.centroid;
    values[2]=this.feat.spread;
    values[3]=this.feat.skewness;
    values[4]=this.feat.entropy;
    values[5]=this.feat.flatness;
    int aboveSpace=MARGIN;    
    float x=0;
    textSize((int)this.heightFeatures);
    for (int i=0; i<this.numFeatures; i++){
        aboveSpace=MARGIN+i*((int)this.heightFeatures+MARGIN);    
        fill(this.colors[i]);
        text(this.labels[i], MARGIN, aboveSpace+this.heightFeatures);
        if(this.first_frame){
          /*
          If this is the first frame, we don't estimate min and max but
          just copy the value (we cannot compare them)
          */
          this.maxFeatures[i]=values[i];
          this.minFeatures[i]=values[i];
        }
        else{
          if (values[i]>this.maxFeatures[i]){
               this.maxFeatures[i]=values[i];}
          if (values[i]<this.minFeatures[i]){
              this.minFeatures[i]=values[i];}
        }
        if(this.wait_frames<=0){            
          /*
          We wait for some frames before actually starting drawing, so
          we have a better estimate of the range.
          We start initializing wait_frames at 10, then each frame we 
          decrease this number until we have 0, then we start drawing.
          The map function is:
          value_out=map(value_in, range_in_min, range_in_max, range_out_min, range_out_max)
          and it maps a value in an input range to a value in an output range.
          E.g., map(0.3, 0, 1, 0, 100)=>30
          */
            x=map(values[i], this.minFeatures[i], this.maxFeatures[i], 0, this.maxWidth);
        }     
        /* this actually draws the value */
        rect(this.marginLeft, aboveSpace,  x, this.heightFeatures); 
        
    }
    if(this.wait_frames>0){
      this.wait_frames--;
    }
    if(this.first_frame){
      this.first_frame=false;
    }
  }

}  
