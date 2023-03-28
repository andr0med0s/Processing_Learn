//5.2: If, Else If, Else - Processing Tutorial

void setup () {
  size(640, 360);
}

void draw() {
  background(0);

  //if (mouseX > 100) {
  //  // background(255, 0, 0);
  //  fill(255, 0, 0);
  //  rect(300, 100, 50, 50);
  //}

  //if (mouseX > 200) {
  //  //background(0, 0, 255);
  //  fill(0, 255, 0);
  //  rect(300, 300, 50, 50);
  //}

  //if (mouseX > 100) {
  //  fill(255, 0, 0);
  //  rect(300, 100, 50, 50);
  //} else if (mouseX > 200) {
  //  fill(0, 255, 0);
  //  rect(300, 300, 50, 50);
  //}

  //  if (mouseX > 500) {
  //    fill(255, 0, 0);
  //    rect(300, 100, 50, 50);
  //  } else if (mouseX > 400) {
  //    fill(0, 255, 255);
  //    rect(300, 200, 50, 50);
  //  }else if (mouseX > 300) {
  //    fill(255, 255, 0);
  //    rect(100, 300, 50, 50);
  //  }else if (mouseX > 200) {
  //    fill(0, 255, 255);
  //    rect(300, 200, 60, 50);
  //  }

  //  stroke(255);
  //  line(100, 0, 100, height);
  //  line(200, 0, 200, height );
  //  line(300, 0, 300, height );
  //  line(400, 0, 400, height );
  //  line(500, 0, 500, height );
  
  //-----------5.3: Logical Operators: AND (&&), OR(||) - Processing Tutorial
  
  if (mouseX>width/2 && mouseY>height/2) {  // красный 
    fill(255, 0, 0); 
    rect(width/2, height/2, width/2, height);
    //--------------------------
  } else if (mouseX<width/2 && mouseY>height/2) {  //зеленый
    fill(0, 255, 0);
    rect(0, height/2, width/2, height);
  } 
  //-----------------
  if (mouseX>width/2 && mouseY<height/2  ) { // желтый
    fill(255, 255, 0);
    rect(width/2, 0, width/2, height/2);
    //-----------------
  } else if ( mouseX<width/2 && mouseY<height/2) { // синий
    fill(0, 0, 255);
    rect(0, 0, width/2, height/2);
  }

  stroke(255);
  line(width/2, 0, width/2, height);
  line(0, height/2, width, height/2);
}
