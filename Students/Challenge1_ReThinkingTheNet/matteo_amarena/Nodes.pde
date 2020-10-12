public class Node {
  int xpos;
  int ypos;
  
  Node (int x, int y) {
  xpos = x;
  ypos = y;
}
  float getColor(float x1, float y1, float x2, float y2){
    float d = dist(x1, y2, x2, y2);
    return map(d, 0 , max(width,height), 0, 255);
  }
}
