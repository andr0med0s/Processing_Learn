void setup() {
  size(500, 300);
}

void draw() {
  background(255);
  strokeWeight(2);
  stroke(0);
  noFill();

  translate(width/2, height/2);  //Нарисуйте линию, представляющую вектор.
  ellipse(0, 0, 4, 4);

  PVector mouse = new PVector(mouseX, mouseY);      // Два PVectora один для расположения мыши
  PVector center = new PVector(width/2, height/2);  //и один для центра окна

  mouse.sub(center); // Вычитание PVector
  //mouse.mult(1);
  
  //float m = mouse.mag();
  //fill(255, 0, 0);
 // rect(0, 0, m, 20);
 
 mouse.normalize();
 mouse.mult(50); // размер постоянен не зависит от положения мыши 
 
 mouse.setMag(50); // это строка эвивалентна нормализации и умножению

/*
В этом примере после того, как вектор равен
нормализованный, он умножается на 50, так что получается
доступно для просмотра на экране. Обратите внимание, что независимо от того,
там, где находится мышь, вектор будет иметь
та же длина (50) из-за нормализации
процесс.
*/

  line(0, 0, mouse.x, mouse.y);
}
