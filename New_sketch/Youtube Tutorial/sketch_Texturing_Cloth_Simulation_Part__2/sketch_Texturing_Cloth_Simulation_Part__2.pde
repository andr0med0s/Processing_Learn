import toxi.geom.*;
import toxi.geom.mesh.*;
import toxi.geom.mesh.subdiv.*;
import toxi.geom.mesh2d.*;
import toxi.geom.nurbs.*;
import toxi.math.*;
import toxi.math.conversion.*;
import toxi.math.noise.*;
import toxi.math.waves.*;
import toxi.util.*;
import toxi.util.datatypes.*;
import toxi.util.events.*;


import toxi.physics3d.*;
import toxi.physics3d.behaviors.*;
import toxi.physics3d.constraints.*;

PImage unikitty;

int res = 2;
int cols = 40 / res;
int rows = 40 / res;

//ArrayList<Particle>particles;
Particle[][]particles = new Particle[40][40];
ArrayList<Spring>springs;

float w = 10 * res;
float zoff = 0;

VerletPhysics3D physics;

void setup() {
  size(800, 600, P3D);
  springs = new ArrayList<Spring>();

  physics = new VerletPhysics3D();
  Vec3D gravity = new Vec3D(0, 0.5, 0);
  GravityBehavior3D gb = new GravityBehavior3D (gravity);
  physics.addBehavior(gb);

  float x = -cols*w/2 - 100;
  for (int i=0; i < cols; i++) {
    float y = -rows*w/2;
    for (int j=0; j < rows; j++) {
      Particle p = new Particle(x, y, 0);
      particles[i][j] = p;
      physics.addParticle(p);
      y = y + w;
    }
    x = x + w;
  }

  for (int i=0; i < cols; i++) {
    for (int j=0; j < rows; j++) {
      Particle a = particles[i][j];
      if (i !=cols-1) {
        Particle b1 = particles[i+1][j];
        Spring s1 = new Spring(a, b1);
        springs.add(s1);
        physics.addSpring(s1);
      }
      if (j !=rows-1) {
        Particle b2 = particles[i][j+1];
        Spring s2 = new Spring(a, b2);
        springs.add(s2);
        physics.addSpring(s2);
      }
    }
  }

  particles[0][0].lock();
  particles[0][rows-1].lock();

  unikitty = loadImage("unikitty6.jpg");
}

float a = 0;

void draw() {
  background(51);

  translate(width/2, height/2);
  //rotateX(PI/2);
  //rotateY(a);
  //a += 0.01;
  physics.update();

  //for (Particle p : particles){
  //  p.display();
  //}

  float xoff = 0;
  for (int i=0; i < cols; i++) {
    float yoff = 0;
    for (int j=0; j < rows; j++) {
      float n = noise(xoff, yoff);
      //particles[i][j].display();

      float windx = map(noise(xoff, yoff, zoff), 0, 1, 0, 3);
      float windz = map(noise(xoff+3000, yoff+3000, zoff), 0, 1, -1, 1); 

      Vec3D wind = new Vec3D(windx, 0, windz);
      particles[i][j].addForce(wind);
      yoff += 0.1;
    }
    xoff += 0.1;
  }
  zoff += 0.1;

  noFill();
  noStroke();
  //strokeWeight(1);
  textureMode(NORMAL);
  for (int j=0; j < rows-1; j++) {
    beginShape(TRIANGLE_STRIP);
    texture(unikitty);
    for (int i=0; i < cols; i++) {

      float x1 = particles[i][j].x;
      float y1 = particles[i][j].y;
      float z1 = particles[i][j].z;
      float u = map(i, 0, cols-1, 0, 1);
      float v1 = map(j, 0, rows-1, 0, 1);
      vertex(x1, y1, z1, u, v1);
      float x2 = particles[i][j+1].x;
      float y2 = particles[i][j+1].y;
      float z2 = particles[i][j+1].z;
      float v2 = map(j+1, 0, rows-1, 0, 1);
      vertex(x2, y2, z2, u, v2 );
    }
    endShape();
  }


  //for (Spring s : springs) {
  //  s.display();
  //}

  stroke(255);
  strokeWeight(4);
  line(-cols*w/2 - 100, -rows*w/2, -cols*w/2 - 100, height);
}