import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;

boolean DRAW_PATH=true;
boolean DRAW_ANCHORS=true;
int RADIUS_BOID=30;
float SCALEFORCE=100000;
float DIST_TO_NEXT=50;
String filenames[];
Box2DProcessing box2d;
BodyDef bd;
Boundaries boundaries;
CircleShape cs;
Path path;
ArrayList<Boid> boids;

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
  boids=new ArrayList<Boid>();
  boundaries=new Boundaries(box2d, width, height);
  bd= new BodyDef();
  bd.type= BodyType.DYNAMIC;
  cs  = new CircleShape();
  cs.m_radius = P2W(RADIUS_BOID/2);
  bd.linearDamping=0;
  path=new Path(9, 0.3, 0.5);
}
void mousePressed() {
 if(mouseButton==LEFT){//insert a new box
    int p=path.closestTarget(P2W(mouseX, mouseY));
    Boid b = new Boid(box2d, cs, bd, P2W(mouseX, mouseY), p);
    boids.add(b);     
  }
  if(mouseButton==RIGHT){ 
    ;
  }
}

Vec2 computeForce(Boid b){  
  Vec2 posW= b.body.getPosition();
  Vec2 direction1= path.getDirection(posW, b.nextPoint);
  Vec2 direction2= path.getDirection(posW, path.nextPoint(b.nextPoint));
  Vec2 direction=direction1;
  if(direction.length() < P2W(DIST_TO_NEXT) || direction2.length() < direction1.length()){
    b.nextPoint=path.nextPoint(b.nextPoint);
    direction= direction2;
  }
  // your code: compute steering
  Vec2 velocity=b.body.getLinearVelocity();

  Vec2 steering = new Vec2(0,0);  
  if(DRAW_ANCHORS){ 
    strokeWeight(2);
    stroke(255);
    Vec2 posP= W2P(posW);
    line(posP.x, posP.y, path.pointsP[b.nextPoint].x, path.pointsP[b.nextPoint].y);
  }
  return steering;
}
 
void draw() {
  fill(0,50);
  rect(width/2, height/2, width, height);
  if(DRAW_PATH){  path.draw();}
  box2d.step();
  boundaries.draw();
  for (Boid b : boids) {
    b.applyForce(computeForce(b));    
    b.draw();
  }
}
