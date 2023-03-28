//------------Робот 4: Мультимедиа
//стр 104
PShape bot1;
PShape bot2;
PShape bot3;
PImage landscape;

float easing = 0.05;
float offset = 0;

void setup() {
  size(720, 480);
  bot1 = loadShape("robots1.svg");
  bot2 = loadShape("robots1.svg");
  bot3 = loadShape("robots1.svg");
  landscape = loadImage("bgc 1.jpg");
}

void draw() {
// Устанавливаем изображение "landscape" в качестве фона;
// это изображение должно иметь размер окна
  background(landscape);
  
// Устанавливаем сдвиг влево/вправо и применяем технику
// easing для сглаживания движений
  float targetOffset = map(mouseY, 0, height, -80, 80);
  offset += (targetOffset - offset) * easing;
  
// Рисуем левого робота
  shape(bot1, 85 + offset, 65);
  
// Рисуем правого робота уменьшенным с небольшим сдвигом
  float smallerOffset = offset * 0.7;
  shape(bot2, 510 + smallerOffset, 140, 78, 248);
  
// Рисуем самого мальенького робота, с наименьшим сдвигом
  smallerOffset *= -0.5;
  shape(bot3, 410 + smallerOffset, 225, 39, 124);
}
