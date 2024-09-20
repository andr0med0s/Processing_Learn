Bubble b1;
Bubble b2;
Bubble b3;

void setup() {
  size(640, 360);
  b1 = new Bubble(64);
  b2 = new Bubble(16, 255,0,0);
  b3 = new Bubble(44, 125,100,255);
}

void draw() {
  background(255);
  b1.ascend();
  b1.display();
  b1.top();

  b3.ascend();
  b3.display();
  b3.top();

  b2.ascend();
  b2.display();
  b2.top();
}
