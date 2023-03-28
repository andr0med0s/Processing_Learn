
import processing.video.*;

String message = "  Красота  спасёт   мир  ";
char[] messageAsChars = message.toCharArray();
int charCount = messageAsChars.length;

int blockSize = (int)random(20, 50);
int numPixelsWidth, numPixelsHeight;

int c = 0;

Movie movie;

void setup() {
  size(720, 720);
  background(0);
  frameRate(30);
  // Load and play the video in a loop
  movie = new Movie(this, "myvid.mp4");
  movie.loop();
  numPixelsWidth = width / blockSize;
  numPixelsHeight = height / blockSize;
  textAlign(CENTER, CENTER);
  //textSize(10);
}



void draw() {
  c = c + 1;
  background(0);
  //fill(255);
  float pxNum;
  
  int k = 0;
  
  if (movie.available() == true) {
    movie.read();

    movie.loadPixels();

    for (int j = 0; j < numPixelsHeight; j++) {
      for (int i = 0; i < numPixelsWidth; i++) {
        pxNum = brightness(movie.get(i*blockSize, j*blockSize));
        pxNum = blockSize * pxNum / 255;
        k = i + j + c;
        k = k % charCount;
        textSize(pxNum+1);
        text(messageAsChars[k], i*blockSize, j*blockSize);
      }
    }
  }
}
