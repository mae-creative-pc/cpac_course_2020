PVector CENTER_SCREEN;
float ALPHA_BACKGROUND=0;

Walker walker;
void setup() {
  size(1280,720);

  CENTER_SCREEN=new PVector(width/2, height/2); 
  walker=new Walker();  // Create a walker object
  background(0); 
}

void draw() {
  // Run the walker object
  fill(0, ALPHA_BACKGROUND);
  strokeWeight(0);
  rect(0,0,width, height);
  walker.update();
  walker.draw();  
}
