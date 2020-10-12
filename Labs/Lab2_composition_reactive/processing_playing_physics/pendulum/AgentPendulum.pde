float alpha=0.1;
class AgentPendulum{
  PVector pivotPos, massPos;
  float angle, aVel, aAcc;
  float r, mass, radius;
  float vibrato=0; float cutoff=0;
  float initAngle;
  AgentPendulum(float x, float y, float r, float mass){
    this.pivotPos = new PVector(x, y);
    this.angle=random( -PI/2, -PI/4);
    this.initAngle=angle;
    this.r=r;
    this.mass=mass;
    this.aVel=0;
    this.aAcc=0;
    this.massPos = new PVector(0, 0);
    this.radius=sqrt(this.mass/PI)*MASS_TO_PIXEL;    
  }
  void update(){    
    this.aVel+=this.aAcc;
    this.angle+=this.aVel;
    this.aAcc=0;
    this.massPos.set(this.r*sin(this.angle), this.r*cos(this.angle));
    this.massPos.add(this.pivotPos);
  }
  void computeEffect(){
    float vibrato= this.angle/this.initAngle;
    this.vibrato=alpha* vibrato + (1-alpha)*this.vibrato;
    float cutoff=constrain(abs(this.aVel), 0,1);
    this.cutoff= alpha* cutoff +(1-alpha)*this.cutoff;
  }
  void applyForce(float force){    
    this.aAcc+=force/this.mass;    
  }
  void draw(){
    fill(200);
    // draw pivot
    ellipse(this.pivotPos.x, this.pivotPos.y, 5,5);
    
    // draw arm
    stroke(255);
    strokeWeight(5);
    line(this.pivotPos.x, this.pivotPos.y, 
         this.massPos.x, this.massPos.y);       
    noStroke();
    
    // draw mass
    ellipse(this.massPos.x, this.massPos.y, 
              this.radius, this.radius);
    
  }
}
