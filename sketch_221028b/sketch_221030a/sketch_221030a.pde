//// Пример 4-11: Ряды и колонки
//size(480, 120);
//background(0);
//smooth();
//noStroke();
//for (int y = 0; y < height + 45; y += 40){
//fill(255, 140);
//ellipse(0, y, 40, 40);
//}
//for (int x = 0; x < width+45; x += 40) {
//fill(255, 140);
//ellipse(x, 0, 40, 40);
//}

//// Пример 4-12: Точки и линии
//size(480, 120);
//background(0);
//smooth();
//fill(255);
//stroke(102);
//for (int y = 20; y <= height-20; y += 10) {
//for (int x = 20; x <= width-20; x += 10) {
//ellipse(x, y, 4, 4);
//// Рисуем линии к центру экрана
//line(x, y, 240, 60);
//}
//}

//Пример 4-13: Точки и полутона

size(480, 120);
background(0);
smooth();
for (int y = 32; y <= height; y += 8) {
for (int x = 12; x <= width; x += 15) {
ellipse(x + y, y, 16 - y/10.0, 16 - y/10.0);
}
}
