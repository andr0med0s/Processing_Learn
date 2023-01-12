PShape bot;
Particle p1;
Particle p2;
Particle p3;

void setup() {
  size(720, 480);

  bot = loadShape("robots1.svg");
  
  //----------
    p1 = new Particle (500, 130, 10);
  //p2 = new Particle (500, 200, 100); 
  p2 = new Particle (); 
  //p3 = new Particle();
  p3 = new Particle (500, 200, 25);
} 

void draw(){
  background(102);
  bot.enableStyle();
  
  
 //-------------
   
  if(p1.overlaps(p2)){
     background(0, 255, 0);
  }
  
    if(p2.overlaps(p3)){
     background(255, 0, 0);
  }
  
  shape(bot, 435, 20);

  p2.x = mouseX;
  p2.y = mouseY;
  
  p1.display();
  p2.display();
  p3.display();
}
