function setup() {
  createCanvas(300,300);
  background(0);
  noStroke();
  smooth();

}


function draw() {
  for (var x = 15; x<300; x+=30){
  for (var y =0; y<300; y+=30)
   triangle(x,y, x-15,y +30,x +15,y +30);
  }

}
