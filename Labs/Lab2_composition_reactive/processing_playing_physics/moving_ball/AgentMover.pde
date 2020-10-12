int RADIUS_CIRCLE=50;
int LIMIT_VELOCITY=50;
float CONSTANT_ACC=10;

float alpha=0.1;  

class AgentMover{
  PVector position, velocity, acceleration;
  float vibrato=0;
  float cutoff=0.5;
  AgentMover(){
    this.position= new PVector(random(0, width), random(0, height));
    this.velocity = new PVector(random(-2, 2), random(-2, 2));
    this.acceleration = new PVector(random(2), random(2));
  }
  void update(){    
    PVector delta = new PVector(mouseX, mouseY);
    delta.sub(this.position);
    delta.normalize();
    delta.mult(CONSTANT_ACC);
    this.acceleration = delta;
    
    this.velocity.add(this.acceleration);
    this.velocity.limit(LIMIT_VELOCITY);
    this.position.add(this.velocity);
  }
  void computeEffect(){
    float vibrato= constrain(this.position.x/width -0.5, -0.5, 0.5);
    this.vibrato=alpha* vibrato + (1-alpha)*this.vibrato;
    float cutoff=constrain((this.position.y/height),0,1);
    this.cutoff= alpha* cutoff +(1-alpha)*this.cutoff;
   
  }
  void draw(){
    fill(200);
    ellipse(this.position.x, this.position.y, RADIUS_CIRCLE, RADIUS_CIRCLE);
  }

}
