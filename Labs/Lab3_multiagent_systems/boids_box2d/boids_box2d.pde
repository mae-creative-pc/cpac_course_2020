import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;
import processing.sound.*;

boolean DRAW_PATH=false;
boolean DRAW_ANCHORS=false;

float WIDTHBOX=30;
int RADIUS_CIRCLE=30;
float HEIGHTBOX=100;
float SCALEFORCE=100000;
float DIST_TO_NEXT=50;
String filenames[];
Box2DProcessing box2d;
BodyDef bd;
Boundaries boundaries;
PolygonShape ps;
CircleShape cs;
Path path;
ArrayList<Box> boxes;

Vec2 P2W(Vec2 in_value){
  return box2d.coordPixelsToWorld(in_value);
}

Vec2 P2W(float pixelX, float pixelY){
  return box2d.coordPixelsToWorld(pixelX, pixelY);
}

float P2W(float in_value){
  return box2d.scalarPixelsToWorld(in_value);
}

Vec2 W2P(Vec2 in_value){
  return box2d.coordWorldToPixels(in_value);
}

Vec2 W2P(float worldX, float worldY){
  return box2d.coordWorldToPixels(worldX, worldY);
}

float W2P(float in_value){
  return box2d.scalarWorldToPixels(in_value);
}


void setup() {
  size(1280, 720);
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  box2d.setGravity(0, 0);
  box2d.listenForCollisions();
  boxes=new ArrayList<Box>();
  boundaries=new Boundaries(box2d, width, height);
  bd= new BodyDef();
  bd.type= BodyType.DYNAMIC;
  ps= new PolygonShape();
  cs  = new CircleShape();
  cs.m_radius = P2W(RADIUS_CIRCLE/2);
  bd.linearDamping=0;
  bd.angularDamping=0;
  
  path=new Path(9, 0.3, 0.5);
  
  String path=sketchPath()+"/sounds";
  File dir = new File(path);
//  print(dir.isDirectory());
  filenames= dir.list();
//  println(filenames);
  
}
void mousePressed() {
 if(mouseButton==LEFT){//insert a new box
    int i= int(min(random(0, filenames.length), filenames.length-1));
    int p=path.closestTarget(P2W(mouseX, mouseY));
    while(!filenames[i].endsWith(".wav")){i= int(min(random(0, filenames.length), filenames.length-1));}
    Box b = new Box(box2d, cs, bd, P2W(mouseX, mouseY), new SoundFile(this, "sounds/"+filenames[i]),p);
    boxes.add(b);     
  }
  if(mouseButton==RIGHT){ 
    ;
  }
}

void beginContact(Contact cp) {
  Fixture f1 = cp.getFixtureA();
  Fixture f2 = cp.getFixtureB();
  Body body1 = f1.getBody();
  Body body2 = f2.getBody();
  Box b1 = (Box) body1.getUserData();
  Box b2 = (Box) body2.getUserData();
  if (b1!=null) {
    b1.play();
    b1.changeColor();
  }
  else{
  //  b2.bounce();
  }
  if (b2!=null) {  
    b2.play();
    b2.changeColor();
  }
  else{
  //   b1.bounce();
  }
}


void endContact(Contact cp) {
  ;
}

Vec2 computeForce(Box b){
  
  Vec2 posW= b.body.getPosition();
  Vec2 direction1= path.getDirection(posW, b.nextPoint);
  Vec2 direction2= path.getDirection(posW, path.nextPoint(b.nextPoint));
  Vec2 direction=direction1;
  if(direction.length() < P2W(DIST_TO_NEXT) || direction2.length() < direction1.length()){
    b.nextPoint=path.nextPoint(b.nextPoint);
    direction= direction2;
  }
  
  direction.mulLocal(20/direction.length());
  Vec2 velocity=b.body.getLinearVelocity();
  
  Vec2 steering = direction.sub(velocity);
  
  strokeWeight(2);
  stroke(255);
  Vec2 posP= W2P(posW);
  if(DRAW_ANCHORS){ line(posP.x, posP.y, path.pointsP[b.nextPoint].x, path.pointsP[b.nextPoint].y);}
  return steering;//.mulLocal(0.2);
}
 
void draw() {
  fill(0,50);
  rect(width/2, height/2, width, height);
//  background(0,200);
  if(DRAW_PATH){  path.draw();}
  box2d.step();
  boundaries.draw();
  for (Box b : boxes) {
    b.applyForce(computeForce(b));
    
    //path.draw(b.nextPoint);
    b.update(boxes);
    b.draw();
  }
}
