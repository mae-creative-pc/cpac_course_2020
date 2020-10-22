float LOW_FREQ=60;
float HIGH_FREQ=3000;

float MIN_SAT=30;
float BRIGHTNESS=255;
boolean SEE_COLORS=false;
float SEE_COLORS_ANGLE=0;
float SEE_COLORS_RADIUS=0;
int MONTECARLO_STESP=2;
float SCALE_STEPS[]={0, 10, 50};


class Walker {
  PVector position;
  PVector prevPosition;
  PVector fromCenter= new PVector(0,0);
  float prevX, prevY;
  float freq, amp, cutoff, vibrato;
  float forget_factor=0.5;
  float num_lines=0;
  float mean_length=0;
  float std_length=0;
  float strokeWeight=3;
  
  Walker() {
    this.position=new PVector(width/2, height/2);
    this.prevPosition=this.position.copy();
    this.amp=-1; this.vibrato=0;
    this.freq=0;
    this.cutoff=0;
  }
  Walker(PVector pos) {
    this.position=pos.copy();
    this.prevPosition=this.position.copy();
    this.fromCenter=PVector.sub(this.position, CENTER_SCREEN);
  }
  
  void draw() {    
    colorMode(HSB, 255);
    
    float hue=map(fromCenter.heading(), -PI, PI, 0, 255);
    float sat=min(255,map(fromCenter.mag(), 0, 0.2*sqrt(pow(width,2)+pow(height,2)), MIN_SAT, 255));
    color c= color(hue, sat,BRIGHTNESS);    
    stroke(c);
    strokeWeight(this.strokeWeight);
    line(this.prevPosition.x,this.prevPosition.y,this.position.x, this.position.y);
  }

  // Randomly move according to floating point values
  void computeEffect(){
     float freq=map((this.position.y+this.position.x),0,height+width,LOW_FREQ,HIGH_FREQ);
     float cutoff=this.position.x/(width/2);
     float curLength=PVector.sub(this.prevPosition, this.position).mag();
     float amp = min(1,map(fromCenter.mag(),0, 0.5*sqrt(pow(width,2)+pow(height,2)), 0.2, 1));
     
     if(this.amp==-1){
      this.freq=freq;
      this.cutoff=cutoff;
      this.mean_length=curLength;
      
     }
     else{ // smooth
       this.mean_length=((this.num_lines-1)*this.mean_length +  curLength)/this.num_lines;
       
       this.cutoff=forget_factor*cutoff+(1-forget_factor)*this.cutoff;
       this.freq=forget_factor*freq+(1-forget_factor)*this.freq;       
     }
     this.amp=forget_factor*amp+(1-forget_factor)*this.amp;
  }
  void update() {
    this.prevPosition=this.position.copy();
    
    PVector step=new PVector(random(-1, 1), random(-1, 1));
    step.normalize();
    float stepsize = montecarlo();
    step.mult(stepsize*SCALE_STEPS[MONTECARLO_TYPE]);
    this.position.add(step);
    if(SEE_COLORS){    
      this.position.x=width/2+SEE_COLORS_RADIUS*cos(SEE_COLORS_ANGLE);
      this.position.y=height/2+SEE_COLORS_RADIUS*sin(SEE_COLORS_ANGLE);
      SEE_COLORS_ANGLE=(SEE_COLORS_ANGLE+0.5)%(2*PI);    
      SEE_COLORS_RADIUS+=2/((2*PI)/0.5);
    }
    else{
      this.position.x=min(this.position.x, width);
      this.position.y=min(this.position.y, height);
      this.num_lines++;
    }
    this.fromCenter=PVector.sub(this.position, CENTER_SCREEN);
  }
}


float montecarlo() {
  while (true) {
    if(MONTECARLO_STEPS==2){
      float r1 = random(1);  
      float probability = random(1);  
  
      float r2 = random(1);  
      if (r2 < probability) { return r1;}
    }	
    if(MONTECARLO_STEPS==1){
      float r1 = random(1);	
      float probability = pow(1.0 - r1,8);	
  
      float r2 = random(1);	
      if (r2 < probability) { return r1;}
    }
  }
}
