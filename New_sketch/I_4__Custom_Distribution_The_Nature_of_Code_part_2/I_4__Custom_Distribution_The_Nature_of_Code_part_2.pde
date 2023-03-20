// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Массив для отслеживания того, как часто выбираются случайные числа
float[] randomCounts;

void setup() {
  size(800, 200);
  randomCounts = new float[20];
}

void draw() {
  background(255);

// Выбираем случайное число и увеличиваем количество
  int index = int(acceptreject()*randomCounts.length);
  randomCounts[index]++;

// Рисуем прямоугольник для отображения результатов
  stroke(0);
  strokeWeight(2);
  fill(127);

  int w = width/randomCounts.length;

  for (int x = 0; x < randomCounts.length; x++) {
    rect(x*w, height-randomCounts[x], w-1, randomCounts[x]);
  }
}

// Алгоритм выбора случайного числа на основе метода Монте-Карло
// Здесь вероятность определяется по формуле y = x
float acceptreject() {
  // Have we found one yet
  boolean foundone = false;
  int hack = 0;  // давайте посчитаем, чтобы случайно не застрять в бесконечном цикле
  while (!foundone && hack < 10000) {
    // Выбираем два случайных числа
    float r1 = (float) random(1);
    float r2 = (float) random(1);
    float y = r1*r1;  // y = x*x (изменение для разных результатов)
   // Если r2 действителен, мы будем использовать этот
    if (r2 < y) {
      foundone = true;
      return r1;
    }
    hack++;
  }
  // Взломать на случай, если мы столкнемся с проблемой (нужно это исправить)
  return 0;
}
