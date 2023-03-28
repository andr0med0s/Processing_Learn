PImage ritm;

void setup() {
  size(659, 925);
  ritm = loadImage("rom.jpg");
}
void draw() {
  //image(ritm, 0, 0);
  ritm.resize(659, 925);

  loadPixels();
  ritm.loadPixels();
  for (int x = 0; x < width-1; x++) {
    for (int y = 0; y < height; y++) {
      int loc1 =  x      + y * width;
      int loc2 = (x + 1) + y * width;
      float b1 = brightness(ritm.pixels[loc1]);
      float b2 = brightness(ritm.pixels[loc2]);

      float diff = abs(b1 - b2);
      if (diff > 20) {
        pixels[loc1] = color(0);
      } else {
        pixels[loc1] = color(255);
      }
    }
  }
  updatePixels();
}
