float SCALE_STEPS[]={0, 50, 10}; 
// use it as SCALE_STEP[MONTECARLO_STEPS]

class Walker {
  PVector position;
  PVector prevPosition;
  float freq, amp, cutoff, vibrato;
  float forget_factor=0.5;
  Walker() {
    this.position=new PVector(width/2, height/2);
    this.prevPosition=this.position.copy();    
    this.amp=-1; this.vibrato=0;
    this.freq=0;
    this.cutoff=0;
  }
  void draw() {    
    Color c;    
    // your code here to change the color
    stroke(c);
    // your code here to draw the walker
  }
  void computeEffect(){
     this.freq=0;
     this.cutoff=0;     
     this.amp = 0; 
     this.vibrato=0;
      // your code
  }
  void update() {    
    PVector step;
    // your code here
    this.prevPosition=this.position.copy(); 
       
  }
}

float montecarlo() {
  while (true) {
    if(MONTECARLO_STEPS==2){
      // as before
    }	
    if(MONTECARLO_STEPS==1){
      // your code
    }
  }
}
