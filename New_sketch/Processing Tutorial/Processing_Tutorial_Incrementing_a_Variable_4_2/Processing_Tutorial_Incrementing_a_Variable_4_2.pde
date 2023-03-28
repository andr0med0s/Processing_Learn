// 4.2: Incrementing a Variable

float circleX;
float circleY;

void setup () {
  size(640, 360);
  circleX = 50;
  circleY = 180;
}

void draw (){

  background(50);
  fill(255);
  ellipse(circleX, circleY, 24, 24);
  if (mousePressed) {
    circleX = mouseX;
    circleY = mouseY;
  }
  
  circleX = circleX + 0.1;  
}
