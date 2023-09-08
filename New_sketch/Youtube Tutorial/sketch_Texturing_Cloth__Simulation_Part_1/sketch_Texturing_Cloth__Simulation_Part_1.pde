PImage unikitty;
float x = 200;
float y = 200;
void setup() {
  size(600, 400, P2D);
  unikitty = loadImage("unikitty6.jpg");
}

void draw() {
  background(51);
  stroke(255);
  strokeWeight(2);
  noFill();
  textureMode(NORMAL);
  beginShape(TRIANGLE_STRIP);
  texture(unikitty);
  for (float x = 100; x < 500; x+=50) {
    float u = map(x, 100,500,0,1);
    vertex(x, 200,u,0);
    vertex(x, 250,u,1);
  } 
  endShape();

  //stroke(255);
  //fill(127); 
  //beginShape();
  //texture(unikitty);
  //vertex(x, y, 0,0);
  //vertex(300, 200, 600,0);
  //vertex(300, 300, 600,600);
  //vertex(200, 300, 0, 600);
  //endShape(CLOSE );

  //x += random (-5, 5);
  //y += random (-5, 5);
}