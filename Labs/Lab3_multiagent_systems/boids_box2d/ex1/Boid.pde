class Boid{
    Body body;
    Box2DProcessing  box2d;
    color defColor = color(200, 200, 200);
    color contactColor;
    
    SoundFile sample;
    Boid(Box2DProcessing  box2d, CircleShape ps, BodyDef bd, Vec2 position){
        this.box2d = box2d;    
        bd.position.set(position);
        this.body = this.box2d.createBody(bd);
        this.body.m_mass=1;
        //this.body.setLinearVelocity(new Vec2(0,3));       
        this.body.createFixture(ps, 1);
        this.body.setUserData(this);        
    }
    void applyForce(Vec2 force){
      this.body.applyForce(force, this.body.getWorldCenter());
      
    }
    void draw(){
        Vec2 posPixel=this.box2d.getBodyPixelCoord(this.body);
        
        fill(this.defColor);
        stroke(0);
        strokeWeight(0);        
        ellipse(posPixel.x, posPixel.y, RADIUS_BOID, RADIUS_BOID);  

        
    }
    void kill(){
        this.box2d.destroyBody(this.body);
    }

   
    void update(ArrayList<Boid> boids){
      Vec2 myPosW=this.body.getPosition();
      Vec2 myVel=this.body.getLinearVelocity();
      Vec2 otherPosW;
      Vec2 otherVel;
      Vec2 direction;
      float dist;
      float steerAwayDist=6;
      float steerTowardDist=25;
      Vec2 velToward=new Vec2(0,0);
      for(Boid other: boids){
        if(this.body==other.body){continue;}
        otherPosW=other.body.getPosition();
        direction=otherPosW.sub(myPosW);        
        dist=direction.length();        
        if(dist<steerAwayDist){
          direction.mulLocal(-20/dist); // getting away from the other guy + normalization         
          this.applyForce(direction.sub(myVel)); // Using the steering formulas 
        }
        else if(dist<steerTowardDist){
            otherVel=other.body.getLinearVelocity();
            velToward.addLocal(otherVel.mul(1/otherVel.length()));        
        }
      }
      if(velToward.length()>0){this.applyForce(velToward.mul(5/velToward.length()).sub(myVel));}
    }

}
