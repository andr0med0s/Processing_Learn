/*
 * @name Background Image
 * @description This example presents the fastest way to load a
 * background image. To load an image as the background,
 * it must be the same width and height as the program.
 * <p><em><span class="small"> To run this example locally, you will need an
 * image file, and a running <a href="https://github.com/processing/p5.js/wiki/Local-server">
 * local server</a>.</span></em></p>
 */
let bg;
let y = 0;
var theta;
var cnv;

function setup() {
  // The background image must be the same size as the parameters
  // into the createCanvas() method. In this program, the size of
  // the image is 720x400 pixels.
  bg = loadImage('MyU-c548JkY.jpg');
  createCanvas(422, 750);
  stroke(256);
}

function draw() {
  background(bg);
  
  
    // Scale the mouseX value from 0 to 640 to a range between 0 and 175
  let c = map(mouseX, 0, width, 0, 175,);
  // Scale the mouseX value from 0 to 640 to a range between 40 and 300
  let d = map(mouseX, 0, width, 40, 300);
  fill(255, c, 0, 102);
  ellipse(width/2, 190, d, d);

frameRate(30);
  stroke(255);
  // Let's pick an angle 0 to 90 degrees based on the mouse position
  var a = (mouseY / width) * 90.0;
  // Convert it to radians
  theta = radians(a);
  // Start the tree from the bottom of the screen
  translate(width/2,height);
  // Draw a line 120 pixels
  //line(0,0,0,-120);
  // Move to the end of that line
  translate(-3,-180);
  // Start the recursive branching!
  branch(120);

}

function branch(h) {
  // Each branch will be 2/3rds the size of the previous one
  h *= 0.66;
  
  // All recursive functions must have an exit condition!!!!
  // Here, ours is when the length of the branch is 2 pixels or less
  if (h > 2) {
    push();    // Save the current state of transformation (i.e. where are we now)
    rotate(theta);   // Rotate by theta
    line(0, 0, 0, -h);  // Draw the branch
    translate(0, -h); // Move to the end of the branch
    branch(h);       // Ok, now call myself to draw two new branches!!
    pop();     // Whenever we get back here, we "pop" in order to restore the previous matrix state
    
    // Repeat the same thing, only branch off to the "left" this time!
    push();
    rotate(-theta);
    line(0, 0, 0, -h);
    translate(0, -h);
    branch(h);
    pop();
  }
}
