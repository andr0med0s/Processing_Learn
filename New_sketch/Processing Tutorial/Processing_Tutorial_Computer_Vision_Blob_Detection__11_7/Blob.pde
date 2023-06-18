class Blob {
  //float x, y, w, h;
  float minx;
  float miny;
  float maxx;
  float maxy;

  //Blob(float px, float py) {
  //x = px;
  //y = py;
  //w = 1;
  //h = 1;
  Blob(float x, float y) {
    minx = x;
    miny = y;
    maxx = x;
    maxy = y;
  }
  
  void show(){
    stroke(0);
    fill(255);
    strokeWeight(2);
    rectMode(CORNERS);
    rect(minx, miny, maxx, maxy);
  }

  void add(float x, float y) {
    minx = min(minx, x);
    miny = min(miny, y);
    maxx = max(maxx, x);
    maxy = max(maxy, y);
  }
  
  float size(){
    return (maxx-minx)*(maxy-miny);
  }

  //boolean isNear(float px, float py) {
  //float cx = x + w/2;
  //float cy = y + h/2;
  boolean isNear(float x, float y) {
    float cx = (minx + maxx)/2;
    float cy = (miny + maxy)/2;

    float d = distSq(cx, cy, x, y);
    if (d < distThreshold * distThreshold) {
      return true;
    } else {
      return false;
    }
  }
}
