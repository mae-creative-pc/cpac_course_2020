ArrayList<MyPoint> pointsList = new ArrayList<MyPoint>();
import java.util.*; 
int frame;
color pointColor;

void setup(){
    noCursor();
  size(1024, 576);
  frameRate(120);
  background(0,0,0);
  pointColor = color(255,125);
  //initialize
  int i = 1;
  while(i <13){
    pointsList.add(new MyPoint(random(width),random(height),5,pointColor));
    i++;
  }

}
int pointIndex;
void draw(){
  frame ++;  
  background(0,0,0);
  
  if (frame%5==0){
  pointsList.add(new MyPoint(mouseX,mouseY,5,pointColor));
  }
  for (MyPoint point : pointsList) {
    point.plot();
    
    pointIndex = pointsList.indexOf(point);
    
    //if (pointIndex>(pointsList.size()/2)){
      stroke(185,155);
      line(mouseX,mouseY,point.x,point.y);
    //}
    for (int i = 1; i< pointsList.size()/2; i++){
      if (i!=pointIndex) 
        line(point.x, point.y , pointsList.get(i).x, pointsList.get(i).y);
    }
  }
  if (pointsList.size()>35){
    pointsList.remove(0);
  }
  if (frame == 100)
    frame = 0;
}
