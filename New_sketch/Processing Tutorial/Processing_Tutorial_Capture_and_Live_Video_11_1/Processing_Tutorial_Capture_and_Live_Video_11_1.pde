import processing.video.*;

Capture video;

void setup() {
  size(600, 400); 
  video = new Capture(this, 640, 480, 30);
  video.start(); 
}

void mousePressed(){
    video.read();
}

void captureEvent(Capture video){
  //video.read();
}

void draw() {
  //if (video.available()){
  //video.read();
  //}  
  background(0);
  image(video, 0, 0);
}
