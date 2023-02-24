Ball ball = new Ball(400, 100,0, 5, 50);
Ball ball2 = new Ball(50, 50, 10, 2, 25);

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
  //----------
  ball2.display();
  ball2.move();

  //ball.setdy(10);
  //ball.setdx(5);

  if (ball2.getY()+25 > height || ball2.getY()-25 < 0) {
    //dy += -1
    ball2.setdy(ball2.getdy() * -1);
  }
}
