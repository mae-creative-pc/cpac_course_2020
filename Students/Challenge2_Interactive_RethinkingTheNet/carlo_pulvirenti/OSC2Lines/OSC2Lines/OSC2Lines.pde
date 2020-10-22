import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

float xx,yy,zz;
float a=250,b=250;
float col,ccc=255;
float mulx=1,muly=1;
float prox=5;
float colorback=0,colorbacklines=0;;
float i;

MyPoint p;
int size;
color c;
int dim=0;
ArrayList<Float> x=new ArrayList<Float>();
ArrayList<Float> y=new ArrayList<Float>();
ArrayList<Integer> cc=new ArrayList<Integer>();

void setup() {
  size(1024, 576);
  frameRate(10);
  c = color(255, 255, 255);
  p = new MyPoint(10,10,40, c);
  size=1;
  noStroke();
  
  oscP5 = new OscP5(this,9000);
  myRemoteLocation = new NetAddress("127.0.0.1",9000);
}

void draw() { 
  clear();

  xx=xx*abs(mulx*5);
  yy=yy*abs(mulx*5);
  zz=round((zz+10)/20*10);
  
  if(prox==0){
      if(colorback>=50){
        colorback=colorback-10;
      }
    }
    if(prox==5){
      if(colorback<=200){
        colorback=colorback+10;
       } 
    }
  colorMode(RGB);
  background(colorback,colorback,colorback);
  
  if(a!=500&&a!=0){
    a=a-xx;
  }
  if(b!=500&&b!=0){
    b=b-yy;
  }
  if(b>=576) b=576-2;
  if(a>=1024) a=1024-2;
  if(a<=0) a=2;
  if(b<=0) b=2;
  x.add(new Float(a));
  y.add(new Float(b));
  cc.add(round((ccc+4000)/8096*255));
  if(x.size()>50){
    x.remove(0);
    y.remove(0);
    cc.remove(0);
  }
  for(int i=0;i<x.size();i++){
    p.move(x.get(i),y.get(i));
    colorMode(HSB);
    c=color(cc.get(i),255,255);
    p.plot(size*zz,c);
    for(int ii=0;ii<i;ii++){
      colorMode(RGB);
      fill(255,255,255);
      if(prox==0){
        colorbacklines+=10;
        if (colorbacklines>=200) colorbacklines=200;
        stroke(colorbacklines,colorbacklines,colorbacklines,50);
      }
      if(prox==5){
        colorbacklines-=10;
        if (colorbacklines<=100) colorbacklines=100;
        stroke(colorbacklines,colorbacklines,colorbacklines,50);
      }
      line(x.get(ii),y.get(ii),x.get(i),y.get(i));
    }
  }
  
}

void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.checkAddrPattern("/accelerometer")) {
    xx = round(theOscMessage.get(0).floatValue());
    yy = round(theOscMessage.get(1).floatValue()); 
    zz = round(theOscMessage.get(2).floatValue());
  }
  if (theOscMessage.checkAddrPattern("/gyroscope")) {
    mulx = round(theOscMessage.get(0).floatValue());
    muly = round(theOscMessage.get(1).floatValue());
    if (mulx==0) mulx=1;
    if (muly==0) muly=1;
  }
  if (theOscMessage.checkAddrPattern("/light")) {
    ccc=(theOscMessage.get(0).floatValue());
  }
  if (theOscMessage.checkAddrPattern("/proximity")) {
    prox=round((theOscMessage.get(0).floatValue()));
  }
}
