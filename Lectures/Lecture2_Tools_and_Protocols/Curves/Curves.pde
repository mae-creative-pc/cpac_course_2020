


void setup(){
  size(200,200);
}

void draw(){
  
  noFill();
  stroke(255, 102, 0);
  line(85, 20, 10, 10);
  line(90, 90, 15, 80);
  stroke(0, 0, 0);
  bezier(85, 20, 10, 10, 90, 90, 15, 80);
  
  beginShape();
  for (int i=0; i<20; i++){
    int y = i%2;
    vertex(i*10, 50+y*10);
  }
  endShape();
}
