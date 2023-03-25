float r = 0;
//float a = PI/4;
float a = 0;
float aVel = 0.0;
float aAcc = 0.01;

void setup() {
  size(640, 360);
  background(0);
  smooth();
}



void draw() {


  translate(width/2, height/2);

  float x = r * cos (a);
  float y = r * sin (a);
  
    pushMatrix();
    //fill(204, 153, 0);
    stroke(204, 153, 0,50);
    line(0, 0, x, y);
    popMatrix();
    
  fill(255);
  stroke(255);
  ellipse(x, y, 4, 4);

  a += aVel;
  aVel += aAcc;
  aVel = constrain(aVel, 0, 0.05);

  r += 0.1;
}
