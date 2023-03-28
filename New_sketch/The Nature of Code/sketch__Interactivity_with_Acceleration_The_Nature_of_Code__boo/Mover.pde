   /*
       /*
      Когда вы вызываете статическую функцию, вместо ссылки на фактический экземпляр объекта вы просто
      ссылаетесь на имя самого класса.
      PVector v = new PVector(0,0);
      PVector u = new PVector(4,5);
      //PVector w = v.add(u); Не обманывайтесь, это неверно!!!!
      PVector w = PVector.add(v,u)
      
      ----------------
      PVector.add(v,u); //Статический: вызывается из имени класса.
      v.add(u);         //Нестатический: вызывается из экземпляра объекта.
      
      
          static PVector add(PVector v1, PVector v2) {
      PVector v3 = new PVector(v1.x + v2.x, v1.y + v2.y);
      return v3;
      _________________________
      Статическая версия add позволяет нам сложить
      два вектора вместе и присвоить
      результат новому вектору, оставив
      исходные векторы (v и u выше) нетронутыми.
      __________________________
      
      Здесь есть несколько отличий:
      • Функция помечена как статическая.
      • Функция не имеет возвращаемого типа void, а скорее возвращает вектор.
      • Функция создает новый вектор (v3) и возвращает сумму компонентов
      v1 и v2 в этом новом PVector.
      
      Класс Vector имеет статические версии add(), sub(), mult() и div()
    */
       
    /*
    PVector v = new PVector(0, 0);
    PVector u = PVector.mult(v, 2);
    PVector w = PVector.sub(v, u);
    w.div(3);
    */

class Mover {
  PVector location;
  PVector velocity;
  PVector acceleration;

  float topspeed;

  Mover() {
    location = new PVector(width/2, height/2);
    velocity = new PVector(0, 0);
    acceleration = new PVector(-0.001, 0.01);
    topspeed = 10;
  }

  void update() {
    PVector mouse = new PVector(mouseX, mouseY); //PVector
    PVector dir = PVector.sub(mouse, location);  // Шаг 1: Вычислите направление
                                                 //Смотри! Мы используем статическую ссылку на
                                                 // sub(), потому что мы хотим, чтобы новый PVector
                                                 // указывал из одной точки в другую.
    
    dir.normalize();                              //Шаг 2: Нормализация
    
    dir.mult(0.5);                                //Шаг 3: Масштабирование
     
    acceleration = dir;                           //Шаг 4: Ускорение
    
    velocity.add(acceleration);
    velocity.limit(topspeed);
    location.add(velocity);
  }



  void edges() {
    if (location.x > width)  location.x = 0;
    if (location.x < 0)      location.x = width;
    if (location.y > height) location.y = 0;
    if (location.y < 0)      location.y = height;
  }

  void display() {
    stroke(0);
    strokeWeight(2);
    fill(127);
    ellipse(location.x, location.y, 48, 48);
  }
}
