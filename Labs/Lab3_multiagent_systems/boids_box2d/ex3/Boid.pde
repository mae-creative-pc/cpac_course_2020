
float AVOID_DIST=6;
float ALIGN_DIST=25;
class Boid{
    Body body;
    Box2DProcessing  box2d;
    color defColor = color(200, 200, 200);
    color contactColor;
    int nextPoint;
    Boid(Box2DProcessing  box2d, CircleShape ps, BodyDef bd, Vec2 position, int nextPoint){
        this.box2d = box2d;    
        bd.position.set(position);
        this.body = this.box2d.createBody(bd);
        this.body.m_mass=1;
        this.body.createFixture(ps, 1);
        this.body.getFixtureList().setRestitution(0.8);
        this.body.setUserData(this);        
        this.nextPoint=nextPoint;
    }
    void applyForce(Vec2 force){
      this.body.applyForce(force, this.body.getWorldCenter());      
    }
    void draw(){
        /* your code*/
        Vec2 posPixel=this.box2d.getBodyPixelCoord(this.body);
       
        fill(this.defColor);
        stroke(0);
        strokeWeight(0);        
        ellipse(posPixel.x, posPixel.y, RADIUS_BOID, RADIUS_BOID);     
    }
    
    void update(ArrayList<Boid> boids){
      Vec2 myPosW=this.body.getPosition();
      Vec2 myVel=this.body.getLinearVelocity();
      Vec2 otherPosW;
      Vec2 otherVel;
      Vec2 direction;
      float dist;
      Vec2 align_force=new Vec2(0,0);
      Vec2 avoid_force=new Vec2(0,0);
      
      for(Boid other: boids){        
        if(this.body==other.body){continue;}
        // your code
        
      }
      // your code
      if(avoid_force.length()>0){this.applyForce(avoid_force);}
      if(align_force.length()>0){this.applyForce(align_force);}
    }
    
    void kill(){
        this.box2d.destroyBody(this.body);
    }

   
}
