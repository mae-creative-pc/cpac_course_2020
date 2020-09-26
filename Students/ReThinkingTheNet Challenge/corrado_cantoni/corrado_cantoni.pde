MyPoint p;
boolean blocked = true;
float x,y, size=4;
float x1,y1,x2, y2;
color c;
int n= 40 ; // number of iterations

float[] MouseX = new float [n];
float[] MouseY = new float [n];

void setup(){

  // noCursor();
  // noLoop();
  fullScreen();
  // size(1024, 768);
  background(59,59,59);
  frameRate(4);
  
  c = color(222);
  p = new MyPoint(x,y,size,c);
  
}

int t = 0;

void draw(){
  stroke(222);
  strokeWeight(0.1);
  
  MouseX[t] = mouseX;
  MouseY[t] = mouseY;
  
  // background refresh
  background(59,59,59);

  for (int i=0; i < n; i++){
    for(int j=0; j<n; j++){
      if(MouseX[i] !=0 && MouseY[i] != 0 && MouseX[j] !=0 && MouseY[j] != 0){
        p.plot(MouseX[i], MouseY[i]); // draw the points
        line(MouseX[i], MouseY[i], MouseX[j], MouseY[j]); // draw the lines
      }
    }
  }
  
  t++;

  if (t>=n-1){t = 0;}
}


// start by pressing a mouse key
/*
void mousePressed(){
  if (blocked==true){
    blocked = false;
    loop();
  }
  else if (blocked == false){
    blocked = true;
    noLoop();
    
    for (int i=0; i<n; i++){
      MouseX[i] = 0;
      MouseY[i] = 0;
    }
  }
}
*/
