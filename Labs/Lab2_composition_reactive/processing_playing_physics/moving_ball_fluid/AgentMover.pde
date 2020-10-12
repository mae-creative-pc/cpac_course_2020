int RADIUS_CIRCLE=50;
int LIMIT_VELOCITY=50;
int CONSTANT_ACC=2;

float alpha=0.1;  

class AgentMover{
  PVector position, velocity, acceleration;
  OscP5 oscP5;
  NetAddress ip_port;
  float vibrato=0;
  float cutoff=0.5;
  float mass;
  AgentMover(){
    this.position= new PVector(random(0, width), random(0, height));
    this.velocity = new PVector(random(-2, 2), random(-2, 2));
    this.acceleration = new PVector(random(2), random(2));
    this.mass=1;
    
  }
  void update(){    
    PVector delta = new PVector(mouseX, mouseY);
    delta.sub(this.position);
    delta.normalize();
    delta.mult(CONSTANT_ACC);
    this.acceleration.add(delta);
    
    this.velocity.add(this.acceleration);
    this.velocity.limit(LIMIT_VELOCITY);
    this.position.add(this.velocity);
    this.acceleration.mult(0);
  }
  
  void computeEffect(){
    float vibrato= constrain(this.position.x/width -0.5, -0.5, 0.5);
    this.vibrato=alpha* vibrato + (1-alpha)*this.vibrato;
    float new_cutoff=constrain((this.position.y/height),0,1);
    this.cutoff= alpha* new_cutoff +(1-alpha)*this.cutoff;
  }
  void applyForce(PVector force){
     PVector f = force.copy();
     f.div(this.mass);
     this.acceleration.add(f);
  }
  void draw(){
    fill(200);
    ellipse(this.position.x, this.position.y, RADIUS_CIRCLE, RADIUS_CIRCLE);
  }
  

}
