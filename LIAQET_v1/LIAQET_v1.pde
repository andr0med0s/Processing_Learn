//**********************************************************************
// 1 === ГЛАВНАЯ ВКЛАДКА ===
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Properties;

TInvestClient broker;
TerminalView ui;
LocalAIClient ai;
UIController controller;

String apiKey = "";
String lmStudioUrl = "";

void setup() {
  size(600, 750);
  textFont(createFont("Arial", 14));

  loadConfig(); // Загрузка ключа из config.properties

  broker = new TInvestClient(apiKey);
  ai = new LocalAIClient();
  ui = new TerminalView(this, broker, ai);
  controller = new UIController(this, broker, ui, ai);

  // Сброс кэша оперативной памяти для гарантированного обновления списков
  // === ПРАВИЛЬНЫЙ СБРОС КЭША ПРИ СТАРТЕ ===
  // Строку ui.favManager.list.clear(); ОТСЮДА ПОЛНОСТЬЮ УДАЛЯЕМ!
  
  broker.foundInstruments.clear(); // Оставляем только очистку результатов старого поиска
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

void mouseWheel(MouseEvent event) {
  controller.handleMouseWheel(event.getCount());
}

void runNetworkSearch() {
  broker.performSearch(ui.getInputText());
}

// Асинхронный расчет индикаторов с эталонными лимитами Мосбиржи
void runAnalyticCalculation() {
  final String uid = ui.selectedAsset.uid;
  final String type = ui.selectedAsset.type.toLowerCase().trim(); 
  final int period = ui.emaPeriod; 

  new Thread(new Runnable() {
    public void run() {
      println("[Аналитический поток] Старт загрузки для типа [" + type + "]...");
      
      int d5m = 1, d15m = 1, d30m = 1, d1h = 7, d4h = 30; // Безопасные интервалы во избежание HTTP 400
      
      if (type.contains("share")) {
        println("[Аналитический поток] Распознана акция. Применяем эталонные интервалы.");
      } else {
        println("[Аналитический поток] Инструмент определен как фьючерс/иное.");
      }
      
      IndicatorPackage pack5m  = broker.fetchAndCalculate(uid, "CANDLE_INTERVAL_5_MIN", d5m, period, ui.selectedAsset.ticker);
      IndicatorPackage pack15m = broker.fetchAndCalculate(uid, "CANDLE_INTERVAL_15_MIN", d15m, period, ui.selectedAsset.ticker);
      IndicatorPackage pack30m = broker.fetchAndCalculate(uid, "CANDLE_INTERVAL_30_MIN", d30m, period, ui.selectedAsset.ticker);
      IndicatorPackage pack1h  = broker.fetchAndCalculate(uid, "CANDLE_INTERVAL_HOUR", d1h, period, ui.selectedAsset.ticker);
      IndicatorPackage pack4h  = broker.fetchAndCalculate(uid, "CANDLE_INTERVAL_4_HOUR", d4h, period, ui.selectedAsset.ticker);
      
      // Атомарное обновление UI-ссылок
      ui.tf5m = pack5m.stoch;     ui.tf5mEma = pack5m.ema;
      ui.tf15m = pack15m.stoch;   ui.tf15mEma = pack15m.ema;
      ui.tf30m = pack30m.stoch;   ui.tf30mEma = pack30m.ema;
      ui.tf1h = pack1h.stoch;     ui.tf1hEma = pack1h.ema;
      ui.tf4h = pack4h.stoch;     ui.tf4hEma = pack4h.ema;
      
      println("[Аналитический поток] Все индикаторы успешно обновлены.");
    }
  }).start();
}

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
