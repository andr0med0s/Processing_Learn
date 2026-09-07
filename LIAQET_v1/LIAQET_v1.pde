import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Properties;

TInvestClient broker;
TerminalView ui;
LocalAIClient ai;
UIController controller;

// Переменные для хранения настроек
String apiKey = "";
String lmStudioUrl = "";

void setup() {
  size(600, 750);
  textFont(createFont("Arial", 14));

  // 1. Сначала загружаем ключ из файла config.properties
  loadConfig();

  broker = new TInvestClient(apiKey);
  ai = new LocalAIClient();
  ui = new TerminalView(this, broker, ai);
  controller = new UIController(this, broker, ui, ai);
}

void draw() {
  background(25);
  ui.drawScreen();
}

void keyPressed() {
  controller.handleKeyPress(key, keyCode);
}

void mousePressed() {
  controller.handleMousePress(mouseX, mouseY);
}

void runNetworkSearch() {
  broker.performSearch(ui.getInputText());
}

void runAnalyticCalculation() {
  final String uid = ui.selectedAsset.uid;
  final int period = ui.emaPeriod; 

  // Единый фоновый поток для сетевых операций
  new Thread(new Runnable() {
    public void run() {
      println("[Аналитический поток] Старт загрузки и расчета данных...");
      
      // Локальные пакеты во избежание промежуточных NPE в UI-потоке
      IndicatorPackage pack5m = broker.fetchAndCalculate(uid, "CANDLE_INTERVAL_5_MIN", 4, period);
      IndicatorPackage pack15m = broker.fetchAndCalculate(uid, "CANDLE_INTERVAL_15_MIN", 6, period);
      IndicatorPackage pack30m = broker.fetchAndCalculate(uid, "CANDLE_INTERVAL_30_MIN", 10, period);
      IndicatorPackage pack1h = broker.fetchAndCalculate(uid, "CANDLE_INTERVAL_HOUR", 15, period);
      IndicatorPackage pack4h = broker.fetchAndCalculate(uid, "CANDLE_INTERVAL_4_HOUR", 45, period);
      
      // Атомарно (одновременно) присваиваем ссылки для UI
      ui.tf5m = pack5m.stoch;     ui.tf5mEma = pack5m.ema;
      ui.tf15m = pack15m.stoch;   ui.tf15mEma = pack15m.ema;
      ui.tf30m = pack30m.stoch;   ui.tf30mEma = pack30m.ema;
      ui.tf1h = pack1h.stoch;     ui.tf1hEma = pack1h.ema;
      ui.tf4h = pack4h.stoch;     ui.tf4hEma = pack4h.ema;
      
      println("[Аналитический поток] Все индикаторы успешно обновлены.");
    }
  }).start();
}


// Метод загрузки конфигурации
void loadConfig() {
  Properties prop = new Properties();
  String configPath = dataPath("config.properties");
  
  try (FileInputStream fis = new FileInputStream(configPath)) {
    prop.load(fis);
    apiKey = prop.getProperty("API_KEY", "NOT_FOUND");
    lmStudioUrl = prop.getProperty("LM_STUDIO_URL", "http://localhost:1234/v1");
  } catch (IOException e) {
    println("Файл config.properties не найден. Создаю дефолтный...");
    createDefaultConfig();
  }
}

// Метод создания дефолтного файла
void createDefaultConfig() {
  Properties prop = new Properties();
  prop.setProperty("API_KEY", "Ваш Ключ");
  prop.setProperty("LM_STUDIO_URL", "http://localhost:1234/v1");
  
  String configPath = dataPath("config.properties");
  try (FileOutputStream fos = new FileOutputStream(configPath)) {
    prop.store(fos, "Terminal Config");
    apiKey = "Ваш Ключ";
    lmStudioUrl = "http://localhost:1234/v1";
  } catch (IOException e) {
    e.printStackTrace();
  }
}
