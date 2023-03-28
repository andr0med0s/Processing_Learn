PImage cloudImg;
PImage groundBg;
PImage[] persArr;

int xStep;
int idx = 0;
float y;
float x;
float bgMove = 0;

void setup() {
  size(900, 500);
  groundBg = loadImage("grass.png");
  cloudImg = loadImage("sk.png");

  persArr = new PImage[9];
  persArr[0] = loadImage("man0.png");
  persArr[1] = loadImage("man1.png");
  persArr[2] = loadImage("man2.png");
  persArr[3] = loadImage("man3.png");
  persArr[4] = loadImage("man4.png");
  persArr[5] = loadImage("man5.png");
  persArr[6] = loadImage("man6.png");
  persArr[7] = loadImage("man7.png");


  y = random(10, height - 50);
}

void draw() {

  background(0);
  persArr[idx].resize(0, 240);
  image(persArr[idx], 100, 100);

  //image(groundBg,0,height-groundBg.height);
  for (int i=0; i < xStep + 3 ; i++) {
    image(groundBg, groundBg.width * i + bgMove, height-groundBg.height);
    
    bgMove-=1;
    
    if(bgMove<(-1*groundBg.width)) bgMove = 0;
  }

  image(cloudImg, x, y, 100, 100);
  x = x - 1;
  if (x < -20) {
    x = width + 20;
    y = random(10, height - 50);
  }
  
    if (frameCount % 12 == 0) {
    idx = idx+1;
  }
  if (idx>7) {
    idx = 0;
  }
}
