//Bubble b0;
//Bubble b1;

Bubble[] bubbles = new Bubble[3];

void setup() {
  size(640, 360);
  bubbles[0] = new Bubble(64, 255, 0, 0);
  bubbles[1] = new Bubble(64, 125, 100, 255);
  bubbles[2] = new Bubble(24);
}

void draw() {
  background(255);
  bubbles[0].ascend();
  bubbles[0].display();
  bubbles[0].top();

  bubbles[1].ascend();
  bubbles[1].display();
  bubbles[1].top();

  bubbles[2].ascend();
  bubbles[2].display();
  bubbles[2].top();
}
