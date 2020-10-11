int nPoints =   100;
int nLines = 5; //lines exiting each point
int randomIndex;
int pIndex;

MyPoint[] points = new MyPoint[nPoints];
MyPoint p, q;
int[][] connections = new int[nPoints][nLines];

color backgroundColor = color(27,27,27);
color pointColor = color(120,120,120);
color lineColor = color(60,60,60);

float pointSize = 3;
float lineWidth = 1;

void setup() {
  size(1280, 720);
  frameRate(6);
  
  //initial points position
  for (int i = 0; i < nPoints; i++) {
    points[i] = new MyPoint(random(width), random(height), pointSize, pointColor);
  }
  
  //initial connections
  for (int i = 0; i < nPoints; i++) {
    for (int j = 0; j < nLines; j++) {
      randomIndex = int(random(float(nPoints)));
      connections[i][j] = randomIndex;
    }
  }
}

void draw() {
  background(backgroundColor);
  
  randomIndex = int(random(float(nPoints)));
  pIndex = randomIndex;
  
  p = points[pIndex]; //point to move
  p.move(mouseX, mouseY);
  
  for (int j = 0; j < nLines; j++) {
    randomIndex = int(random(float(nPoints)));
    connections[pIndex][j] = randomIndex;
  }
  
  
  for (int i = 0; i < nPoints; i++) {
    p = points[i];
    p.plot();
    for (int j = 0; j < nLines; j++) {
      q = points[connections[i][j]];
      
      noFill();
      stroke(lineColor);
      strokeWeight(lineWidth);
      line(this.p.x, this.p.y, this.q.x, this.q.y);
    }
  }
}
