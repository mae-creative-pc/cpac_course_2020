import beads.*;

AudioContext ac;
int N_AGENTS=5;
AgentMover[] movers;
WavePlayer[] wavs;
Glide[] freqs;
int MASS_TO_PIXEL=10;
float mass_attractor;
float radius_attractor;
PVector pos_attractor;

float mass_repeller;
float radius_repeller;
PVector pos_repeller;
float area;

void setup(){
  ac=new AudioContext();
  wavs=new WavePlayer[N_AGENTS];
  freqs=new Glide[N_AGENTS];
  movers=new AgentMover[N_AGENTS];
  for(int i=0; i<N_AGENTS; i++){
     movers[i]=new AgentMover(random(5,50));
     freqs[i]= new Glide(ac, 0, 17);
     wavs[i]=new WavePlayer(ac, freqs[i], Buffer.SINE);
     ac.out.addInput(wavs[i]);
  }
  mass_attractor=random(800, 1200);
  pos_attractor = new PVector(random(0.3*width, 0.7*width), 
                              random(0.3*height, 0.7*height));  
  radius_attractor = sqrt(mass_attractor/PI)*MASS_TO_PIXEL;
  
  
  mass_repeller=random(200, 300);
  pos_repeller = new PVector(random(0.1*width, 0.9*width), random(0.1*height, 0.9*height));  
  radius_repeller = sqrt(mass_repeller/PI)*MASS_TO_PIXEL;
  
  size(1280, 720);
  background(0);
  ac.start();
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

PVector computeRepellerForce(AgentMover mover){
  PVector rep_force=pos_repeller.copy();
  rep_force.sub(mover.position);
  float dist=rep_force.mag();
  dist=constrain(dist, dist_min,dist_max);
  rep_force.normalize(); 
  rep_force.mult(-1*mover.mass*mass_repeller/(dist*dist));
  return rep_force;
}

void changeFrequency(int i){
  
  PVector dist_v=pos_attractor.copy();
  dist_v.sub(movers[i].position);
  float dist=dist_v.mag();
  float val=100*movers[i].velocity.mag();
  println(val);
  //val=map(val, 100, 1000, 100, 3000);
 // println(val);
  freqs[i].setValue(val);
     

}
void draw(){
  //pos_repeller.set(mouseX, mouseY);
  rectMode(CORNER);
  fill(0,20);
  rect(0,0,width, height);
  fill(200, 0, 200, 40);
  ellipse(pos_attractor.x, pos_attractor.y, 
          radius_attractor, radius_attractor);
  
  fill(200, 200, 0, 40);
  ellipse(pos_repeller.x, pos_repeller.y, 
          radius_repeller, radius_repeller);        
  
  PVector force_a, force_r;
  for(int i=0; i<N_AGENTS; i++){
    force_a = computeGravityForce(movers[i]);
    force_r = computeRepellerForce(movers[i]);
    movers[i].applyForce(force_a);
    movers[i].applyForce(force_r);
    changeFrequency(i);
    movers[i].update();
    movers[i].draw(100);
    if(i==0){movers[i].draw(255);}
  }
}
