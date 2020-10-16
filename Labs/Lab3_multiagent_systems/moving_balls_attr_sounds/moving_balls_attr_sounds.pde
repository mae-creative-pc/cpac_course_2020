import processing.sound.*;
import java.util.Date;

int N_AGENTS=7;
AgentMover[] movers;
SoundFile[] samples;
float MASS_TO_PIXEL=0.1;
float mass_attractor;
float radius_attractor=100;
PVector pos_attractor;


void setup(){
  String path=sketchPath()+"/sounds";
  File dir = new File(path);
  print(dir.isDirectory());
  String filenames[] = dir.list();
  N_AGENTS=filenames.length;
  
  movers=new AgentMover[N_AGENTS];
  samples=new SoundFile[N_AGENTS];
  
  for(int i=0; i<N_AGENTS; i++){
     movers[i]=new AgentMover(random(100000,200000));
     samples[i] = new SoundFile(this, path+"/"+filenames[i]);
     samples[i].amp(0);
     samples[i].loop();
  }
  mass_attractor=random(100, 200);
  pos_attractor = new PVector(0.5*width, 0.5*height);  
  //radius_attractor = sqrt(mass_attractor/PI)*MASS_TO_PIXEL;
  
  size(1280, 720);
  background(0);
  
}

PVector computeGravityForce(AgentMover mover){
  PVector attr_force=pos_attractor.copy();
  attr_force.sub(mover.position);
  float dist=attr_force.mag();
  dist=constrain(dist, dist_min, dist_max);
  attr_force.normalize(); 
  attr_force.mult(mover.mass*mass_attractor/(dist*dist));
  return attr_force;
}


int changeAmp(int i){
  PVector attr_force=pos_attractor.copy();
  attr_force.sub(movers[i].position);
  float dist=attr_force.mag();  
  float amp=min(1,5/(1+0.01*dist));
  samples[i].amp(amp);
  
  return int(amp*255);
}
void draw(){
  //pos_repeller.set(mouseX, mouseY);
  rectMode(CORNER);
  fill(0,20);
  rect(0,0,width, height);
  fill(200, 0, 200, 40);
  ellipse(pos_attractor.x, pos_attractor.y, 
          radius_attractor, radius_attractor);
  
  PVector force_a;
  for(int i=0; i<N_AGENTS; i++){
    force_a = computeGravityForce(movers[i]);
    movers[i].applyForce(force_a);
    int c=changeAmp(i);
    movers[i].update();
    movers[i].draw(c); 
  }
}
