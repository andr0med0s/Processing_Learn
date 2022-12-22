var img;
var cameras = [];

function preload() {
  img = loadImage('image2677.png');
}

function setup() {
  createCanvas(windowWidth, windowHeight, WEBGL);

}

function draw() {
  background(0);
  //cylinder(50,50);
  
  camera(200, 200, sin(frameCount * 0.01) * 90, 0, 0, 0, 100, 0, 0);
  //plane(120, 120);
  
  for (var i = -1; i < 2; i++) {
    for (var j = -2; j < 3; j++) {
      push();
      translate(i * 160, 0, j * 160);
      box(50, 50, 50);
      pop();
    }
   
  }
  
   texture(img);
  
   box(400, 400, 400);
}
