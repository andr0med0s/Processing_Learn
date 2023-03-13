// Move mouse over canvas

function setup() {
  createCanvas(400, 400);
  //angleMode(DEGREES)
  x1 = width / 2;
  y1 = height / 2;
  strokeWeight(3);
}

function draw() {
  background(220);
  x2 = mouseX;
  y2 = mouseY;
  a = y1 - y2;
  b = x1 - x2;
  ang = atan(a / b);
  push();
  translate(x2, y2);
  rotate(ang);
  line(0, -15, 0, 15);
  pop();
  //print(ang);
}
