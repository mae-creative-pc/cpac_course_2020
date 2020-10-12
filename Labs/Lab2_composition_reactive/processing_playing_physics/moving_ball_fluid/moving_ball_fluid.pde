import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress ip_port;
int PORT = 57120;

AgentMover mover;
float C_d=0.05;
float rho = 0.1;
float area;
PVector dragForce;
void setup(){
  mover=new AgentMover();
  area = 0.001*RADIUS_CIRCLE*PI;
  
  oscP5 = new OscP5(this,55000);
  ip_port = new NetAddress("127.0.0.1",PORT);
  
  size(1280, 720);
  background(0);
}

void sendEffect(float cutoff, float vibrato){
    OscMessage effect = new OscMessage("/note_effect");    
    effect.add("effect");       
    effect.add(cutoff);
    effect.add(vibrato);
    
    oscP5.send(effect, ip_port);
}
PVector computeDragForce(AgentMover mover){
  PVector dragForce=mover.velocity.copy();
  float mag2 = mover.velocity.mag();
  mag2=mag2*mag2;
  dragForce.normalize();
  dragForce.mult(-0.5*C_d*rho*area*mag2);
  return dragForce;
}

void draw(){
  background(0);
  dragForce = computeDragForce(mover);
  mover.applyForce(dragForce);
  mover.update();
  mover.computeEffect();
  sendEffect(mover.cutoff, mover.vibrato);
  mover.draw();
}
