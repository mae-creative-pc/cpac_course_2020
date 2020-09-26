int numPoints = 100;
int numConnections = 3;
float x = 0, y = 0;
float prevx = 0, prevy = 0;
float pointSize = 3.5;
color pointColor, lineColor;
int colorstep = 8;
int numColors = (256*6)/colorstep;
color [] rainbow = new color[numColors];
int r = 0, g = 0, b = 0;
float lineWeight = 0.5;
MyPoint [] points = new MyPoint[numPoints];
int currentIndex = 0;
float xoff = 1;

void setup() {
  // Build the rainbow array:
  int j = 0;
  for (int i = 0; i< 256; i += colorstep) {
    rainbow[j] = color(255, 0, i);
    j++;
  }
  for (int i = 0; i< 256; i += colorstep) {
    rainbow[j] = color(255 - i, 0, 255);
    j++;
  }
  for (int i = 0; i< 256; i += colorstep) {
    rainbow[j] = color(0, i, 255);
    j++;
  }
  for (int i = 0; i< 256; i += colorstep) {
    rainbow[j] = color(0, 255, 255-i);
    j++;
  }
  for (int i = 0; i< 256; i += colorstep) {
    rainbow[j] = color(i, 255, 0);
    j++;
  }
  for (int i = 0; i< 256; i += colorstep) {
    rainbow[j] = color(255, 255 - i, 0);
    j++;
  }
  print(j);
  size(1920, 1080);
  frameRate(10);
  noStroke();
  background(0);
  pointColor = color(255,255,255);
  lineColor = color(150,150,150);
  for (int i = 0; i<numPoints; i++) {
    // Initial position: scatter points on the canvas
    points[i] = new MyPoint(random(width), random(height), pointSize, pointColor); 
  }
  
}

void draw() { 
  background(0);
  x = mouseX;
  y = mouseY;
  if (x == prevx && y == prevy) { // If the mouse doesn't move, print dots in the surrounding without superposing
    x += int(map(noise(xoff), 0, 1, -20, 20));
    y += int(map(noise(xoff+50), 0, 1, -20, 20)); // +50 to have uncorrelated coordinates
  }
  
  lineColor = rainbow[int(xoff)%numColors];
  pointColor = lineColor;
  xoff++;
  points[currentIndex].move(x,y);
  for (int i = 0; i<numPoints; i++) { 
    points[i].plot(pointSize, pointColor);
    randomSeed(i); // Print the same random lines at every frame
    for (int j = 0; j<numConnections; j++) { // For every point, create j random connections 
      MyPoint randPoint = points[(i + (int(random(numPoints))))%numPoints];
      stroke(lineColor);
      strokeWeight(lineWeight);
      line(points[i].x, points[i].y, randPoint.x, randPoint.y);
    }
  }
  int indexJump = int(map(noise(xoff+100), 0, 1, 0, 500))%100; // Avoid deleting points with a LIFO policy to create randomness
  currentIndex = (currentIndex + indexJump)%numPoints;
  prevx = x;
  prevy = y;
}
