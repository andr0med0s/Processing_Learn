PImage ritm;

void setup() {
  size(800, 600);
  ritm = loadImage("ritm.png");
  ritm.resize(800, 600);
}
void draw() {
  //image(frog, 0, 0);
  for (int i = 0; i < 500; i++) {
    float x = random (width);
    float y = random (height);
    color c = ritm.get(int(x), int(y));
    fill(c, 25);
    noStroke();
    ellipse(x, y, 16, 16);
  }
}
