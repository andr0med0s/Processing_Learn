import controlP5.*;

ControlP5 cp5;

void setup() {
  size(800, 600);
  cp5 = new ControlP5(this);
    //cp5.addButton("btn1");
    //cp5.addButton("btn2");
    //cp5.addButton("btn3");
    //cp5.addToggle("tgl1").linebreak();
    //cp5.addSlider("sld1", 0, 10);
    //cp5.addSlider("sld2", 0, 1);
  
  cp5.setFont(createFont("Roboto Bold", 20));

  cp5.addButton("btn")
    .setPosition(10, 10)
    .setSize(100, 30)
    .setLabel("button");

  cp5.addSlider("slider")
    .setPosition(10, 50)
    .setSize(100, 30)
    .setLabel("size")
    .setRange(0,100)
    .setNumberOfTickMarks(10+1);
    
    cp5.addColorWheel("col", 10, 100, 100);
}

void btn() {
  println("click");
}

void slider(int val){
  println(val);
  d = val;
}

int x, y, d;
color col;

void draw() {
  background(255);
  fill(110);
  rect(0, 0, 200, height);
  fill(col);
  circle(x+width/2, y+height/2, d);
}
