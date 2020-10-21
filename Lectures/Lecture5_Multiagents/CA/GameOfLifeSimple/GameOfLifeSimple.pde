
// A basic implementation of John Conway's Game of Life CA

GOL gol;

void setup() {
  size(400, 400);
  smooth();
  gol = new GOL();
}

void draw() {
  background(255);

  gol.generate();
  gol.display();
}

// reset board when mouse is pressed
void mousePressed() {
  gol.init();
}
