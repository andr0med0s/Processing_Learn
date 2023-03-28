class Animation {
  float x;
  float y;

  float index=0;

  float speed;

  PImage[] images;

  Animation(PImage[] imagesTemp, float xTemp, float yTemp) {
    images = imagesTemp;
    x = xTemp;
    y = yTemp;

    speed = random(1,4);
    
    index = 0;
  }
  
    void display() {
    // We must convert the float index to an int first!
    int imageIndex = int(index);
    image(images[imageIndex], x, y);
  }
  
    void move() {
    // Object only moves horizontally
    x += speed;
    if (x > width) {
      x = -images[0].width;
    }
  }
  
    void next() {
    // Move the index forward in the animation sequence
    index += speed;
    // If we are at the end, go back to the beginning
    if (index >= images.length) {
      // We could just say index = 0
      // but this is slightly more accurate
      index -= images.length;
    } 
  }
}
