/* Load and Display example */
PImage img, mirror;  // Declare variable of type PImage
boolean showorg = false;

void setup() {
  size(1000, 2000);
  img = loadImage("flow.jpg");
  img.resize(500, 1000);
  // Load the image file into the program
  mirror = createImage(img.width, img.height, ARGB);       // make a empty image half size
  for (int y = 0; y < img.height; y++) {
    for (int x = 0; x < img.width; x++) {
      mirror.set(img.width-x-1, y, img.get(x-450, y));
    }
  }
}

void draw() {
  background(200, 200, 0);
  if ( showorg) image(img, 500, 0);                                          // show original
  image(mirror, mouseX, 0);                                       // paint mirror over it
}

void keyPressed() {
  if ( key == 'o' ) showorg = ! showorg;
}
