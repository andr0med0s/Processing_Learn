Mover m;

void setup() {
  size(640, 360);
  m = new Mover();
}

void draw() {
  background(255);

  PVector gravity = new PVector(0, 0.3);
  gravity.mult(m.mass);
  m.applyForce(gravity);
  //PVector wind = new PVector(0.2, 0);
 //  m.applyForce(wind);

  //применение трения
  if (mousePressed) {
    PVector friction = m.velocity.get();
    friction.normalize();
    //friction.mult(-1); нет необходимости 
    /*
        Давайте определим направление силы трения
        (единичный вектор в направлении, противоположном
        скорости).
    */
    float c = -0.1;
    friction.mult(c);
    m.applyForce(friction);
  }

  m.update();
  m.edges();
  m.display();
}
/*
Создайте зоны трения в эскизе обработки таким 
образом, чтобы объекты испытывали трение только
при пересечении этих зон. Что, если вы измените 
прочность (коэффициент трения) каждой области? 
Что, если вы создадите в некоторых карманах функцию,
противоположную трению, то есть, когда вы входите в 
данный карман, вы на самом деле ускоряетесь, 
а не замедляетесь?
*/
