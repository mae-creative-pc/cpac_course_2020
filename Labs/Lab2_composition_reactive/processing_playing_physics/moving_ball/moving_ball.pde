import oscP5.*;
import netP5.*;
int PORT = 57120;
OscP5 oscP5;
NetAddress ip_port;

AgentMover mover;

void setup(){
  mover=new AgentMover();
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

void draw(){
  background(0);
  mover.update();
  mover.computeEffect();
  sendEffect(mover.cutoff, mover.vibrato);
  mover.draw();
}
