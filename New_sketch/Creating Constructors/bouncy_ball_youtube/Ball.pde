public class Ball {
  private int y = 100;
  private int x = 400;
  private int dy = 5;
  private int dx = 0;
  private int size = 50;
  
  public Ball(int x, int y, int dx, int dy, int size) {
    this.x = x;
    this.y = y;
    this.dx = dx;
    this.dy = dy;
    this.size = size;
  }

  public void move() {
    y += dy;
    x += dx;
  }

  //We need to be able to change dx and dy
  public void setdy(int dy) {
    this.dy = dy;
  }

  public void setdx(int dx) {
    this.dx = dx;
  }

  //We need to be able to see where our ball is!
  public int getdy() {
    return this.dy;
  }

  public int getdx() {
    return this.dx;
  }

  public int getX() {
    return this.x;
  }

  public int getY() {
    return this.y;
  }

  public void display() {
    ellipse(x, y, size, size);
  }
}
