

import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress ip_port;
int PORT = 57120;
PVector CENTER_SCREEN;
float ALPHA_BACKGROUND=20;
float probChanging=0.1;
int NUM_WALKERS=1;
Walker walkers[];
int W=0;
void setup() {
  size(1280,720);
  // Create a walker object
  walkers= new Walker[NUM_WALKERS];
  for (int i=0; i<NUM_WALKERS; i++){
     walkers[i]= new Walker();
     walkers[W].strokeWeight=1;
  }
  walkers[W].strokeWeight=5;
  
  background(0);
  CENTER_SCREEN=new PVector(width/2, height/2);
  oscP5 = new OscP5(this,12000);
  ip_port = new NetAddress("127.0.0.1",PORT);
}



void sendEffect(Walker w){
    OscMessage msg = new OscMessage("/note_effect");    
    
    msg.add(w.freq);
    msg.add(w.amp);
    msg.add(w.cutoff);
    msg.add(w.vibrato);
    oscP5.send(msg, ip_port);
}

void draw() {
  // Run the walker object
  fill(0, ALPHA_BACKGROUND);
  strokeWeight(0);
  rect(0,0,width, height);
  for (int i=0; i<NUM_WALKERS; i++){
     walkers[i].update();
     walkers[i].computeEffect();
     walkers[i].draw();
  }
  
  sendEffect(walkers[W]);
  
}
