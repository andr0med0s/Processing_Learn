import processing.video.*;

Capture video;

color trackColor;
float threshold = 20;
float distThreshold = 75;

ArrayList<Blob> blobs = new ArrayList<Blob>();

void setup() {
  size(640, 360);
  String[] cameras = Capture.list();
  printArray(cameras);
  video = new Capture(this, cameras[0]);
  //video = new Capture(this, width, height, 30);
  video.start();
  // Start off tracking for red
  trackColor = color(255, 0, 0);
}

void captureEvent(Capture video) {
  video.read();
}

void keyPressed() {
  if (key == 'a') {
    distThreshold++;
  } else if (key == 'z') {
    distThreshold--;
  }
  println(distThreshold);
}

void draw() {
  video.loadPixels();
  image(video, 0, 0);

  blobs.clear();

  //threshold = map(mouseX, 0, width, 0, 100);
  threshold = 80;

  // Begin loop to walk through every pixel
  for (int x = 0; x < video.width; x++ ) {
    for (int y = 0; y < video.height; y++ ) {
      int loc = x + y * video.width;
      // What is current color
      color currentColor = video.pixels[loc];
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);
      float r2 = red(trackColor);
      float g2 = green(trackColor);
      float b2 = blue(trackColor);

      // Using euclidean distance to compare colors
      float d = distSq(r1, g1, b1, r2, g2, b2); // We are using the dist( ) function to compare the current color with the color we are tracking.


      if (d < threshold * threshold) {
        //stroke(255);
        //strokeWeight(1);
        //point(x, y);
        //avgX +=x;
        //avgY +=y;
        //count++;

        boolean found = false;
        for (Blob b : blobs) {
          if (b.isNear(x, y)) {
            b.add(x, y);
            found = true;
            break;
          }
        }

        //if (blobs.isEmpty()) {
        if (!found) {
          Blob b = new Blob(x, y);
          blobs.add(b);
        }
      }
    }
  }

  // ****DELITED
  // We only consider the color found if its color distance is less than 10.
  //// This threshold of 10 is arbitrary and you can adjust this number depending on how accurate you require the tracking to be.
  //if (count > 0) {
  //  avgX = avgX / count;
  //  avgY = avgY / count;
  //  // Draw a circle at the tracked pixel
  //  fill(255);
  //  strokeWeight(4.0);
  //  stroke(0);
  //  ellipse(avgX, avgY, 24, 24);
  //}
  // ****DELITED

  for (Blob b : blobs) {
    if (b.size() > 500) {
      b.show();
    }
  }
}

float distSq(float x1, float y1, float x2, float y2) {
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1);
  return d;
}

float distSq(float x1, float y1, float z1, float x2, float y2, float z2) {
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) + (z2-z1)*(z2-z1);
  return d;
}

void mousePressed() {
  // Save color where the mouse is clicked in trackColor variable
  int loc = mouseX + mouseY*video.width;
  trackColor = video.pixels[loc];
}
