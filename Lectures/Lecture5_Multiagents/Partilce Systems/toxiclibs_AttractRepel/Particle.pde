// class Spore extends the class "VerletParticle2D"
class Particle extends VerletParticle2D {

  float r;

  Particle (Vec2D loc) {
    super(loc);
    r = 2;
    physics.addParticle(this);
    physics.addBehavior(new AttractionBehavior2D(this, r*3, -0.1)); //(p, distance, strength)
  }

  void display () {
    fill (127,100);
    //stroke (0);
    //strokeWeight(2);
    noStroke();
    ellipse (x, y, r*2, r*2);
  }
}
