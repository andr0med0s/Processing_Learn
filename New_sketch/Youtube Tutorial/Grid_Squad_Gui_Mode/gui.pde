/* =========================================================
 * ====                   WARNING                        ===
 * =========================================================
 * The code in this tab has been generated from the GUI form
 * designer and care should be taken when editing this file.
 * Only add/edit code inside the event handlers i.e. only
 * use lines between the matching comment tags. e.g.

 void myBtnEvents(GButton button) { //_CODE_:button1:12356:
     // It is safe to enter your event code here  
 } //_CODE_:button1:12356:
 
 * Do not rename this tab!
 * =========================================================
 */

synchronized public void win_draw1(PApplet appc, GWinData data) { //_CODE_:window1:843213:
  appc.background(230);
} //_CODE_:window1:843213:

public void slider1_change1(GSlider source, GEvent event) { //_CODE_:slider1:767464:
  println("slider1 - GSlider >> GEvent." + event + " @ " + millis());
  squareSize = source.getValueI();
} //_CODE_:slider1:767464:

public void button2_click1(GButton source, GEvent event) { //_CODE_:button2:629127:
  println("button2 - GButton >> GEvent." + event + " @ " + millis());
  col = random(255);
} //_CODE_:button2:629127:

public void imgTogButton1_click1(GImageToggleButton source, GEvent event) { //_CODE_:imgTogButton1:857261:
   println(source + "   State: " + source.getState());
   if (source.getState() != 0){
     noLoop();
   }else{
     toggleClick();
   }
    
  
} //_CODE_:imgTogButton1:857261:

public void slider2_change1(GSlider source, GEvent event) { //_CODE_:slider2:867729:
  println("slider2 - GSlider >> GEvent." + event + " @ " + millis());
  dx = source.getValueI();
} //_CODE_:slider2:867729:

public void slider3_change1(GSlider source, GEvent event) { //_CODE_:slider3:809300:
  println("slider3 - GSlider >> GEvent." + event + " @ " + millis());
  dy = source.getValueI();
} //_CODE_:slider3:809300:



// Create all the GUI controls. 
// autogenerated do not edit
public void createGUI(){
  G4P.messagesEnabled(false);
  G4P.setGlobalColorScheme(GCScheme.BLUE_SCHEME);
  G4P.setMouseOverEnabled(false);
  surface.setTitle("Sketch Window");
  window1 = GWindow.getWindow(this, "Window title", 0, 0, 300, 300, JAVA2D);
  window1.noLoop();
  window1.setActionOnClose(G4P.KEEP_OPEN);
  window1.addDrawHandler(this, "win_draw1");
  slider1 = new GSlider(window1, 50, 10, 180, 50, 10.0);
  slider1.setShowValue(true);
  slider1.setShowLimits(true);
  slider1.setLimits(1, 0, 50);
  slider1.setNbrTicks(10);
  slider1.setShowTicks(true);
  slider1.setNumberFormat(G4P.INTEGER, 0);
  slider1.setOpaque(false);
  slider1.addEventHandler(this, "slider1_change1");
  button2 = new GButton(window1, 150, 230, 80, 30);
  button2.setText("color");
  button2.addEventHandler(this, "button2_click1");
  imgTogButton1 = new GImageToggleButton(window1, 40, 220);
  imgTogButton1.addEventHandler(this, "imgTogButton1_click1");
  slider2 = new GSlider(window1, 50, 70, 180, 50, 10.0);
  slider2.setShowValue(true);
  slider2.setShowLimits(true);
  slider2.setLimits(10, 10, 50);
  slider2.setNbrTicks(10);
  slider2.setShowTicks(true);
  slider2.setNumberFormat(G4P.INTEGER, 0);
  slider2.setOpaque(false);
  slider2.addEventHandler(this, "slider2_change1");
  slider3 = new GSlider(window1, 50, 130, 180, 50, 10.0);
  slider3.setShowValue(true);
  slider3.setShowLimits(true);
  slider3.setLimits(10, 10, 80);
  slider3.setNbrTicks(20);
  slider3.setShowTicks(true);
  slider3.setNumberFormat(G4P.INTEGER, 0);
  slider3.setOpaque(false);
  slider3.addEventHandler(this, "slider3_change1");
  window1.loop();
}

// Variable declarations 
// autogenerated do not edit
GWindow window1;
GSlider slider1; 
GButton button2; 
GImageToggleButton imgTogButton1; 
GSlider slider2; 
GSlider slider3; 