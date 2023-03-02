PImage img, sorted;
int index = 0;

void setup() {
  size(600, 300);
  img = loadImage("su.jpg");
  img.resize(300, 300);
  sorted = createImage(img.width, img.height, ARGB);

  //  img .loadPixels();
  //  for(int i = 0; i < sorted.pixels.length; i++){
  //    //sorted.pixels[i] = color(random(255));
  //    sorted.pixels[i] = img.pixels[i];
  //}
  sorted = img.get();
  sorted.loadPixels();
}

void draw() {
  println(frameRate);

  //выбор пикселей для сортировки
  for (int n = 0; n < 1000; n++) {
    float record = -1;
    int selectedPixel = index;
    for (int j = index; j < sorted.pixels.length; j++) {
      color pix = sorted.pixels[j];
      //float b = brightness(pix);
      float b = hue(pix);
      if (b > record) {
        selectedPixel = j;
        record = b;
      }
    }


    //замена выбранного пикселя т.е поменять местами
    color temp = sorted.pixels[index];
    sorted.pixels[index] = sorted.pixels[selectedPixel];
    sorted.pixels[selectedPixel] = temp;


    if (index < sorted.pixels.length - 1) {
      index++;
    }
  }
    sorted.updatePixels();

    background(0);
    image(img, 0, 0);
    image(sorted, 300, 0);
  }
