// Need G4P library
import g4p_controls.*;
// You can remove the PeasyCam import if you are not using
// the GViewPeasyCam control or the PeasyCam library.
import peasy.*;

float col;
float squareSize;
int dx;
int dy;

public void setup() {
  size(800, 800, JAVA2D);
  createGUI();
  customGUI();
  // Place your setup code here

  frameRate(20);
  blendMode(ADD);
  
}

void toggleClick(){
  loop();
}



public void draw() {
  background(0);
  int i = 0;
  while (i < 50) {
    i++;
    println(i);
    int j = 0;
    while (j<10) {
      j++;

      int posX = i * dx;
      int posY = j * dy;
      float dist = random(80);
      //float col = random(255);
      
      //float squareSize = random(50);
      print(j + " ");
      fill(col, 0, 0);
      rect(posX, posY, squareSize, squareSize);
      fill(0, col, 0);
      rect(posX + dist, posY + dist, squareSize, squareSize);
      fill(0, 0, col);
      rect(posX + dist * 2, posY + dist * 2, squareSize, squareSize);
    }
  }
}


// Use this method to add additional statements
// to customise the GUI controls
public void customGUI() {
}
