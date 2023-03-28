

ParticleSystem ps;

void setup() {
  size(640,360);
  ps = new ParticleSystem(new PVector(width/2,50));
}

void draw() {
  background(255);
  
  PVector gravity = new PVector(0,0.05);
  ps.applyForce(gravity);
  
  if(mousePressed){
    PVector wind = new PVector(0.1,0);
    ps.applyForce(wind);
  }
  
  ps.addParticle();
  ps.run();
}
