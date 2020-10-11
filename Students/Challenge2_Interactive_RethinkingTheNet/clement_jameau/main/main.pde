import processing.video.*;

Capture cam;


int cameraNum = 4;    // index of the camera we'll use in the camera list
int camFPS;
int camWidth;
int camHeight;

Pen myPen;          // object we will track (orange pen, Hue~9, Sat>200 at reasonable luminosity)

ArrayList<Edge> edges = new ArrayList<Edge>();  // Array of all the dots we'll print on the screen for the animation.

//------------------SETUP------------------
void setup() {
  //size(1280, 720);
  fullScreen();

  // Listing all available cameras and checking existence of wanted camera
  String[] cameras = Capture.list();
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else if (cameras.length <= cameraNum) {
    println("No camera of the following index: " + cameraNum);
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }

    // Initialising the wanted camera (index cameraNum)
    cam = new Capture(this, cameras[cameraNum]);
    cam.start();
    
    // Extracting the fps of the camera in its description string
    int p = cameras[cameraNum].indexOf("fps=");
    camFPS = Integer.parseInt(cameras[cameraNum].substring(p+4));
    println("\nfps of the chosen camera: " + camFPS);
    
    myPen = new Pen(0,0,20);  // Initialisation of the Pen object
    
    frameRate(min(30,camFPS));
  }
}//--------------END OF SETUP--------------

//------------------DRAW-------------------
void draw() {
  if (! cam.available()) {
    return;
  }
  //acquiring the camera capture, treating/scaling and printing it
  cam.read();
  PImage img=createImage(cam.width, cam.height, RGB);
  copy2imgReverseAndDarken(cam, img); 
  
  int resizeFactor = 1;
  if (img.width>0) {
    if(img.width != width){
      resizeFactor = width/img.width;
      img.resize(resizeFactor*img.width, resizeFactor*img.height);
    }
    image(img, 0, 0);
  }
  //updating the pen position
  myPen.updatePen(cam, resizeFactor);
  
  //circle(myPen.x, myPen.y, myPen.inclination);
  //println(myPen.inclination);    // random debug
  
  //if frameRate too high, we don't want to create a new dot at each frame. 
  int divisionFrameRate = 1;
  if(frameRate>10){divisionFrameRate=int(frameRate/10);}
  
  //Adding the dot (or edge) as well as computing its color, depending on the actual pen inclination
  if(frameCount%divisionFrameRate==0){
    color actualColor;
    if(myPen.inclination<110){
      actualColor = color(210,60,60);
    }else if(myPen.inclination<190){
      actualColor = color(180,100,100);
    }else if(myPen.inclination<270){
      actualColor = color(180,150,150);
    }else if(myPen.inclination<360){
      actualColor = color(180,180,180);
    }else if(myPen.inclination<440){
      actualColor = color(150,170,200);
    }else{
      actualColor = color(140, 140, 255);
    }
    Edge newEdge = new Edge(myPen.x,myPen.y, actualColor);
    edges.add(newEdge);
  }
    
  // Finally: drawing all the lines between the edges, respecting color code of the most recent ones
  for(int i=edges.size()-1; i>=0; i--){
    Edge edge1 = edges.get(i);
    stroke(edge1.col);
    for(int j=i-1; j>=0; j--){
      Edge edge2 = edges.get(j);
      line(edge1.x, edge1.y, edge2.x, edge2.y);
      }
    }
  
  if (edges.size() > 20){
    edges.remove(0);
  }
}// ------------------END OF DRAW------------------


// This function is used to copy the capture into an image while rescaling it, reversing it to make it act as a mirror, and applying an RGB transform to darken it
void copy2imgReverseAndDarken(Capture camera, PImage img) {
  img.loadPixels();
  for (int i=0; i<camera.width*camera.height; i++) {
    int remappedIndex = i+camera.width-2*(i%camera.width)-1;
    img.pixels[i]=color(red(camera.pixels[remappedIndex])/5,green(camera.pixels[remappedIndex])/14,blue(camera.pixels[remappedIndex])/14);
  }
  img.updatePixels();
}
