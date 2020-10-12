import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.*;
import ddf.minim.analysis.*;

int frameLength = 1024; //--> when this is low, it may take more to compute


class MicInput{
   AudioInput mic;
   FFT fft;
   Minim minim;
   float maxEnergy;
   MicInput(){
     this.minim= new Minim(this);
    this.mic = minim.getLineIn(Minim.MONO, frameLength);
    this.fft = new FFT(mic.bufferSize(), mic.sampleRate());
    this.fft.window(FFT.HAMMING);
      }
  float getEnergy(){    
    this.fft.forward(this.mic.mix);
    float energy = 0;
    for(int i = 0; i < this.fft.specSize(); i++){
       energy+=pow(this.fft.getBand(i),2);      
    }   
    return energy;
  }
}
