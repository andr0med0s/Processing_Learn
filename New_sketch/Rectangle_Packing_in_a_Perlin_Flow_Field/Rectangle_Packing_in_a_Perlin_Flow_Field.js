

function setup() {
  createCanvas(400, 400);
  rectMode(CENTER);
  x1 = 200;
  y1 = 200;
  h = 200;
  w = 150;
  gap = 10;
  skip = 6;
  strokeWeight(3);
  noFill()
}

function draw() {
  background(255);
  ang = mouseX;
  checkRect(x1, y1, h, w, ang);
  //check larger rectangle
  h2 = h + gap * 2;
  w2 = w + gap * 2;
  checkRect(x1, y1, h2, w2, ang);

  push();
  translate(x1, y1);
}

function checkRect(x1, y1, h, w, ang) {
  //point for each side
  y2 = y1 - h / 2; //top side
  for (x2 = x1 - w/2; x2 < x1 + w/2 + skip; x2 += skip) {
    //x1 y1 is center of rec;
    //x2 y2 is each edge point
    rotate_point(x2, y2, x1, y1, ang);
    point(x2, y2);
  }
  y2 = y1 + h/2; //bottom side
  for ( x2=x1-w/2; x2<x1 + w/2+skip; x2 += skip ) {
    rotate_point(x2, y2, x1, y1, ang);
    point(x2, y2);
  }
  x2 = x1 - w/2; //left side
  for (y2 = y1 - h/2; y2<y1+h/2+skip; y2+=skip) {
    rotate_point(x2, y2, x1, y1, ang);
    point(x2, y2);
  }
  x2 = x1 + w/2; //right side
  for (y2 = y1-h/2; y2<y1+h/2+skip; y2+=skip) {
    rotate_point(x2, y2, x1, y1, ang);
    point(x2, y2);
  }
}

function rotate_point(pointX, pointY, originX, originY, angle) {
  //pointX & Yis the side point, originX & Y is the center of rectangle
  angle = (angle * PI)/180.0;
  let xDiff = pointX - originX;
  let yDiff = pointY - originY;
  x = cos(angle) * xDiff - sin(angle)*yDiff+originX;
  y = sin(angle) * xDiff + cos(angle)*yDiff+originY;
  point(x, y);
}
