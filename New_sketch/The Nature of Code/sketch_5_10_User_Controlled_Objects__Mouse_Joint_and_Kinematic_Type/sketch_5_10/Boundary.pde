//Природа кода
//Дэниел Шиффман
//http://natureofcode.com
//Фиксированный граничный класс (теперь включает угол)

class Boundary {

  //Граница — это простой прямоугольник с координатами x,y,шириной и высотой.
  float x;
  float y;
  float w;
  float h;
  //Но нам также нужно сделать тело для box2d, чтобы об этом знать.
  Body b;

 Boundary(float x_,float y_, float w_, float h_, float a) {
    x = x_;
    y = y_;
    w = w_;
    h = h_;

    //Определить многоугольник
    PolygonShape sd = new PolygonShape();
    //Выясните координаты box2d
    float box2dW = box2d.scalarPixelsToWorld(w/2);
    float box2dH = box2d.scalarPixelsToWorld(h/2);
    //Мы просто коробка
    sd.setAsBox(box2dW, box2dH);


    // Create the body
    BodyDef bd = new BodyDef();
    bd.type = BodyType.STATIC;
    bd.angle = a;
    bd.position.set(box2d.coordPixelsToWorld(x,y));
    b = box2d.createBody(bd);
    
    // Attached the shape to the body using a Fixture
    b.createFixture(sd,1);
  }

  // Draw the boundary, if it were at an angle we'd have to do something fancier
  void display() {
    noFill();
    stroke(127);
    fill(127);
    strokeWeight(1);
    rectMode(CENTER);

    float a = b.getAngle();

    pushMatrix();
    translate(x,y);
    rotate(-a);
    rect(0,0,w,h);
    popMatrix();
  }

}


