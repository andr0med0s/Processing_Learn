

Bubble[] bubbles = new Bubble[25];

void setup() {
  //size(640, 360, P2D);
   size(640, 360 );
  //bubbles[0] = new Bubble(64, 255, 0, 0);
  //bubbles[1] = new Bubble(64, 125, 100, 255);
  //bubbles[2] = new Bubble(24);
    for (int i = 0; i < bubbles.length; i++) {
    //bubbles[i] = new Bubble (64, 125, 100, 255);
        //bubbles[i] = new Bubble (64);
        //bubbles[i] = new Bubble (i*4);
        bubbles[i] = new Bubble (random(60));
    }
}

void draw() {
  background(255);
  for (int i = 0; i < bubbles.length; i++) {
    bubbles[i].ascend();
    bubbles[i].display();
    bubbles[i].top();
  }
}
