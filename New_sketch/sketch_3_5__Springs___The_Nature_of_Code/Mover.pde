class Mover {

  PVector location;
  PVector velocity;
  PVector acceleration;
  float mass;

  Mover(float x, float y) {
    location = new PVector(x, y);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    mass = 1;
  }

  void applyForce(PVector force) {
    PVector f = PVector.div(force, mass);
    acceleration.add(f);
  }
  
  void update(){
    velocity.add(acceleration);
    location.add(velocity);
    acceleration.mult(0);  
  }
  
  void display(){
  stroke(0);
  strokeWeight(2);
  fill(127);
  ellipse(location.x, location.y, 32, 32);
  }
  
  void checkEdges(){
    
    if(location.x > width){
      location.x = 0;
    } else if (location.x < 0){
      location.x = width;
    }
    
    if(location.y > height){
      velocity.y *= -1;
      location.y = height;
    }
  }
  
}
