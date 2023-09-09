const density = 'Ñ@#W$9876543210?!abc;:+=-,._ ';

let gloria;

function preload() {
  gloria = loadImage("assets/stepan20.png");
}

function setup() {
  //createCanvas(400, 400);
  noCanvas();
  //}


  //function draw() {
  background(0);
  //image(gloria, 0, 0, width, height);

  let w = width/gloria.width;
  let h = height/gloria.height;
  gloria.loadPixels();
  for (let j=0; j<gloria.height; j++) {
    let row = '';
    for (let i=0; i<gloria.width; i++) {

      const pixelIndex = (i + j * gloria.width) * 4;
      const r = gloria.pixels[pixelIndex + 0];
      const g = gloria.pixels[pixelIndex + 1];
      const b = gloria.pixels[pixelIndex + 2];
      const avg = (r + g + b)/3;
      const len = density.length;
      const charIndex = floor(map(avg, 0, 255, len, 0));
      //noStroke();
      ////fill(r,g,b);
      ////fill(avg);
      //fill(255);
      //textSize(w);

      //textAlign(CENTER, CENTER);
      ////text('G', i*w + w * 0.5, j*h + h * 0.5);
      //text(density.charAt(charIndex), i*w + w * 0.5, j*h + h * 0.5);

      const c = density.charAt(charIndex);
      if (c == '') row += '&nbsp;'
      else row += c;
    }
    createDiv(row);
    //console.log(row);
  }
}
