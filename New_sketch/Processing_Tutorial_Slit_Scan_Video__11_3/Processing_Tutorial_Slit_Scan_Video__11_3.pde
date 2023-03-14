import processing.video.*;
Capture video;
int d = day();    // Values from 1 - 31
int m = month();  // Values from 1 - 12
int y = year();   // 2003, 2004, 2005, etc.

int x = 0;

void setup() {
  size(1280, 480);
  video = new Capture(this, 640, 480);
  video.start();
}

void captureEvent(Capture video) {
  video.read();
}

void draw() {
  //image(video, 0, 0);
  int w = video.width;
  int h = video.height;
  copy(video, w/2, 0, 1, h, x, 0, 1, h);

  x = x+1;

  if (keyPressed) {
    if (key == 'b' || key == 'B') {
      save(d+m+y + ".jpg");
    }
  }
}
