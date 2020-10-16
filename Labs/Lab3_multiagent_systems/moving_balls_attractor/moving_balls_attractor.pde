int N_AGENTS=20;
AgentMover[] movers;
int MASS_TO_PIXEL=10;
float mass_attractor;
PVector pos_attractor;
float radius_attractor;
float area;
void setup(){
  movers=new AgentMover[N_AGENTS];
  for(int i=0; i<N_AGENTS; i++){
     movers[i]=new AgentMover(random(5,30));
  }
  mass_attractor=random(800, 1200);
  pos_attractor = new PVector(width/2., height/2.);  
  radius_attractor = sqrt(mass_attractor/PI)*MASS_TO_PIXEL;
  
  size(1280, 720);
  background(0);  
}

PVector computeGravityForce(AgentMover mover){
  PVector attr_force=pos_attractor.copy();
  attr_force.sub(mover.position);
  float dist=attr_force.mag();
  dist=constrain(dist, dist_min,dist_max);
  attr_force.normalize(); 
  attr_force.mult(mover.mass*mass_attractor/(dist*dist));
  return attr_force;
}
    
void draw(){
  rectMode(CORNER);
  fill(0,40);
  rect(0,0,width, height);
  fill(200, 0, 200, 40);
  ellipse(pos_attractor.x, pos_attractor.y, 
          radius_attractor, radius_attractor);
  PVector force;
  for(int i=0; i<N_AGENTS; i++){
    force = computeGravityForce(movers[i]);
    movers[i].applyForce(force);
    movers[i].update();
    movers[i].draw();
  }
}
