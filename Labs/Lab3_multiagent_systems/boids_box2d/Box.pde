class Box{
    Body body;
    Box2DProcessing  box2d;
    color defColor = color(200, 200, 200);
    color contactColor;
    float time_to_color,time_index;
    int nextPoint;
    SoundFile sample;
    Box(Box2DProcessing  box2d, CircleShape ps, BodyDef bd, Vec2 position, SoundFile sample, int nextPoint){
        this.box2d = box2d;    
        bd.position.set(position);
        this.body = this.box2d.createBody(bd);
        this.body.m_mass=1;
        //this.body.setLinearVelocity(new Vec2(0,3));       
        this.body.createFixture(ps, 1);
        this.body.setUserData(this);
        this.sample=sample;
        this.time_to_color=this.sample.duration()*frameRate;
        this.time_index=time_to_color;
        this.nextPoint=nextPoint;
        colorMode(HSB, 255);
        this.contactColor= color(random(0,255),255,255);
        colorMode(RGB, 255);
    }
    void applyForce(Vec2 force){
      this.body.applyForce(force, this.body.getWorldCenter());
      
    }
    void draw(){
        Vec2 posPixel=this.box2d.getBodyPixelCoord(this.body);
        
        fill(lerpColor(this.contactColor, this.defColor, map(this.time_index, 0, this.time_to_color,0,1)));
        stroke(0);
        strokeWeight(0);        
        ellipse(posPixel.x, posPixel.y, RADIUS_CIRCLE, RADIUS_CIRCLE);  

        this.time_index=min(this.time_index+1, this.time_to_color);
        
    }
    void kill(){
        this.box2d.destroyBody(this.body);
    }

    void changeColor(){
        this.time_index=0;
    }
    void play(){
     // this.sample.jump(0);
     if(! this.sample.isPlaying())      this.sample.play();    
    }
    void update(ArrayList<Box> boxes){
      Vec2 myPosW=this.body.getPosition();
      Vec2 myVel=this.body.getLinearVelocity();
      Vec2 otherPosW;
      Vec2 otherVel;
      Vec2 direction;
      float dist;
      float steerAwayDist=6;
      float steerTowardDist=25;
      Vec2 velToward=new Vec2(0,0);
      for(Box other: boxes){
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
