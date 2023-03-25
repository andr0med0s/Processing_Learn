// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

class Mover {

  PVector position;
  PVector velocity;
  PVector acceleration;
  float mass;

  float a = 0.0;
  float aVelocity = 0.0;
  float aAcceleration = 0.001;

  Mover(float m, float x, float y) {
    mass = m;
    position = new PVector(x, y);
    velocity = new PVector(1, 0);
    acceleration = new PVector(0, 0);
  }

  void applyForce(PVector force) {
    PVector f = PVector.div(force, mass);
    acceleration.add(f);
  }

  void update() {

    aAcceleration = acceleration.x/10.0;
    
    a += aVelocity; 
    aVelocity += aAcceleration;

    velocity.add(acceleration);
    position.add(velocity);
    acceleration.mult(0);
  }

  void display() {
    stroke(0);
    strokeWeight(2);
    fill(0, 100);

    pushMatrix();
    translate(position.x, position.y);
    rotate(a);
    //ellipse(0, 0, mass*25, mass*25);
    rectMode(CENTER);
    rect(0, 0, mass*25, mass*25);
    popMatrix();
  }
}
