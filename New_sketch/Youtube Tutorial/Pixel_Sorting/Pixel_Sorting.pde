PImage img, sorted;

void setup() {
  size(300, 150);
  img = loadImage("su.jpg");
  img.resize(150, 150);
  sorted = createImage(img.width, img.height, ARGB);
  
  //  img .loadPixels();
  //  for(int i = 0; i < sorted.pixels.length; i++){
  //    //sorted.pixels[i] = color(random(255));
  //    sorted.pixels[i] = img.pixels[i];
  //}
  sorted = img.get();
  sorted.loadPixels();
  
  //выбор пикселей для сортировки
  for(int i=0; i < sorted.pixels.length; i++){
    float record = -1;
    int selectedPixel = i;
    for(int j = i; j < sorted.pixels.length; j++){
      color pix = sorted.pixels[j];
      //float b = brightness(pix);
      float b = hue(pix);
      if (b > record){
        selectedPixel = j;
        record = b; 
      }
    }
    
   //замена выбранного пикселя т.е поменять местами
    color temp = sorted.pixels[i];
    sorted.pixels[i] = sorted.pixels[selectedPixel];
    sorted.pixels[selectedPixel] = temp; 
}
  
  sorted.updatePixels();
}

void draw() {
  background(0);
  image(img, 0, 0);
  image(sorted, 150, 0);
}
