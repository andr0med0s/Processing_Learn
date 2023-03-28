int[] randomCounts; //Массив для отслеживания того, как часто выбраны случайные номера

void setup() {
  size(640, 240);
  randomCounts = new int[20];
}

void draw() {
  background(255);

  int index = int(random(randomCounts.length));// выберите случайное число и увеличьте счет
  randomCounts[index]++;

  stroke(0);
  fill(175);
  int w = width/randomCounts.length;

  for (int x = 0; x < randomCounts.length; x++) {  //отображение результатов на графике
    rect(x*w, height-randomCounts[x], w-1, randomCounts[x]);
  }
}
