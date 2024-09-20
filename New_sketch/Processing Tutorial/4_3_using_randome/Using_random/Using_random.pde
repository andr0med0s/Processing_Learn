//4.3: Using random() - Processing Tutorial

//float circleX;

//void setup(){
//  size(640, 320);
//  circleX = width/2;
//}

//void draw(){

//  // Draw stuff
//  background(50);
//  fill(255);
//  ellipse(circleX, 180, 24, 24);

//  //Logoc
//  circleX = circleX + random(-2,2);
//}
float circleX;
float circleY;

void setup() {
  size(640, 360);
  background(50);
}

void draw() {

  circleX = random(width);
  circleY = random(height);

  // Draw stuff

  fill(255);
  ellipse(circleX, circleY, 24, 24);
}
