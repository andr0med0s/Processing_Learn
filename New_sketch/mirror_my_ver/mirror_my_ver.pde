PImage img, mirror;
boolean showorg = false;

void setup() {
  size(1000, 2000);
  img = loadImage("flow.jpg");
  img.resize(500, 1000);
  mirror = createImage(img.width, img.height, ARGB);
  mirror.loadPixels();
  img.loadPixels();
  //for (int i=0; i< img.pixels.length; i++) {
  //  mirror.pixels[i] = img.pixels[i];
  //}

  for (int i = 0; i < mirror.pixels.length; i++) {       //loop through each pixel
    int srcX = i % mirror.width;                        //calculate source(original) x position
    int dstX = mirror.width-srcX-1;                     //calculate destination(flipped) x position = (maximum-x-1)
    int y    = i / mirror.width;                        //calculate y coordinate
    mirror.pixels[y*mirror.width+dstX] = img.pixels[i];//write the destination(x flipped) pixel based on the current pixel
  }




  //for (int i = 0; i < mirror.pixels.length / 2; i++) {
  //  int tmp = mirror.pixels[i];
  //  mirror.pixels[i] = mirror.pixels[mirror.pixels.length - i - 1];
  //  mirror.pixels[mirror.pixels.length - i - 1] = tmp;
  //}

  //for (int y = 0; y < img.height; y++) {
  //  for (int x = 0; x < img.width; x++) {
  //    mirror.set(img.width-x-1, y, img.get(x-450, y));
  //  }
  //}

  mirror.updatePixels();
}

void draw() {
  background(200, 200, 0);
  //image(img, 500, 0);



  //image(mirror, 0, 0);
  background(200, 200, 0);
  if ( showorg) image(img, 500, 0);                                          // show original
  image(mirror, mouseX, 0);
}

void keyPressed() {
  if ( key == 'o' ) showorg = ! showorg;
}
