/*Эта программа использует переменные из Робота 2 (см. “Робот 2:
Переменные” в главе 4) и изменяет их значения в процессе работы
программы для управления формой робота посредством мыши. Код в блоке
draw() прокручивается множество раз за секунду. Переменные,
объявленные в программе, изменяются в каждом кадре в соответствии с
mouseX и mousePressed.
mouseX управляет местоположением робота с использованием техники
easing, это делает движения робота менее резкими, а значит более
естественными. Если нажата кнопка мыши, длина шеи и туловища робота
уменьшаются, делая робота меньше ростом.
*/
float x = 60;            //  X-координата
float y = 440;           //  Y-координата
int radius = 45;         //  радиус головы
int bodyHeight = 160;    //  длина туловища
int nectHeight = 70;     //  длина шеи

float easing = 0.02;

void setup(){
  size(360, 480);
  smooth();
  strokeWeight(2);
  ellipseMode(RADIUS);
}
void draw(){

  int targetX = mouseX;
  x += (targetX - x) * easing;
  
  if (mousePressed){
    nectHeight = 16;
    bodyHeight = 90;
  }else{
    nectHeight = 70;
    bodyHeight =160;
  }
  
  float ny = y - bodyHeight - nectHeight - radius;
  
  background(204);
  
  //Шея
  stroke(102);
  line(x+12, y-bodyHeight, x+12, ny);
  
  //антенны 
  line(x+12, ny, x-18, ny-43);
  line(x+12, ny, x+42, ny-99);
  line(x+12, ny, x+78, ny+15);
  
  // Туловище
  noStroke();
  fill(102);
  ellipse(x, y-33, 33, 33);
  fill(0);
  rect(x-45, y-bodyHeight, 90, bodyHeight-33);
  
  // Голова
  fill(0);
  ellipse(x+12, ny, radius, radius);
  fill(255);
  ellipse(x+24, ny-6, 14, 14);
  fill(0);
  ellipse(x+24, ny-6, 3, 3);
}
