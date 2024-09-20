import processing.video.*;
Particle[] particles;

//PImage photon;
Capture photon;

void setup() {
  size(1280, 960);
  //fullScreen();
  
  //printArray(Capture.list()); список камер
  
  photon = new Capture(this, 640, 480);
  photon.start();
  //photon.resize(1600, 900);

  particles = new Particle [2500];
  for (int i = 0; i < particles.length; i++) {
    particles[i] = new Particle();
  }
  background(0);
}

void captureEvent(Capture video){
  video.read();
}

void draw() {
  for (int boost = 0; boost < 10; boost++) {
    for (int i = 0; i < particles.length; i++) {
      particles[i].display();
      particles[i].move();
    }
  }
}
