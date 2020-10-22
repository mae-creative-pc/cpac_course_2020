class Walker {
  PVector position;
  PVector prevPosition;
  
  Walker() {
    this.position=new PVector(width/2, height/2);
    this.prevPosition=this.position.copy();    
  }
  void draw() {    
    stroke(255);
    // your code here
  }

  void update() {    
    PVector step;
    // your code here
    this.prevPosition=this.position.copy();    
  }
}

float montecarlo() {
  while (true) {
    /* your code here */
    
  }
}
