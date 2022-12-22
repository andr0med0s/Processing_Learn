//5.4: Boolean Variables - Processing Tutorial //<>// //<>//

//float x = 100;
//boolean going = false;

//void setup() {
//  size(400, 300);
//}

//void draw() {
//  background(0);
//  fill(255);
//  ellipse (x, 150, 24, 24);

//  if (going) {
//    x = x + 2;
//  }
//}
//void mousePressed() {
//  //if (going) {
//  //  going = false;
//  //} else {
//  //  going = true;
//  //}
//  going = !going;
//}

//5.5: The Bouncing Ball - Processing Tutorial
float circleX;
float circleY;
float xspeed = .9;
float yspeed = .9;

void setup () {
  size(640, 360);
  circleX = 0;
  circleY = height/2;
}

void draw () {
  background(51);
  fill(102);
  stroke(255);
  //ellipse(circleX, height/2, 32, 32);
  ellipse(circleX, circleY, 32, 32);
  circleX = circleX + xspeed;
  circleY = circleY + yspeed;

  ////if (circleX == width){
  ////  println("TURN AROUND");
  ////}

  //if (circleX > width){
  //  //circleX = circleX - xspeed;
  //  xspeed = -10;
  //}

  //  if (circleX < 0){
  //  //circleX = circleX - xspeed;
  //  xspeed = 10;
  //}

  if (circleX > width || circleX < 0) {
    //Turn Around
    xspeed = xspeed * -1;
  }
  if (circleY > height || circleY < 0) {
    yspeed = yspeed * -1;
  }
}
