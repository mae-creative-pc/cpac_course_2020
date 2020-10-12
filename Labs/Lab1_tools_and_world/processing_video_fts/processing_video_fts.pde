/*
This code works with webcam, which unfortunately is not 
currently supported for macOS. If you want to use it,
you need to rely on some not straightforward workaround which you
can find here https://github.com/processing/processing-video/issues/134#issuecomment-617301980

However, since it is quite hard to follow, if you are
a macOS user, I suggest you to use processing_video_fts_mov script,
which performs the same effects on a video file.

*/

import gab.opencv.*; 
import processing.video.*;

Capture cam;
PImage old_frame;
PImage diff_frame;
boolean is_first_frame=true; 

/* EFFECTS CODE */
int NO_EFFECT=0;
int EFFECT_SWITCH_COLORS=1;
int EFFECT_DIFF_FRAMES=2;
int EFFECT_OPTICAL_FLOW=3;

int effect=NO_EFFECT;

OpenCV opencv=null;


void setup() {
  size(640, 480);

  String[] cameras = Capture.list();

  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }
    
    // The camera can be initialized directly using an 
    // element from the array returned by list():
    cam = new Capture(this, cameras[3]);
    cam.start();
    
  }
  
}

void copy2img(Capture camera, PImage img) {
  img.loadPixels();
  for (int i=0; i<camera.width*camera.height; i++) {
    img.pixels[i]=camera.pixels[i];
  }
  img.updatePixels();
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
  for (int i=0; i<cam.width*cam.height; i++) {
    float[] old_colors=getColors(old_frame.pixels[i]); //<>//
    float[] colors=getColors(img.pixels[i]);
    diff_frame.pixels[i]=color(abs(colors[0]-old_colors[0]), 
                                abs(colors[1]-old_colors[1]), 
                                abs(colors[2]-old_colors[2]));
    
  }
  diff_frame.updatePixels();
  copy_img(img, old_frame);
  copy_img(diff_frame, img);
  
}
void changeColors(PImage img){
  img.loadPixels();
  for (int i=0; i<img.width*img.height; i++) {
    img.pixels[i]=color(blue(img.pixels[i]),
                        red(img.pixels[i]),
                        green(img.pixels[i]));
  }
  img.updatePixels();
  
}
int max_M=0;
int min_M=0;
void opticalFlow(PImage img){
  opencv.loadImage(img);
  opencv.calculateOpticalFlow();
  int grid_size=10;
  int half_grid=5;
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
       
       line(c_x, c_y, c_x+min(aveFlow.x*half_grid, half_grid), c_y+min(aveFlow.y*half_grid, half_grid));
    }
  }
}

void draw() {
  if (! cam.available()) {return;}
  cam.read();
  if(opencv ==null){
    opencv = new OpenCV(this, cam.width, cam.height);
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
