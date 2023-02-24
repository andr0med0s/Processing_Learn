PImage ritm;

void setup() {
  size(659, 925);
  ritm = loadImage("rom.JPG");
}
void draw() {
  //image(ritm, 0, 0);
  ritm.resize(659, 925);

  loadPixels();
  ritm.loadPixels();
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      //float d = dist (x, y, width/2, height/2);
      int loc = x+y*width;

      float b = brightness(ritm.pixels[loc]);

      //if (b > 100) {
        if (b > mouseX) {
        pixels[loc] = color(255);
      } else {
        pixels[loc] = color(0);
      }     
      
       float r = red(ritm.pixels[loc]);
       float g = green(ritm.pixels[loc]);
       //float b = blue(ritm.pixels[loc]);
       ////float d = dist(width/2, height/2, x, y);
       //float d = dist(mouseX, mouseY, x, y);
       //float factor = map(d, 0, 200, 2, 0);
       ////pixels[loc] = color(r + mouseX, g + mouseX, b + mouseX);
       //pixels[loc] = color(r * factor, g * factor, b * factor);
       
      if (x > mouseX){
        pixels[loc] = color(g, r, b * 2);
      }else {
        pixels[loc] = color(r, g, b);
      }
    }
  }
  updatePixels();
}
