PShape dino;
// Отрисовка фигуры задавая координаты вершин
void setup() {
  size(480, 120);
  dino = createShape(); // создание фигуры
  dino.beginShape(); // начало отрисовки фвктически контур
  dino.fill(153, 176, 180); // заливка
  dino.vertex(50, 120); //вершины
  dino.vertex(100, 90);
  dino.vertex(110, 60);
  dino.vertex(80, 20);
  dino.vertex(210, 60);
  dino.vertex(160, 80);
  dino.vertex(200, 90);
  dino.vertex(140, 100);
  dino.vertex(130, 120);
  dino.endShape();// конец отрисовки
}

void draw() {
  background(204);
  translate(mouseX - 120, 0);
  shape(dino, 0, 0);
}
