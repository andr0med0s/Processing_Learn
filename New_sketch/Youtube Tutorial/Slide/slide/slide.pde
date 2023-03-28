

int maxImages = 10; // Total # of images
int imageIndex = 0; // Initial image to be displayed is the first

// Declaring an array of images.
PImage[] images = new PImage[maxImages];

void setup() {
  size(900, 900, P2D);

  // Loading the images into the array
  // Don't forget to put the JPG files in the data folder!
  for (int i = 0; i < images.length; i ++ ) {
    images[i] = loadImage( "mir" + i + ".jpg" );
  }
  frameRate(25);
}

void draw() {

  background(0);
  image(images[imageIndex], 0, 0,900,900);

  // increment image index by one each cycle
  // use modulo " % "to return to 0 once the end of the array is reached
  imageIndex = (imageIndex + 1) % images.length;
}
