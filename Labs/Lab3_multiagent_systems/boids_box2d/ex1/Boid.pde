class Boid{
    Body body;
    Box2DProcessing  box2d;
    color defColor = color(200, 200, 200);
    color contactColor;
    
    Boid(Box2DProcessing  box2d, CircleShape ps, BodyDef bd, Vec2 position){
        this.box2d = box2d;    
        bd.position.set(position);
        this.body = this.box2d.createBody(bd);
        this.body.m_mass=1;
        this.body.createFixture(ps, 1);
        this.body.getFixtureList().setRestitution(0.8);
        this.body.setUserData(this);        
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
    void kill(){
        this.box2d.destroyBody(this.body);
    }

   
}
