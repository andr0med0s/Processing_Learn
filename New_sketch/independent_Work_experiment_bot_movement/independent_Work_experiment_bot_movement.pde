/*
y = 390
bodyHeight = 180
neckHeight = 40
*/

int x = 60; // x-координата
int y = 310; // y-координата
int bodyHeight = 80; // Длина туловища
int neckHeight = 10; // Длина шеи
int radius = 45; // Радиус головы
//int ny = y - bodyHeight - neckHeight - radius; // Шея Y
float easing = 0.02;

void setup(){
  size(360, 480);
  smooth();
  strokeWeight(2);
  background(204);
  ellipseMode(RADIUS);
}

void draw (){
  
    int targetX = mouseX;
  x += (targetX - x) * easing;
  
  //  if (keyPressed &&(key == CODED)){ 
  //  if (keyCode == LEFT){
  //    x--;
  //  }else if(keyCode == RIGHT){
  //    x++;
  //  }
  //}
  
  if (mousePressed){
    y = 390;
    bodyHeight = 180;
    neckHeight = 40;
  }else{                  // дефолтные значения как глобальные переменные
    y = 310;
    neckHeight = 10;
    bodyHeight =80;
  }
  
  float ny = y - bodyHeight - neckHeight - radius;
  
   background(204);
  
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
}
