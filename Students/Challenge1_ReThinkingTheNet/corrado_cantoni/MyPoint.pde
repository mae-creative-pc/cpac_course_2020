class MyPoint{
 
  float x,y;
  float size;
  color c;
  
  public MyPoint(float x,float y,float size, color c){
  this.x = x;
  this.y = y;
  this.size = size;
  this.c = c;
  
  }
  
  public void plot(float newX, float newY){
   x = newX;
   y = newY;
   ellipse(x,y,size,size);
  }
}
