
float angle = 0;

void setup() {
  size(640, 640);
}

void draw() {

  translate(width/2, height/2);
   rotate(angle);
  rect(mouseX/2, -15, 30, 30);
  fill(mouseX/2,mouseY/2,0);
  angle += 0.1;
}
