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
  String uid = ui.selectedAsset.uid;
  
  // Запрашиваем данные и распределяем Стохастик и EMA по переменным интерфейса
  IndicatorPackage pack5m = broker.fetchAndCalculate(uid, "CANDLE_INTERVAL_5_MIN", 4); // увеличили до 4 дней для EMA
  ui.tf5m = pack5m.stoch;
  ui.tf5mEma = pack5m.ema;
  
  IndicatorPackage pack15m = broker.fetchAndCalculate(uid, "CANDLE_INTERVAL_15_MIN", 6); // увеличили до 6 дней
  ui.tf15m = pack15m.stoch;
  ui.tf15mEma = pack15m.ema;
  
  IndicatorPackage pack30m = broker.fetchAndCalculate(uid, "CANDLE_INTERVAL_30_MIN", 10); // увеличили до 10 дней
  ui.tf30m = pack30m.stoch;
  ui.tf30mEma = pack30m.ema;
  
  IndicatorPackage pack1h = broker.fetchAndCalculate(uid, "CANDLE_INTERVAL_HOUR", 15); // увеличили до 15 дней
  ui.tf1h = pack1h.stoch;
  ui.tf1hEma = pack1h.ema;
  
  IndicatorPackage pack4h = broker.fetchAndCalculate(uid, "CANDLE_INTERVAL_4_HOUR", 45); // увеличили до 45 дней для полноценной EMA 200
  ui.tf4h = pack4h.stoch;
  ui.tf4hEma = pack4h.ema;
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
