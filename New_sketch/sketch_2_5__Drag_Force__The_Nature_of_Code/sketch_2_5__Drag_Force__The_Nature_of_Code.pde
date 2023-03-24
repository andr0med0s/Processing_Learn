Mover m;

void setup() {
  size(640, 360);
  m = new Mover();
}

void draw() {
  background(255);

  PVector gravity = new PVector(0, 0.3);
  gravity.mult(m.mass);
  m.applyForce(gravity);
  //PVector wind = new PVector(0.2, 0);
 //  m.applyForce(wind);

  //применение трения
  if (mousePressed) {
    PVector drag = m.velocity.copy();
    drag.normalize();
    float c = -0.03;
    float speed = m.velocity.mag();
    
    drag.mult(c*speed*speed);
    m.applyForce(drag);
  }

  m.update();
  m.edges();
  m.display();
}
