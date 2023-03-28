PVector origin;
Mover bob;
float restLength;

void setup() {
  size(640, 360);
  restLength = 200;
  origin = new PVector(width/2, 0);
  bob = new Mover(width/2, 240);
}

void draw() {
  background(255);
  line(origin.x, origin.y, bob.location.x, bob.location.y);
  
  PVector spring = PVector.sub(bob.location,origin);
  float currentLength = spring.mag();
  spring.normalize();
  float k = 0.05;
  float stretch = currentLength - restLength;
  spring.mult(-k*stretch);
  
  bob.applyForce(spring);
  
  PVector wind = new PVector(0.1, 0);
  if(mousePressed){
    bob.applyForce(wind);
  }
  
  PVector gravity = new PVector(0, 0.1);
  bob.applyForce(gravity );
  
  bob.update();
  bob.display();
}
