//  User Controlled Objects: Mouse Joint and Kinematic Type - The Nature of Code



// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Basic example of controlling an object with the mouse (by attaching a spring)

import shiffman.box2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;

// A reference to our box2d world
Box2DProcessing box2d;

// A list we'll use to track fixed objects
ArrayList boundaries;

// Just a single box this time
Box box;

// The Spring that will attach to the box from the mouse
Spring spring;

void setup() {
  size(640,360);
  // Initialize box2d physics and create the world
  box2d = new Box2DProcessing(this);
  box2d.createWorld();

  // Make the box
  box = new Box(width/2,height/2);

  // Make the spring (it doesn't really get initialized until the mouse is clicked)
  spring = new Spring();

  //Добавьте кучу фиксированных границ
  boundaries = new ArrayList();
  boundaries.add(new Boundary(width/2,height-5,width,10,0));
  boundaries.add(new Boundary(width/2,5,width,10,0));
  boundaries.add(new Boundary(width-5,height/2,10,height,0));
  boundaries.add(new Boundary(5,height/2,10,height,0));
}

//Когда мышь отпущена, с пружиной покончено.
void mouseReleased() {
  spring.destroy();
}

//При нажатии мыши мы. . .
void mousePressed() {
  // Check to see if the mouse was clicked on the box
  if (box.contains(mouseX, mouseY)) {
    // And if so, bind the mouse position to the box with a spring
    spring.bind(mouseX,mouseY,box);
  }
}

void draw() {
  background(255);

  // We must always step through time!
  box2d.step();

  //Всегда предупреждайте пружину о новом положении мыши.
  spring.update(mouseX,mouseY);

  // Draw the boundaries
  for (int i = 0; i < boundaries.size(); i++) {
    Boundary wall = (Boundary) boundaries.get(i);
    wall.display();
  }

  // Draw the box
  box.display();
  // Draw the spring (it only appears when active)
  spring.display();
}



