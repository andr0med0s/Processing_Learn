//Particle p;
ArrayList<Particle> particles;

void setup() {
  size(640, 360);
  //p = new Particle(new PVector(width/2,20));
  particles = new ArrayList<Particle>();

  for (int i=0; i<10; i++) {
    particles.add(new Particle(new PVector(width/2, 20)));
    //background(255);
    //smooth();
  }
}

void draw() {
  background(255);

  for (Particle p : particles) {
    p.update();
    p.display();
  }

  //Particle p = particles.get(0);
  //p.update();
  //p.display();
  //p.run();
  //if (p.isDead()) {
  //  p = new Particle(new PVector(width/2,20));
  //  //println("Particle dead!");
  //}
}
