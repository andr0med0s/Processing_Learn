class Mover {
  PVector location;
  PVector velocity;
  PVector acceleration;

  float mass;


  Mover() {
    //location = new PVector(width/2, height/2);
    location = new PVector(random(width), height/2);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    mass = random(0.5, 4);
  }

  //второй закон Ньютона с массой
  void applyForce(PVector force) {
    PVector f = PVector.div(force, mass); // статическая верcия функции div()
  
    //acceleration = force;
    //acceleration.add(force);
    acceleration.add(f);
  }

  /*
  void applyForce(PVector force) {
 
     PVector f = force.get();  // Создание копии вектора перед его использованием
     
     f.div(mass);
     acceleration.add(f);
   }
   
   Перепишите метод applyForce(), используя статический метод div() вместо get().
   void applyForce(PVector force) {
     
     PVector f = PVector.div(force,mass);
     acceleration.add(f); 
   }
   */

  void update() {
    velocity.add(acceleration);
    location.add(velocity);
    acceleration.mult(0);
    // velocity.limit(5);
  }



  void edges() {
    if (location.x > width) {
      location.x = width;
      velocity.x *= -1;
    } else if (location.x < 0) {
      velocity.x *= -1;
      location.x = 0;
    }

    if (location.y > height) {
      velocity.y *= -1;
      location.y = height;
    } else if (location.y < 0) {
      velocity.y *= -1;
      location.y = 0;
    }
  }

  void display() {
    stroke(0);
    strokeWeight(2);
    fill(127);
    ellipse(location.x, location.y, mass*20, mass*20);
  }
}
