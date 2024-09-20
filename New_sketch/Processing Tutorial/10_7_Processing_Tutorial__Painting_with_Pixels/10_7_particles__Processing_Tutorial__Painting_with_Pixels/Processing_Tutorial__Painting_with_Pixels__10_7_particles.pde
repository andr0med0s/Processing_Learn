Particle[] particles;

PImage photon;
void setup() {
  size(1600, 900);
  //surface.setResizable(true);
  photon = loadImage("photon.jpg");
  photon.resize(1600, 900);

  particles = new Particle [100];
  for (int i = 0; i < particles.length; i++) {
    particles[i] = new Particle();
  }
  background(0);
}

void draw() {
  for (int boost = 0; boost < 10; boost++) {
    for (int i = 0; i < particles.length; i++) {
      particles[i].display();
      particles[i].move();
    }
  }
}
