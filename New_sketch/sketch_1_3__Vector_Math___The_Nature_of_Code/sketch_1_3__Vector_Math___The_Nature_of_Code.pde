 void setup(){
   size(500, 300);
 }
 
 void draw(){
   background(255);
   strokeWeight(2);
   stroke(0);
   noFill();
   
   translate(width/2, height/2);  //Нарисуйте линию, представляющую вектор.
   ellipse(0,0,4,4);
   
   PVector mouse = new PVector(mouseX, mouseY);      // Два PVectora один для расположения мыши                                                      
   PVector center = new PVector(width/2, height/2);  //и один для центра окна
   
   mouse.sub(center); // Вычитание PVector
   //mouse.mult(5);
      mouse.mult(0.1);
      
//Когда мы говорим о умножении вектора,
//мы обычно имеем в виду масштабирование
//масштабирование вектора
   
   line(0,0,mouse.x, mouse.y); 
 }
