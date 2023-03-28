class ParticleSystem {
  ArrayList<Particle> particles;
  PVector origin;

  //ParticleSystem() {
  //  particles = new ArrayList<Particle>();

  //  for (int i=0; i<10; i++) {
  //    particles.add(new Particle(new PVector(width/2, 20)));
  //  }
  //}

  ParticleSystem(int num, PVector v) {
    particles = new ArrayList<Particle>();   // Initialize the arraylist
    origin = v.copy();                        // Store the origin point
    for (int i = 0; i < num; i++) {
      particles.add(new Particle(origin));    // Add "num" amount of particles to the arraylist
    }
  }

  //  void addParticle() {
  //    particles.add(new Particle(new PVector(width/2, 20)));
  //  }

  void run() {
    for (int i = particles.size()-1; i>=0; i-- ) {
      Particle p = particles.get(i);
      p.update();
      p.display();

      if (p.isDead()) {
        particles.remove(i);
      }
    }
  }

  void addParticle() {
    float r = random(1);
    if (r < 0.4) {
      particles.add(new SquareParticle(origin));
    } else {
      particles.add(new Particle(origin));
    }
    //particles.add(new SquareParticle(origin));
    //particles.add(new Particle(origin));
  }

  // A method to test if the particle system still has particles
  boolean dead() {
    if (particles.isEmpty()) {
      return true;
    } else {
      return false;
    }
  }
}
