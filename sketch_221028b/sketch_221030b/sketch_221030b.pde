

/*
Например, мы
можем регулировать длину шеи робота с помощью переменной bodyHeight.
Несколько переменных в начале кода регулируют различные параметры
робота, которые мы хотели бы изменить: местоположение, длину толовища,
длину шеи. На рисунке изображены несколько вариантов робота, ниже
перечислены соответствующие значения переменных:

y = 390
bodyHeight = 180
neckHeight = 40

y = 460
bodyHeight = 260
neckHeight = 95

y = 310
bodyHeight = 80
neckHeight = 10

y = 420
bodyHeight = 110
neckHeight = 140
*/

int x = 60; // x-координата
int y = 310; // y-координата
int bodyHeight = 80; // Длина туловища
int neckHeight = 10; // Длина шеи
int radius = 45; // Радиус головы
int ny = y - bodyHeight - neckHeight - radius; // Шея Y

size(170, 480);
smooth();
strokeWeight(2);
background(204);
ellipseMode(RADIUS);

// Шея
stroke(102);
line(x+2, y-bodyHeight, x+2, ny); line(x+12, y-bodyHeight, x+12, ny); 
line(x+22, y-bodyHeight, x+22, ny);

// Антенны
line(x+12, ny, x-18, ny-43);
line(x+12, ny, x+42, ny-99);
line(x+12, ny, x+78, ny+15);

// Туловище
noStroke();
fill(102);
ellipse(x, y-33, 33, 33);
fill(0);
rect(x-45, y-bodyHeight, 90, bodyHeight-33);
fill(102);
rect(x-45, y-bodyHeight+17, 90, 6);

// Голова
fill(0);
ellipse(x+12, ny, radius, radius);
fill(255);
ellipse(x+24, ny-6, 14, 14);
fill(0);
ellipse(x+24, ny-6, 3, 3);
fill(153);
ellipse(x, ny-8, 5, 5);
ellipse(x+30, ny-26, 4, 4);
ellipse(x+41, ny+6, 3, 3);
