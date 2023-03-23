//let xoff = 0;
//let xoff1 = 0;
//let xoff2 = 10000;
let inc = 0.01;

function setup () {
  createCanvas (200, 200);
  pixelDensity (1);
}

function draw () {

  let yoff = 0;

  loadPixels ();
  for (let y = 0; y < height; y++) {
    let xoff = 0;
    //горизонтальные полосы
    for (let x = 0; x < width; x++) {
      /*
  for (let x = 0; x < width; x++) {
    for (let y = 0; y < height; y++) { //вертикальные полосы
      */
      let index = (x + y * width) * 4;
      // let r = random(255);
      // let r = noise (xoff) * 255;
      let r = noise (xoff, yoff) * 255;
      pixels[index + 0] = r;
      pixels[index + 1] = r;
      pixels[index + 2] = r;
      pixels[index + 3] = 255;

      xoff += inc;
    }
    yoff += inc;
  }
  updatePixels ();
  // noLoop ();
  noiseDetail(12, 0.4); // детализация шума
}
