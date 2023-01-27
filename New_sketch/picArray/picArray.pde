Animation[] animations = new Animation[4];

void setup() {
  size(900, 900);
  frameRate(4);

  PImage[] arrBoy = new PImage[8];
  for (int i = 0; i < arrBoy.length; i++) {
    arrBoy[i] = loadImage("Asset"+i+".png");
  }

  float y = 0;
  for (int i = 0; i < animations.length; i ++) {
    animations[i] = new Animation(arrBoy, 0, y);
    y += arrBoy[0].height;
  }
}
void draw() {

  background(255);
  
  // Display, cycle, and move all the animation objects
  for (int i = 0; i < animations.length; i ++ ) {
    animations[i].display();
    animations[i].next();
    animations[i].move();
  }
}
