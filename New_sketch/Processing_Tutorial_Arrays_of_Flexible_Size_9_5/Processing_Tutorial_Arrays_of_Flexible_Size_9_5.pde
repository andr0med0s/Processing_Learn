Bubble[] bubbles = new Bubble[ 100];

int total = 0;

void setup() {

  size(640, 360 );
  for (int i = 0; i < bubbles.length; i++) {
    bubbles[i] = new Bubble (random(60));
  }
}

void mousePressed (){
  total ++ ;
}

void keyPressed (){
  total --;
}

void draw() {
  background(255);
  for (int i = 0; i < total; i++) {
    bubbles[i].ascend();
    bubbles[i].display();
    bubbles[i].top();
  }
}
