//4.4: Using println() - Processing Tutorial
float circleX = 0;
float circleRevX = 0;

void setup() {
  size(640, 320);
}

void draw() {
  background(50);
  fill(255);
  ellipse(circleX, 180, 24, 24);

//  circleX = circleX + random(-2, 0);
  circleX = circleX + random(0, 2);
  println("CircleX: " + circleX);
  
  if(circleX > 640){
    ellipse(circleRevX, 180, 24, 24);
    circleRevX = circleRevX + random(0, 2);
  }
}

//5.1: Boolean Expressions - Processing Tutorial

//float circleX = 0;

//void setup() {
//  size(640, 320);
//}

//void draw() {
//  background(50);
//  fill(255);
//  ellipse(circleX, 180, 24, 24);

//  circleX = circleX + 1;

//}

//void setup(){
//  size(640, 360);
//}

//void draw(){
//  background(50);
  
//  if (mouseX > 200){
//    background(255, 100, 0);
//  }
  
//  stroke(255);
//  line(200, 0, 200, height);
//}
