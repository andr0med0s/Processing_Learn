class Attractor {
  float mass; // Масса, привязанная к размеру
  PVector location; // позиция
  float G; // Гравитационная постоянная
  boolean dragging = false;  // Перетаскивается ли объект?
  boolean rollover = false;  // Наведен ли указатель мыши на эллипс?
  PVector dragOffset;// удерживает смещение при клике по объекту

  Attractor() {
    location = new PVector (width/2, height/2);
    mass = 20;
    G = 1;
    dragOffset = new PVector(0.0, 0.0);
  }

  PVector attractor (Mover m) {

    //  направление действия силы
    PVector force = PVector.sub(location, m.location);
    float d = force.mag();

    d = constrain(d, 25, 25);

    force.normalize();

    //Какова величина этой силы?
    float strength = (G * mass * m.mass) / (d * d);

    //сопоставление величины и направления воедино
    force.mult(strength);

    return force;
  }

  //способ отображения
  void display() {
    ellipseMode(CENTER);
    strokeWeight(4);
    stroke(0);
    if (dragging) fill (50);
    else if (rollover) fill(100);
    else fill (175, 200);
    ellipse(location.x, location.y, mass*2, mass*2 );
  }

  //методы для взаимодействия с мышью
  void clicked(int mx, int my) {
    float d = dist(mx, my, location.x, location.y);
    if (d < mass) {
      dragging = true;
      dragOffset.x = location.x-mx;
      dragOffset.y = location.y-my;
    }
  }

  void hover(int mx, int my) {
    float d = dist(mx, my, location.x, location.y);
    if (d < mass) {
      rollover = true;
    } else {
      rollover = false;
    }
  }

  void stopDragging() {
    dragging = false;
  }



  void drag() {
    if (dragging) {
      location.x = mouseX + dragOffset.x;
      location.y = mouseY + dragOffset.y;
    }
  }
}
