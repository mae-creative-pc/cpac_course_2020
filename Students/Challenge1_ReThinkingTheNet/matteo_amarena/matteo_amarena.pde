ArrayList<Node> nodes = new ArrayList<Node>();
void setup() {
  size(800, 800);
  frameRate(24); //  fps for avoiding overlap effect
  //initialise with 5 random points
  for(int j = 0; j < 5; j++){
    nodes.add(new Node(round(random(width)),round(random(height))));
  }
  background(10);
  strokeWeight(0.5);
  
}

void draw() {
  background(10);
  
    nodes.add(new Node(mouseX,mouseY));
    for(Node n : nodes){
      stroke(255);
      circle(mouseX,mouseY,5);
      circle(n.xpos,n.ypos,5);
      
      int current_node = nodes.indexOf(n);
      for(int i = 0; i < nodes.size(); i++){
        if(i != current_node){
          float c = n.getColor(n.xpos, n.ypos, nodes.get(i).xpos, nodes.get(i).ypos);
          stroke(c);
          line(n.xpos, n.ypos, nodes.get(i).xpos, nodes.get(i).ypos);
        }
      }
    }
  
    if (nodes.size() > 30){
      nodes.remove(0);
  }
  
}
