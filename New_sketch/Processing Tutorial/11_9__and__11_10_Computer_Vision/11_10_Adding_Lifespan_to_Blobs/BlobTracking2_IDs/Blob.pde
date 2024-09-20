class Blob {
  //float x, y, w, h;
  float minx;
  float miny;
  float maxx;
  float maxy;

  ArrayList<PVector> points;

  int id = 0; // id двоичных объектов

  int lifespan = maxLife;

  boolean taken = false; // сопоставление

  Blob(float x, float y) {
    minx = x;
    miny = y;
    maxx = x;
    maxy = y;
    points = new ArrayList<PVector>();
    points.add(new PVector(x, y));
  }

  boolean checkLife(){
    lifespan--;
    if (lifespan < 0) {
      return true;
    } else {
      return false;
    }
  }

  // void show(int num) {
  void show() {
    stroke(0);
    fill(255, lifespan);
    strokeWeight(2);
    rectMode(CORNERS);
    rect(minx, miny, maxx, maxy);
  /*
      // for (PVector v : points) {
      //   stroke(0, 0, 255);
      //   point(v.x, v.y);
      // }
  */

  textAlign(CENTER);
  textSize(64);
  fill(0);
  // text(num, minx + (maxx - minx) *0.5, miny + (maxy - miny) *0.5);
  // text(num, minx + (maxx - minx) *0.5, maxy - 10);
  text(id, minx + (maxx - minx) *0.5, maxy - 10);
  textSize(32);
  // text(lifespan, minx + (maxx - minx) *0.5, miny - 10);

  }

  void add(float x, float y) {
    points.add(new PVector(x, y));
    minx = min(minx, x);
    miny = min(miny, y);
    maxx = max(maxx, x);
    maxy = max(maxy, y);
  }

  void become(Blob other) {
    minx = other.minx;
    maxx = other.maxx;
    miny = other.miny;
    maxy = other.maxy;
  }

  float size() {
    return (maxx-minx)*(maxy-miny);
  }

  PVector getCenter() {
    float  x = (maxx - minx) * 0.5 + minx;
    float  y = (maxy - miny) * 0.5 + miny;
    return new PVector(x,y);
  }

  boolean isNear(float x, float y) {

    // The Rectangle "clamping" strategy
    //float cx = max(min(x, maxx), minx);
    //float cy = max(min(y, maxy), miny);
    //float d = distSq(cx, cy, x, y);

    // Closest point in blob strategy
    float d = 10000000;
    for (PVector v : points) {
      float tempD = distSq(x, y, v.x, v.y);
      if (tempD < d) {
        d = tempD;
      }
    }

    if (d < distThreshold * distThreshold) {
      return true;
    } else {
      return false;
    }
  }
}
