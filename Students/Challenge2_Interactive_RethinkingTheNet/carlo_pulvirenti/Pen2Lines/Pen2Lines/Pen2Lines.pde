import processing.video.*;

Capture cam;
color trackColor; 
MyPoint p;
int size;
color c;
int dim=0;
ArrayList<Float> x=new ArrayList<Float>();
ArrayList<Float> y=new ArrayList<Float>();
float r1,r2,g1,g2,b1,b2;



void setup() {

  
  String[] cameras = Capture.list();
  
  if (cameras.length == 0) {
    println("Error, no camera available");
    exit();
  }else{
    cam = new Capture(this, cameras[0]);
    cam.start();     
  } 
  trackColor = color(0, 0, 250);
  frameRate(25);
  
  c = color(255, 255, 255);
  p = new MyPoint(10,10,40, c);
  size=7;
  noStroke();
  size(640,480);

}

void draw() {
  clear();
   background(50,50,50);
  if (cam.available() == true) {
    cam.read();
  }

  cam.loadPixels();
  
  float mindistance = 500; 
  int closestX = 0;
  int closestY = 0;
  
  for (int x = 0; x < cam.width; x ++ ) {
    for (int y = 0; y < cam.height; y ++ ) {
      int loc = x + y*cam.width;

      color currentColor = cam.pixels[loc];
      r1 = red(currentColor);
      g1 = green(currentColor);
      b1 = blue(currentColor);
      r2 = red(trackColor);
      g2 = green(trackColor);
      b2 = blue(trackColor);

      // Using euclidean distance to compare colors
      float d = dist(r1, g1, b1, r2, g2, b2); 

      if (d < mindistance) {

        mindistance = d;
        closestX = x;
        closestY = y;
      }
    }
  }
  if (mindistance < 200) { 
    x.add(cam.width-new Float(closestX));
    y.add(new Float(closestY));
    if(x.size()>50){
      x.remove(0);
      y.remove(0);
    }
    for(int i=0;i<x.size();i++){
        p.move(x.get(i),y.get(i));
        p.plot(size,c);
        for(int ii=0;ii<i;ii++){
          fill(255,255,255);
          stroke(150,150,150,50);
          line(x.get(ii),y.get(ii),x.get(i),y.get(i));
        }
     }
  }
}
