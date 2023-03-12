let tries = 10000; //attempts to place rectangles
let gap = 1; //between rectangles
let minScale = 0.2; // smallest rectangle
let skip = 5; // pixels to skip when checking available space
let col, col3, firstCol, n2, sc1, colE, palette1, palette2, palettesArray;
let noiseTime = 0;

function preload () {
  palettes = loadJSON ('colors.json');
}

function setup () {
  palettesArray = Object.values (palettes);
  //превращение файла JSON в массив
  palettesLength = palettesArray.length;
  //cnv = createCanvas(windowWidth-20, windowHeight-70);
  cnv = createCanvas (550, 600);
  cnv.position (0, 30);
  let artButton = createButton ('new art');
  artButton.position (10, 0);
  artButton.mousePressed (newArt);
  let saveButton = createButton ('save jpg');
  saveButton.position(80, 0);
  saveButton.mousePressed (saveArt);
  rectMode (CENTER);
  newArt ();
}

function newArt () {
  let timeLapse = millis ();
  clear ();
  rez1 = random (0.0005, 0.0025);
  //разрешение шума перлина для углов
  rez2 = random (0.0005, 0.004);
  //разрешение шума перлина для цвета
  //noiseChance = random(55, 75); //шанс выбраться
  wLow = random (10, 50); //минимальная ширина
  wHigh = random (30, 70); //Максимальная ширина
  hLow = random (30, 70); //минимальная высота
  hHigh = random (70, 130); //максимальная высота
  let strokeType = random (3);
  if (strokeType < 0.5) {
    noStroke ();
  } else if (strokeType < 2.5) {
    stroke (0);
  } else {
    stroke (255);
  }
  //sclStart - это то, насколько велики прямоугльники при старте

  let sclType = random (3);
  if (sclType < 0.5) {
    sclStart = random (0.5, 1.0);
  } else if (sclType < 2.5) {
    //small
    sclStart = random (1.1, 2.0); //medium
  } else {
    sclStart = random (2.1, 7.5); //large
  }
  scl = sclStart / 200 * width;
  sclReduct = (sclStart / tries) * 1.3;
  //вычисление того, насколько уменьшать масштаб при каждой попытке
  palette1 = floor (random (palettesArray.length));
  palette2 = floor (random (palettesArray.length));
  makeBackground ();
  // scl = sclStart;
  noiseTime += 10000;
  // startAng = random(180); // начало вращения всех объектов
  // let widthAng = random(-360,360);
  // let heightAng = random(-360,360);

  // расположение центров вращения и их влияние
  let x2 = random (width);
  let y2 = random (height);
  let x3 = random (width);
  let y3 = random (height);
  let ang2random = random (0.4, 1);
  let ang3random = random (0.4, 1);
  let center1 = random (10);
  let center2 = random (10);
  for (i = 0; i < tries; i++) {
    //начните масштаб с 1 и постепенно уменьшайте до минимального размера
    scl -= sclReduct;
    if (scl < minScale) {
      scl = minScale;
    }
    //где попробовать прямоугольник
    x1 = random (width);
    y1 = random (height);
    // n используется для вращения; n2 используется для цвета
    n = noise (x1 * rez1 + noiseTime, y1 * rez1 + noiseTime);
    n2 = noise (x1 * rez2 + noiseTime + 10000, y1 * rez2 + noiseTime + 10000);
    //ширина и высота прямоугольника
    w = random (wLow, wHigh) * scl;
    h = random (hLow, hHigh) * scl;
    ang1 = n * PI * 2;
    //рассчитать углы для центров вращения
    if (center1 < 5) {
      a = y1 - y2;
      b = x1 - x2;
      ang2 = atan(a / b) * ang2random;
    } else {
      ang2 = 0;
    }
    if (center2 < 5) {
      a2 = y1 - y3;
      b2 = x1 - x3;
      ang3 = atan(a2 / b2) * ang3random;
    } else {
      ang3 = 0;
    }
    ang = ang1 + ang2 + ang3; 
    open = true; //есть место?
    firstCol = null;
    //проверить, есть ли место для этого прямоугольника; сначала проверьте маленькую запись
    checkRect(x1, y1, h, w, ang);
    if (open == false) {
      continue;
    }
  }
}
