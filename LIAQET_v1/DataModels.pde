// === ВКЛАДКА: DataModels ===

class Candle {
  float high, low, close;
  Candle(float h, float l, float c) {
    this.high = h;
    this.low = l;
    this.close = c;
  }
}

class StochasticResult {
  float k, d;
  boolean isError;
  StochasticResult() {
    this.isError = true;
  }
  StochasticResult(float k, float d) {
    this.k = k;
    this.d = d;
    this.isError = false;
  }
}

class EmaResult {
  float value;            
  float distancePercent;  
  String trendDirection;  
  boolean isError;

  EmaResult() {
    this.isError = true;
  }
  EmaResult(float value, float distancePercent, String trendDirection) {
    this.value = value;
    this.distancePercent = distancePercent;
    this.trendDirection = trendDirection;
    this.isError = false;
  }
}

class InstrumentItem {
  String name, ticker, uid, type;
  float x, y, w, h;

  InstrumentItem(String n, String t, String u, String type) {
    this.name = n;
    this.ticker = t;
    this.uid = u;
    this.type = type;
  }

  void updatePosition(float x, float y, float w, float h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }

  void drawItem(PApplet app) {
    boolean hover = (app.mouseX > x && app.mouseX < x + w && app.mouseY > y && app.mouseY < y + h);
    app.fill(hover ? 45 : 33);
    app.stroke(hover ? app.color(0, 150, 255) : 60);
    app.rect(x, y, w, h, 6);

    app.fill(255);
    app.textSize(15);
    app.text(name + " (" + ticker + ")", x + 15, y + 27);
    app.fill(130);
    app.textSize(12);
    app.text("Тип: " + type + "  |  UID: " + uid, x + 15, y + 48);
  }

  boolean isHovered(float mx, float my) {
    return (mx > x && mx < x + w && my > y && my < y + h);
  }
}

class IndicatorPackage {
  public StochasticResult stoch;
  public EmaResult ema;
  IndicatorPackage(StochasticResult s, EmaResult e) {
    this.stoch = s;
    this.ema = e;
  }
}
