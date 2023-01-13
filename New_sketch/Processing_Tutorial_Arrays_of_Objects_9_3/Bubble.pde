//--------------8.4: Constructor Arguments - Processing Tutorial------------

class Bubble {

  float x;
  float y;
  float diameter;
  int  colorR ;
  int  colorG ;
  int  colorB ;

  Bubble(float tempD) {
    x = width/2;
    y = height;
    diameter = tempD;
  }

  Bubble(float tempD, int r, int g, int b) {
    x = width/2;
    y = height;
    diameter = tempD;
    colorR = r;
    colorG = g;
    colorB = b;
  }

  void ascend() {
    y--;
    x = x + random(-2, 2);
  }

  void display() {
    stroke(0);
    fill(colorR, colorG, colorB);
    ellipse(x, y, diameter, diameter);
  }

  void top() {      //<---------метод " всплытия " пузырей
    if (y < -diameter) {
      y = height + diameter/2;        // появление занова снизу после " всплытия "
    }
  }
}
