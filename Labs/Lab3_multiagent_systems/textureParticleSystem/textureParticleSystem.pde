ParticleSystem ps;
int Nparticles=1000;
PImage img;

MicInput mic;
void setup(){
  size(1280,720, P2D);
  PVector origin=new PVector(0.75*width, height);
  ps=new ParticleSystem(origin);
  for(int p=0; p<Nparticles; p++){
    ps.addParticle();
  }
  img=loadImage("texture.png");
  mic=new MicInput();
  
  background(0);
}

void draw(){
  blendMode(ADD);
  background(0);
  PVector wind= new PVector(map(mouseX, 0, width, -.2, .2),0);
  float energy= mic.getEnergy();
  println(energy);
  ps.action(new PVector(energy*random(-.4,-.1),energy*random(-.5,-.1)));  
  //ps.action(wind);
}
