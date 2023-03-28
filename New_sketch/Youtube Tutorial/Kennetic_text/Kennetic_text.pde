import processing.video.*;

String message = "учи.код.читай.книги.будь.сильнее.";
char[] messageAsChars = message.toCharArray();
int charCount = messageAsChars.length;

Movie movie;
Capture cam;
int c = 0;
float mlp = 0;
boolean recording = false;

int blockSize = 10;
int numPixelsWidth, numPixelsHeigth;

void setup(){
  //clear();
  size(640, 480);

  String[] cameras = Capture.list();
  
  if (cameras == null){
    println("Failed to retrieve the list of available cameras, will try the default... ");
    cam = new Capture(this, 640, 480);
  }else if(cameras.length == 0) {
    println ("The are no cameras available for capture");
    exit();
  } else {
    println("Available cameras: ");
    printArray(cameras);
    
    //Камера может быть инициализирована непосредственно с помощью
    //элемента из массива , возвращаемого list();
    cam = new Capture(this, cameras[0]);
    //Или настройки могут быть определены на основе текста в списке
    //cam = new Capture(this, 640, 480, "Built-in iSight", 30);
    
    //начало захвата изображения с камеры
    cam.start();
  }
  
  background(0);
  frameRate(10);
  //movie = new Movie(this, "1 scene_city.mp4");
  //movie.loop();
  numPixelsWidth = width / blockSize;
  numPixelsHeigth = height / blockSize;
  
  textAlign(CENTER,CENTER);
}

void draw(){
  c++;
  mlp = 4.0*mouseX/width;
  background(0);
  int k = 0;
  if(cam.available() == true){
    cam.read();
    cam.loadPixels();
    for(int j = 0; j<numPixelsHeigth; j++){
      for(int i = 0;i<numPixelsWidth; i++){
        float pxNum = brightness(cam.get(i*blockSize, j*blockSize));
        textSize(mlp*blockSize*pxNum/256+1);
        k = i + j + c;
        k = k%charCount;
        text(messageAsChars[k], i*blockSize, j*blockSize);
        //text("#" , i*blockSize, j*blockSize);
      }
    }
  }
  if(recording){
    saveFrame("output/frame####.png");
    print("(REC)");
  }
  //image(movie, 0, 0, width, height);
  //println("numPixelsWidth" + numPixelsWidth + "--numPixelsHeigth" + numPixelsHeigth);
  
}

void keyPressed(){
  print("PRESSED");
  if(key == 'p' || key == 'P'){
    recording =! recording;
  }
}
