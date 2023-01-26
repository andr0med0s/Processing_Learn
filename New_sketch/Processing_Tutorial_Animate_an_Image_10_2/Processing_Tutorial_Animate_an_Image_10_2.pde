PImage image1;
PImage image2;
PImage image3;
PImage image4;
PImage image5;

float x1 = 0;
float x2 = 0;
float x3 = 0;
float x4 = 0;
float x5 = 0;
float direction = 1;
float direction2 = 2;
float direction3 = 3;
float direction4 = 4;
float direction5 = 5;

float angle = 0.0;
float offset = 50;
float offset1 = 105;
float offset2 = 160;
float offset3 = 215;
float offset4 = 270;
float offset5 = 325;
float scalar = 40;
float speed = 0.025;

float R;
float G;
float B;

void setup () {
    size (800, 600, P2D);
    image1 = loadImage("image1.jpg");
    image2 = loadImage("image2.jpg");
    image3 = loadImage("image3.jpg");
    image4 = loadImage("image4.jpg");
    image5 = loadImage("image5.jpg");
    rectMode(CENTER);
}

void draw () {
    background(222, 111, 111);

//-----------------
    // 1 прямоугольник
    fill(0,0,255);
   float y1 = offset + sin(angle) * scalar;
   //tint(255,random(255),mouseY);
    image(image1, x1 , y1, 500, 500);
    if(x1 > width+500 || x1 < -500){
        direction = direction * -1;
    }
    x1 = x1 + direction ;
    angle += speed;

//-----------------
    // 2 прямоугольник
    fill(0,0,255);
    float y2 = offset1 + sin(angle + 0.4) * scalar;
    image(image2, x2, y2, 100, 100);
    if(x2 > width+100 || x2 < -100){
        direction2 = direction2 * -1;
    }
    x2 = x2 + direction2 ;

//-----------------
    // 3 прямоугольник
    fill(0,0,255);
   float y3 = offset2 + sin(angle + 0.8) * scalar;
    image(image3, x3, y3, 300, 300);
    if(x3 > width+300 || x3 < -300){
        direction3 = direction3 * -1;
    }
    x3 = x3 + direction3 ;

//-----------------
    // 4 прямоугольник
    fill(0,0,255);
   float y4 = offset3 + sin(angle + 0.8) * scalar;
    image(image4, x4, y4, 200, 200);
    if(x4 > width+200 || x4 < -200){
        direction4 = direction4 * -1;
    }
    x4 = x4 + direction4 ;

//-----------------
    // 5 прямоугольник
    fill(0,0,255);
   float y5 = offset4 + sin(angle + 1) * scalar;
    image(image5, x5, y5, 150, 150); 
    if(x5 > width+150 || x5 < -150){
        direction5 = direction5 * -1;
    }
    x5 = x5 + direction5 ;

}
