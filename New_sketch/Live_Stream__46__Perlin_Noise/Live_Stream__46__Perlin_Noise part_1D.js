//let xoff = 0;
//let xoff1 = 0;
//let xoff2 = 10000;
let inc = 0.01;
let start = 0;

function setup() {
  createCanvas(400, 400);
}


function draw() {
  background(51);

  stroke(255);
  noFill();
  beginShape();
  //let xoff = 0;
  let xoff = start;
  for (let x = 0; x < width; x++) {
    stroke(255);

    //let n = map(noise(xoff), 0, 1, -50, 50); //небольшие изменения как пример
    //let s = map(sin(xoff), -1, 1, 0, height);// использования псевдо рукописного шрифта
    //let n = map(noise(xoff), 0, 1, 0, height);
    //let s = map(sin(xoff), -1, 1, -50, 50 );
    //let y = s + n;

    //point(x, 200);
    //point(x, random(height));

    //let y = noise(0);

    //let y = random(height);
    //let y = noise(xoff)* height;
    //let y =height/2 + sin(xoff)* height/2;
    //let y =noise(xoff)* 100 + height/2 + sin(xoff)* height/2;
    let y =noise(xoff)* height;
    vertex(x, y);

    //xoff += 0.01;
    xoff += inc;
  }
  endShape();

  start += inc;

  //noLoop();

  //let x = random(width);
  //let x = noise(100);
  //let x = map(noise(100), 0 , 1, 0, width);
  //    let x = map(noise(xoff1), 0 , 1, 0, width);
  //    let y = map(noise(xoff2), 0 , 1, 0, width);

  //    //xoff += 0.01; // коэффицент который определяет, то
  ////на какое количество сместится в графике значений шума перлина,
  ////а от этого значения зависит плавность смещения, чем меньше тем плавнее

  //  xoff1 += 0.02;
  //  xoff2 += 0.02;


  //ellipse(x, y, 24, 24 );
}
