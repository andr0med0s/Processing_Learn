// Need G4P library
import g4p_controls.*;
// You can remove the PeasyCam import if you are not using
// the GViewPeasyCam control or the PeasyCam library.
import peasy.*;


public void setup(){
  size(600, 600, JAVA2D);
  createGUI();
  customGUI();
  colorMode(HSB);
  // Place your setup code here
  
}

int D = 50;
color col;
int we = 1;
public void draw(){
  background(230);
  fill(col);
  strokeWeight(we);
  circle(width/2, height/2, D);
  
}

// Use this method to add additional statements
// to customise the GUI controls
public void customGUI(){

}
