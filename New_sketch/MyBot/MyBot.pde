PShape bot;

void setup() {
  size(720, 480);

  bot = loadShape("robots1.svg");
} 

void draw(){
  background(102);
  bot.enableStyle();
  shape(bot, 145, 65);
  
 
}
