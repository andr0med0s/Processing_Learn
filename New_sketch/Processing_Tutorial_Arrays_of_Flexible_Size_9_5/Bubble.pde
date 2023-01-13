class Bubble {

  float x;
  float y;
  float diameter;
  float yspeed;
  int  colorR ;
  int  colorG ;
  int  colorB ;
  
  //boolean active = false;

  Bubble(float tempD) {
    x = random(width);
    y = height;
    diameter = tempD;
    yspeed = random(0.5, 2.5);
  }

  void ascend() {
    y = y - yspeed  ;
    x = x + random(-2, 2);
  }

  void display() {
    stroke(0);
    noFill();
    ellipse(x, y, diameter, diameter);
  }

  void top() {      //<---------метод " всплытия " пузырей
    if (y < -diameter/2) {
      y = height + diameter/2;        // появление занова снизу после " всплытия "
    }
  }
}
