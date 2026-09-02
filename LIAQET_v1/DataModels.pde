// === ВКЛАДКА: DataModels ===
import java.io.File;

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

// Новый класс для хранения результатов расчета скользящей средней
class EmaResult {
  float value;            // Само значение EMA
  float distancePercent;  // Процент отклонения текущей цены от EMA
  String trendDirection;  // Направление ("вверх", "вниз" или "горизонтально")
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

// === НОВЫЙ МОДУЛЬ ДЛЯ ИЗБРАННОГО ===
class FavoritesManager {
  private PApplet app;
  private String fileName = "favorites.json";
  public ArrayList<InstrumentItem> list = new ArrayList<InstrumentItem>();

  FavoritesManager(PApplet app) {
    this.app = app;
    loadFavorites();
  }

  void loadFavorites() {
    list.clear();
    String path = app.dataPath(fileName);
    File file = new File(path);
    if (!file.exists()) return;

    try {
      JSONArray jsonArray = app.loadJSONArray(path);
      for (int i = 0; i < jsonArray.size(); i++) {
        JSONObject obj = jsonArray.getJSONObject(i);
        list.add(new InstrumentItem(
          obj.getString("name"),
          obj.getString("ticker"),
          obj.getString("uid"),
          obj.getString("type")
        ));
      }
    } catch (Exception e) {
      println("Ошибка загрузки избранного: " + e.getMessage());
    }
  }

  void saveFavorites() {
    JSONArray jsonArray = new JSONArray();
    for (int i = 0; i < list.size(); i++) {
      InstrumentItem item = list.get(i);
      JSONObject obj = new JSONObject();
      obj.setString("name", item.name);
      obj.setString("ticker", item.ticker);
      obj.setString("uid", item.uid);
      obj.setString("type", item.type);
      jsonArray.setJSONObject(i, obj);
    }
    app.saveJSONArray(jsonArray, app.dataPath(fileName));
  }

  void add(InstrumentItem item) {
    if (!contains(item.uid)) {
      list.add(item);
      saveFavorites();
    }
  }

  void remove(String uid) {
    for (int i = list.size() - 1; i >= 0; i--) {
      if (list.get(i).uid.equals(uid)) {
        list.remove(i);
        saveFavorites();
        break;
      }
    }
  }

  boolean contains(String uid) {
    for (InstrumentItem item : list) {
      if (item.uid.equals(uid)) return true;
    }
    return false;
  }
}