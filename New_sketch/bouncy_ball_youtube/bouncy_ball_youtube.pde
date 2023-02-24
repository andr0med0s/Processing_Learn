Ball ball = new Ball();

void setup() {
  size(640, 480);
}

void draw() {
  background(155);
  ball.display();
  ball.move();

  //ball.setdy(10);
  //ball.setdx(5);

  if (ball.getY()+25 > height || ball.getY()-25 < 0) {
    //dy += -1
    ball.setdy(ball.getdy() * -1);
  }
}
