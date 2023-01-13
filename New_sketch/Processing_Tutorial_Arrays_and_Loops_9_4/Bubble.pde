//--------------8.4: Constructor Arguments - Processing Tutorial------------

class Bubble {

  float x;
  float y;
  float diameter;
  float yspeed;
  int  colorR ;
  int  colorG ;
  int  colorB ;

  Bubble(float tempD) {
    x = random(width);
    y = height;
    diameter = tempD;
    yspeed = random(0.5, 2.5);
  }

  //Bubble(float tempD, int r, int g, int b) {
  //  //x = width/2;
  //  x = random(width);
  //  y = height;
  //  diameter = tempD;
  //  colorR = r;
  //  colorG = g;
  //  colorB = b;
  //  yspeed = random(0.5, 2.5);
  //}

  void ascend() {
    y = y - yspeed  ;
    x = x + random(-2, 2);
  }

  void display() {
    stroke(0);
    //fill(colorR, random(colorG), colorB);
    noFill();
    //fill(175,100);
    ellipse(x, y, diameter, diameter);
  }

  void top() {      //<---------метод " всплытия " пузырей
    if (y < -diameter/2) {
      y = height + diameter/2;        // появление занова снизу после " всплытия "
    }
  }
}
