import gab.opencv.*; 
import processing.video.*;

Movie cam; // instead of a camera, we use a movie 
PImage old_frame;
PImage diff_frame;
boolean is_first_frame=true; 

/* EFFECTS CODE */
int NO_EFFECT=0;
int EFFECT_SWITCH_COLORS=1;
int EFFECT_DIFF_FRAMES=2;
int EFFECT_OPTICAL_FLOW=3;

int effect=3;
float hue_shift=0;
OpenCV opencv=null;


void setup() {
  size(640, 480);
  cam = new Movie(this, "./sample.mp4");
  // You can download a sample mp4 from 
  // https://drive.google.com/file/d/1F2plrz0jfmjITTVhP66BHdb7Fw961S1E/view?usp=sharing
  // and place it in the data folder
  cam.loop();
  
  
}

void copy2img(Movie camera, PImage img) {
  img.loadPixels();
  for (int i=0; i<camera.width*camera.height; i++) {
    img.pixels[i]=camera.pixels[i];
  }
  img.updatePixels();
  img.resize(640, 480); // comment this line if you don't need to resize it
}

void copy_img(PImage src, PImage dst) {
  dst.set(0,0,src);
}


float[] getColors(color pixel) {
  float[] colors={red(pixel), blue(pixel),green(pixel)};
  return colors;
}

void effectDiffFrames(PImage img){
  if (is_first_frame) {
    old_frame = createImage(img.width, img.height, RGB);
    diff_frame = createImage(img.width, img.height, RGB);
    copy_img(img, old_frame);
    is_first_frame=false;
    img = createImage(0, 0, RGB);
    return; 
  }
  diff_frame.loadPixels();
  old_frame.loadPixels();  
  
  /* your code here*/
   //<>//
  diff_frame.updatePixels();
  copy_img(img, old_frame);
  copy_img(diff_frame, img);
  
}
void changeColors(PImage img){
  img.loadPixels();
  float h, s, b;
  colorMode(HSB, 255);
  for(int i=0; i<img.pixels.length; i++){
    h = hue(img.pixels[i]);
    s = saturation(img.pixels[i]);
    b = brightness(img.pixels[i]);
    img.pixels[i]=color((h+hue_shift)%255, s, b);
  }
  hue_shift+=1;
  img.updatePixels();
  colorMode(RGB, 255);
  
}
int max_M=0;
int min_M=0;
void opticalFlow(PImage img){
  opencv.loadImage(img);
  opencv.calculateOpticalFlow();
  int grid_size=10;
  int half_grid=grid_size/2;
  float sqrt_grid=(float)Math.sqrt(half_grid);
  int c_x=0;
  int c_y=0;
  PVector aveFlow;
  image(img,0,0);
  stroke(255,0,0);
  strokeWeight(2);
  
  for (int w=0; w<img.width; w+=grid_size){
    for (int h=0; h<img.height; h+=grid_size){
       aveFlow = opencv.getAverageFlowInRegion(w, h, grid_size, grid_size);
       c_x=w+half_grid;
       c_y=h+half_grid;
       if(aveFlow.x + aveFlow.y > 5) // comment this if you want to view every optical flow
          line(c_x, c_y, c_x+min(aveFlow.x*half_grid, sqrt_grid), c_y+min(aveFlow.y*half_grid, sqrt_grid));
    }
  }
}

void draw() {
  if (! cam.available()) {return;}
  cam.read();
  if(opencv ==null){
    opencv = new OpenCV(this, 2*cam.width, 2*cam.height);
  }
  PImage img=createImage(cam.width,cam.height,RGB);
  copy2img(cam, img);
  if(effect==EFFECT_OPTICAL_FLOW){
     opticalFlow(img);
     return; 
  }
  else if(effect==EFFECT_DIFF_FRAMES){
     effectDiffFrames(img);
  }
  else if(effect==EFFECT_SWITCH_COLORS){
    changeColors(img);
  }
  else{
    /*NO EFFECT*/;
  }
  
  
  
  if(img.width>0){
    image(img, 0, 0);
  }

}
