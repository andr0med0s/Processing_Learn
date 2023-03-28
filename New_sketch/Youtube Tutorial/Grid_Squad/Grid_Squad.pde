size(800, 800);
background(0);
blendMode(ADD);

int i = 0;
while (i < 15) {
  i++;
  println(i);

  int j = 0;
  while (j<10) {
    j++;

    int posX = i * 50;
    int posY = j * 80;
    float dist = random(10);
    float col = random(255);

    float squareSize = random(70);
    print(j + " ");
    fill(col, 0, 0);
    rect(posX, posY, squareSize, squareSize);
    fill(0, col, 0);
    rect(posX + dist, posY + dist, squareSize, squareSize);
    fill(0, 0, col);
    rect(posX + dist * 2, posY + dist * 2, squareSize, squareSize);
  }
}
println(" we are done");
