class Walker {
  int x, y;

  Walker() {
    x = width/2;
    y = height/2;
  }

  void render() {
    stroke(0);
    point(x, y);
  }

  void step() {

    float r = random(1);

    if (r < 0.4) {
      x++;
    } else if (r < 0.6) {
      x--;
    } else if (r < 0.8) {
      y++;
    } else {
      y--;
    }
    
    x = constrain(x, 0, width-1);
    y = constrain(y, 0, height-1);
  }
}
