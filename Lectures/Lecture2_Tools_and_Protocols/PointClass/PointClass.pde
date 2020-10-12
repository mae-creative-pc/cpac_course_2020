
float offset = 5;
color c;

MyPoint p1;
MyPoint p2;

void setup(){
  size(800,800);
  background(255,255,255);
  frameRate(10);
  c = color(255, 204, 0);
  p1 = new MyPoint(10,10,10, c);
  p1.plot();
}


void draw(){ 
  p1.move(offset,offset+1);
  p1.plot();
}
