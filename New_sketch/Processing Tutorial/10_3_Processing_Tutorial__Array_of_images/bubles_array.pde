
PImage[] flowers = new PImage[3];

Bubble[] bubbles = new Bubble[5];

void setup() {
  size(640, 360);
  /*
    //flowers[0] = loadImage("flower0.jpg");//
   //flowers[1] = loadImage("flower1.jpg");// вместо инициализации по отдельности ↓
   //flowers[2] = loadImage("flower2.jpg");//
   
   for (int i = 0; i < flowers.length; i++){
   flowers[i] = loadImage("floweri.jpg");      |
   }                                           |
                                               ↓
   */
  for (int i = 0; i < flowers.length; i++) {
    flowers[i] = loadImage("flower"+i+".jpg");
  }

  for (int i = 0; i < bubbles.length; i++) {
    
    //bubbles[i] = new Bubble(100+i*100, 300, random(32, 72));
    
    int index = int(random(0, flowers.length)); // переменная index для рандомного всплытия картинок
    bubbles[i] = new Bubble(flowers[index], 100+i*100, 300, random(32, 72));
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
