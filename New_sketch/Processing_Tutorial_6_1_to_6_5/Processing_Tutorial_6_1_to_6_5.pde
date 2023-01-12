//----------6.1: While Loop - Processing Tutorial--------

//float x = 0;

//void setup() {
//  size(400, 300);
//}

//void draw() {
//  background(0);

//  //if (x < width){
//  //  x = x + 1;
//  //}

//  x = 0;
//  while (x < width) {
//    if (mouseX < 1) {
//      x= x+1;
//    }else {
//      x = x + mouseX;
//    }
//    x = x + mouseX;
//    fill(101);
//    stroke(255);
//    ellipse(x, 150, 16, 16);
//  }

//  //fill(101);
//  //stroke(255);
//  //ellipse(x, 150, 16, 16);
//}
//------------6.2: Two Loops / Grid Exercise - Processing Tutorial
/*
float x = 0;
 float y = 0;
 float spacing = 50;
 
 void setup() {
 size(400, 300);
 }
 
 void draw() {
 background(0);
 
 spacing = spacing + random(-2,2);
 
 stroke(255);
 strokeWeight(2);
 
 //x = 50;
 //line(x,0,x,height);
 
 //x = x + 50;
 //line(x,0,x,height);
 x = 0;
 while (x < width) {
 line(x, 0, x, height);
 x = x + spacing;
 }
 
 y = 0;
 while (y < height) {
 line(0, y, width, y);
 y = y + spacing;
 }
 }
 */
//--------------6.3: For Loop - Processing Tutorial------------

/*
void setup() {
 size(400, 300);
 }
 
 void draw() {
 background(0);
 
 stroke(255);
 strokeWeight(2);
 
 int x = 0;
 while (x < width) {
 line(x, 0, x, height);
 x = x + 20;
 }
 
 for (int y = 0; y < height; y = y + 20){
 line(0, y, width, y);
 }
 
 //int  y = 0;
 //while (y < height) {
 //  line(0, y, width, y);
 //  y = y + 20;
 //}
 }
 */
//---------------------6.4: Variable Scope - Processing Tutorial
/*
_____________________________________________________________________________
 float circleX;
 float xspeed = 3;
 
 void setup () {
 size(640, 360);
 //circleX = 0;
 //float circleX = 0;
 //float xspeed = 3;
 }
 
 void draw() {
 background(51);
 fill(102);
 stroke(255);
 ellipse(circleX, height/2, 32, 32);
 
 circleX = circleX + xspeed;
 
 if (circleX > width || circleX < 0) {
 //Turn around
 xspeed = xspeed * - 0.9;
 }
 }
 */

//int x = 0;

/*
void setup() {
 size (400, 300);
 }
 ////size (400, 300);
 //background(0);
 //strokeWeight(2);
 //stroke(255);
 
 ////int x = 0;
 //while (x < width) {
 //  line(x, 0, x, height);
 //  x = x + 20;
 //}
 void draw () {
 
 background(0);
 strokeWeight(2);
 stroke(255);
 
 int x = 0;
 while (x < width) {
 line(x, 0, x, height);
 x = x + 20;
 }
 }
 _______________________________________________
 */
//------------6.5: Loop vs. Draw - Processing Tutorial-------------

//float endX = 100;
//float endX = 200;

float endX = 0;

void setup() {
  size(400, 300);
}

void draw() {
  background(0);
  strokeWeight(2);
  stroke(255);

  //int x = 0;
  //while (x < width/2) {
  //  line(x, 0, x, height);
  //  x = x + 20;
  //}
  //int x = 0;
  //while (x < 250) {
  //  line(x, 0, x, height);
  //  x = x + 20;
  //}
  //int x = 0;
  //while (x < mouseX) {
  //  line(x, 0, x, height);
  //  x = x + 20;
  //}
  int x = 0;
  while (x < endX) {
    line(x, 0, x, height);
    x = x + 20;
  }
  
  endX = endX + 1; 
}
