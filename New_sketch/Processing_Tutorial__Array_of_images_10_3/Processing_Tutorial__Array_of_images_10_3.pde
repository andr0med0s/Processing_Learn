class Bubble {

  float x;
  float y;
  float diameter;

  PImage img;
// Bubble (float tempX, float tempY, float tempD) {
  Bubble (PImage tempImg, float tempX, float tempY, float tempD) {
    x = tempX;
    y = tempY;
    diameter = tempD;
    //img = ________;
    img = tempImg;
  }

  void ascend() {
    y--;
    x = x + random(-2, 2);
  }

  void display() {
    stroke(0);
    fill(127);
    //ellipse(x, y, diameter, diameter);
    imageMode(CENTER);
    //image(flower[0], x, y, diameter, diameter);   // вывод по одному 
    //image(flower[1], x, y, diameter, diameter);   // из видов
    //image(flower[2], x, y, diameter, diameter);   // картинок
    image(img, x, y, diameter, diameter);
  }

  void top() {
    if (y < diameter/2) {
      y = diameter/2;
    }
  }
}
