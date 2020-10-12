// Object representing the pen that the camera is tracking.
class Pen{
  
  int x,y;
  float inclination;
  float alfa = 0.6; // coefficient of the low pass filter for the inclination
  
  //Constructor
  public Pen(int x, int y, float incl){
    this.x = x;
    this.y = y;
    this.inclination = incl;
  }
  
  // ---- Methods
  public void updatePen(Capture camera, float resizeFactor){
    IntList  pointsPenX = new IntList();
    IntList  pointsPenY = new IntList();
    for (int i=0; i<camera.width*camera.height; i++) {
      if(red(camera.pixels[i])>190 && blue(camera.pixels[i])<190 && green(camera.pixels[i])<190 && saturation(camera.pixels[i])>130 && hue(camera.pixels[i])<16 && hue(camera.pixels[i])>3){
        pointsPenX.append(i%camera.width);
        pointsPenY.append(i/camera.width);
      }
    }
    if(pointsPenX.size()>0){
      int xSum = 0;
      int ySum = 0;
      for (int i=0; i<pointsPenX.size(); i++) {
        xSum+=pointsPenX.get(i);
        ySum+=pointsPenY.get(i);
      }
      this.x = int(resizeFactor * (camera.width - xSum/pointsPenX.size()-1));
      this.y = int(resizeFactor * (ySum/pointsPenX.size()));
      //println("\nx= " + this.x);
      //println("y= " + this.y);
      // Inclination corresponds to the appearing length of the pen. I took the liberty to low pass filter this value (first order, parameter alfa), to smoother the variations.
      this.inclination = resizeFactor * (alfa*sqrt(pow((pointsPenX.max()-pointsPenX.min()),2)+pow((pointsPenY.max()-pointsPenY.min()),2))+ (1-alfa)*this.inclination);  
    }
  }
}
