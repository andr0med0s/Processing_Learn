import processing.video.*;

Capture video;

int blobCounter = 0;

int maxLife = 50;

color trackColor;
float threshold = 20;
float distThreshold = 50;

ArrayList<Blob> blobs = new ArrayList<Blob>();

void setup() {
    size(640, 360);
    String[] cameras = Capture.list();
    printArray(cameras);
    video = new Capture(this, width, height, 30);
    video.start();
    //Start off tracking for red
    trackColor = color(255, 0, 0);
}

void captureEvent(Capture video) {
    video.read();
}

// калибровка
void keyPressed() {    
  if (key == 'a') {
    distThreshold += 5;
  } else if (key == 'z') {
    distThreshold -= 5;
  }
    if (key == 's') {
    threshold += 5;
  } else if (key == 'x') {
    threshold -= 5;
  }
  println(distThreshold);
}

void draw() {
  video.loadPixels();
  image(video, 0, 0);
  ArrayList<Blob> currentBlobs = new ArrayList<Blob>();
    
  //Begin loop to walk through every pixel
  for (int x = 0; x < video.width; x++) {
    for (int y = 0; y < video.height; y++) {
      int loc = x + y * video.width;
      // What is current color
      color currentColor = video.pixels[loc];
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);
      float r2 = red(trackColor);
      float g2 = green(trackColor);
      float b2 = blue(trackColor);
      
      float d = distSq(r1, g1, b1, r2, g2, b2);
      
      if(d < threshold * threshold) {
        boolean found = false;
        for (Blob b : currentBlobs) {
          if (b.isNear(x, y)) {
              b.add(x, y);
              found = true;
              break;
          } 
        }
      
        if (!found) {
          Blob b = new Blob(x, y);
          currentBlobs.add(b);
          }   
      }
    }
  } 
    
  for (int i = currentBlobs.size() - 1; i>= 0; i--) {  
    if (currentBlobs.get(i).size() < 500) {
        currentBlobs.remove(i);
    }
  }
    
    
  // There are no blobs!
  if (blobs.isEmpty() && currentBlobs.size() > 0 ) {
    println("Adding blobs!");
    for (Blob b : currentBlobs) {
      b.id = blobCounter;
      blobs.add(b);
      blobCounter++;
    }
  } else if (blobs.size() <= currentBlobs.size()) {
    // Сапоставление всех капель которые можно сопоставить
    for (Blob b : blobs) {
      float recordD = 1000;
      Blob matched = null;
        for (Blob cb : currentBlobs) {
          PVector centerB = b.getCenter();
          PVector centerCB = cb.getCenter();
          float d = PVector.dist(centerB, centerCB);
          if (d < recordD && !cb.taken) { // если растояние до него меньше чем растояние записи и этот конкретный объект не будет изменен,
                                          //то его можно сопоставить
            recordD = d;
            matched = cb;
          }
        }
        matched.taken = true; //сопоставлено
        b.become(matched);
    }

    // из того что осталось сделать новые капли
    for (Blob b : currentBlobs) {
      if (!b.taken) { // если она не была сопоставлена что тогда 
        b.id = blobCounter;
        blobs.add(b);
        blobCounter++;
      }
    }
  } else if (blobs.size() > currentBlobs.size()) {
    for (Blob b : blobs) {
      b.taken = false;
    } 

    // Сапоставление всех капель которые можно сопоставить
    for (Blob cb : currentBlobs) {
      float recordD = 1000;
      Blob matched = null;  

      for (Blob b : blobs) {
        PVector centerB = b.getCenter();
        PVector centerCB = cb.getCenter();
        float d = PVector.dist(centerB, centerCB);
        if (d < recordD && !b.taken) { 
          recordD = d;
          matched = b;
        }
      }

      if (matched != null){
        matched.taken = true; 
        matched.lifespan = maxLife;
        matched.become(cb);
      } 

      for (int i = blobs.size() - 1; i>=0; i--) {
        Blob b = blobs.get(i);
        if (!b.taken){
          if (b.checkLife()) {
            blobs.remove(i);  
          }
        }
      }
    }
  }
    
  for (Blob b : blobs) {
    // b.update();
    b.show();
  }
    
  textAlign(RIGHT);
  // textSize(12);
  textSize(32);
  fill(0);
  //отладка
  text(currentBlobs.size(), width - 10, 40); 
  text(blobs.size(), width - 10, 80); 
}

// Custom distance functions w / no square root for optimization
float distSq(float x1, float y1, float x2, float y2) {
    float d = (x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1);
    return d;
  }

float distSq(float x1, float y1, float z1, float x2, float y2, float z2) {
    float d = (x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1) + (z2 - z1) * (z2 - z1);
    return d;
  }

void mousePressed() {
    // Save color where the mouse is clicked in trackColor variable
    int loc = mouseX + mouseY * video.width;
    trackColor = video.pixels[loc];
  }
