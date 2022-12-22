function setup(){
  createCanvas(windowWidth,windowHeight);
  //canvas.position (0, 0);
  background(10);
}
function windowResized(){
  resizeCanvas (windowWidth,windowHeight);
}
function draw() {
 // Scale the mouseX value from 0 to 640 to a range between 0 and 175
  let c = map(mouseX, 0, width, 0, 175);
  // Scale the mouseX value from 0 to 640 to a range between 40 and 300
  let d = map(mouseX, 0, width, 40, 300);
  fill(255, c, 0);
  ellipse(width/2, height/2, d, d);
  push();
  translate(width * 0.5, height * 0.5);
  rotate(frameCount / 200.0);
  polygon(0, 0, 82, 3);
  pop();
  line(width/2, height/2, mouseX, mouseY);
}
function mousePressed() {
       background(192, 64, 0);
}
function polygon(x, y, radius, npoints) {
  let angle = TWO_PI / npoints;
  beginShape();
  for (let a = 0; a < TWO_PI; a += angle) {
    let sx = x + cos(a) * radius;
    let sy = y + sin(a) * radius;
    vertex(sx, sy);
  }
  endShape(CLOSE);
}
