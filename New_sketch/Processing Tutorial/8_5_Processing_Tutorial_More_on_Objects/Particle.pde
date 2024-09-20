class Particle {
  float x, y;
  float r;
  
  Particle(){                                       //перегрузка конструктора
    x = random(width);
    y = random(height);
    r = random(4, 18);
}
  
  Particle (float tempX, float tempY, float tempR){ //перегрузка конструктора
    x = tempX;
    y = tempY;
    r = tempR;
  }  
  
  boolean overlaps(Particle other){
    //return  ... ;
    float d = dist(x, y, other.x, other.y);
    if (d < r + other.r) {
      return true;
    }else{
      return false; 
    }
  }
  
  void display(){
    stroke(255);
    strokeWeight(4);
    noFill();
    ellipse(x, y, r * 2, r * 2);
  }
}
