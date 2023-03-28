
//ParticleSystem ps;

ArrayList<ParticleSystem> systems;

void setup() {
  size(640, 360);
  //ps = new ParticleSystem();
   systems = new ArrayList<ParticleSystem>();
}

void draw() {
  background(255);
  //ps.addParticle();
  ////particles.add(new Particle(new PVector(width/2, 20)));

  //ps.run();
    for (ParticleSystem ps: systems) {
    ps.run();
    ps.addParticle(); 
  }
}

void mousePressed() {
  systems.add(new ParticleSystem(1,new PVector(mouseX,mouseY)));
}
