int positionsx[];
int positionsy[];
int L = 50;
int dotsize = 5;
color dotcolor = color(255);

void setup() {
  
  size(1024, 576);
  
  positionsx = new int[L];
  positionsy = new int[L];
  
  //initializing the positions
  for ( int i=0; i<L; i = i+1){
    positionsx[i] = 0;
    positionsy[i] = 0;
  }
  
  frameRate(15); 
  background(0,0,0);
}

void draw() { 
  
  background(0,0,0);
  
  positionsx = append(positionsx, mouseX);
  positionsy = append(positionsy, mouseY);
  
  for (int i = 0; i < L-1; i = i+1){
    
    MyPoint node = new MyPoint(positionsx[i], positionsy[i], dotsize, dotcolor);
    node.plot(dotsize, dotcolor);
    
    for(int j = 0; j<L-1; j = j+1){
      
      stroke(185,155);
      line(positionsx[i], positionsy[i], positionsx[j+1], positionsy[j+1]);
      
    }
  }
  
  //Updating the positions
  positionsx = subset(positionsx,1,L-1);
  positionsy = subset(positionsy,1,L-1);
}
