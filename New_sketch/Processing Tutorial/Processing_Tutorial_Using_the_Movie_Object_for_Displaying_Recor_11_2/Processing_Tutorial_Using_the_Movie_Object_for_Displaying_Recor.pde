import processing.video.*;

Movie video;

void setup(){
  size(1280, 1280);
  video = new Movie(this, "trans.mp4");
  video.loop();
  //video.speed(4);
}

void movieEvent(Movie video){
  video.read();
}

void mousePressed(){
  video.jump(3);
}

void draw(){
  //float r = map(mouseX, 0, width, 0, 4);
    //video.speed(r);
  image(video, mouseX, mouseY, 600, 600);
}
