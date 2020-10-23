PVector CENTER_SCREEN;
float ALPHA_BACKGROUND=0;
int MONTECARLO_STEPS=1;

Walker walker;
void setup() {
  size(1280,720);

  walker=new Walker();  // Create a walker object
  background(0);
  CENTER_SCREEN=new PVector(width/2, height/2);  
}

void draw() {
  // Run the walker object
  fill(0, ALPHA_BACKGROUND);
  strokeWeight(0);
  rect(0,0,width, height);
  walker.update();
  walker.draw();  
}
