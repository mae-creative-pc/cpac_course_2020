int N = 18;
int index = 0;
point[] points = new point[N];

class point{
  float x;
  float y;
  point(float x,float y){//constructor
    this.x = x;
    this.y = y;
  }
}

void setup(){
  background(0);
  size(500,500);
  frameRate(15);
  for (int i=0;i<N;i++){
    points[i] = new point(0,0);//init array
  }
}

void draw(){
  clear();
  for (int i=N-1; i>0; i--){
    points[i] = points[i-1];//update point array
  }
  points[0] = new point(mouseX,mouseY);
  for (int h=0;h<N;h++){
    for(int j=h+1;j<N;j++){
      stroke(255,200,180,255*(N-j)/N);//change the opacity of the line
      line(points[h].x,points[h].y,points[j].x,points[j].y);//draw the line
    }
  }
}
