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

int cols = 40;
int rows = 40;

//ArrayList<Particle>particles;
Particle[][]particles = new Particle[40][40];
ArrayList<Spring>springs;

float w = 10;

VerletPhysics3D physics;

void setup() {
  size(600, 600, P3D);
  //particles = new ArrayList<Particle>();
  springs = new ArrayList<Spring>();

  physics = new VerletPhysics3D();
  Vec3D gravity = new Vec3D(0, 1, 0);
  GravityBehavior3D gb = new GravityBehavior3D (gravity);
  physics.addBehavior(gb);

  float x = -200;
  for (int i=0; i < cols; i++) {
    float z = -200;
    for (int j=0; j < rows; j++) {
      Particle p = new Particle(x, -100, z);
      //particles.add(p);
      particles[i][j] = p;
      physics.addParticle(p);
      z = z + w;
    }
    x = x + w;
  }

  for (int i=0; i < cols-1; i++) {
    for (int j=0; j < rows-1; j++) {
      Particle a = particles[i][j];
      Particle b1 = particles[i+1][j];
      //Particle a2 = particles[i][j];
      Particle b2 = particles[i][j+1];
      Particle b3 = particles[i+1][j+1];
      Spring s1 = new Spring(a, b1);
      springs.add(s1);
      physics.addSpring(s1);
      Spring s2 = new Spring(a, b2);
      springs.add(s2);
      physics.addSpring(s2);
      Spring s3 = new Spring(a, b3);
      springs.add(s3);
      physics.addSpring(s3);
    }
  }

  //for (int i = 0; i < particles.size()-1; i++) {
  //  Particle a = particles.get(i);
  //  Particle b = particles.get(i+1);
  //  Spring s = new Spring(a, b);
  //  springs.add(s);
  //  physics.addSpring(s);
  //}

  //Particle p1 = particles.get(0);
  //p1.lock();
  //Particle p2 = particles.get(particles.size()-1);
  //p2.lock();
  particles[0][0].lock();
  particles[cols-1][0].lock();
  particles[0][rows-1].lock();
  particles[cols-1][rows-1].lock();
}

float a = 0;
void draw() {
  background(51);
  translate(width/2, height/2);
  //rotateX(a);
  a += 0.01;
  physics.update();

  //for (Particle p : particles){
  //  p.display();
  //}
  for (int i=0; i < cols; i++) {
    for (int j=0; j < rows; j++) {
      //particles[i][j].display();
    }
  }

  for (Spring s : springs) {
    s.display();
  }
}