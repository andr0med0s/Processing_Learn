// === ВКЛАДКА: TerminalView ===
import java.awt.Toolkit;
import java.awt.datatransfer.DataFlavor;
import java.awt.datatransfer.Transferable;

class TerminalView {
  private PApplet app;
  private TInvestClient broker;
  private LocalAIClient ai;

  public static final int SCREEN_FAVORITES = 0;
  public static final int SCREEN_SEARCH = 1;
  public static final int SCREEN_ANALYTICS = 2;

  private String inputBuffer = "";
  public int currentScreen = SCREEN_FAVORITES;

  public InstrumentItem selectedAsset = null;
  public FavoritesManager favManager;

  public StochasticResult tf4h, tf1h, tf30m, tf15m, tf5m;
  public EmaResult tf4hEma, tf1hEma, tf30mEma, tf15mEma, tf5mEma;

  // 0 = 30m/15m/5m, 1 = 4h/1h/30m
  public int timeframeMode = 0;
  public int emaPeriod = 200; // Новая переменная состояния (по умолчанию 200)

  public int copyTimestamp = 0;
  public String aiAnalysisTime = "";

  // === ОБЪЯВЛЕНИЕ ЭКЗЕМПЛЯРОВ КОМПОНЕНТОВ ===
  public Toggle tfToggle;
  public Toggle emaPeriodToggle; // Новый тогл периода EMA
  public Button aiBtn;
  public Button cpBtn;
  public Button refreshBtn;
  public Button favBtn;
  public Button searchRedirectBtn;

  public TerminalView(PApplet app, TInvestClient broker, LocalAIClient ai) {
    this.app = app;
    this.broker = broker;
    this.ai = ai;
    this.favManager = new FavoritesManager(app);
    
    initUIComponents();
  }

  // Централизованная инициализация всех интерактивных элементов
  private void initUIComponents() {
    // Кнопка-ссылка на экране Избранного
    searchRedirectBtn = new Button(25, 85, app.width - 50, 40, "+ Найти новый инструмент по тикеру", app.color(33), app.color(45), app.color(80), app.color(200));

    // Компоненты экрана Аналитики
    tfToggle = new Toggle(30, 78, 260, 28, "Группа", new String[]{"30м / 15м / 5м", "4ч / 1ч / 30м"}, app.color(40, 48, 62), app.color(55, 65, 85), app.color(70, 80, 100), app.color(200));
    
    // Новый запрашиваемый тогл периода EMA (размещен рядом с тоглом таймфреймов)
    emaPeriodToggle = new Toggle(300, 78, 270, 28, "Период EMA", new String[]{"EMA 200 (Тяжелая)", "EMA 50 (Быстрая)"}, app.color(40, 48, 62), app.color(55, 65, 85), app.color(70, 80, 100), app.color(200));

    aiBtn = new Button(30, 320, 160, 32, "Робот-Аналитик", app.color(0, 110, 60), app.color(0, 160, 90), app.color(0, 140, 80), app.color(255));
    cpBtn = new Button(210, 320, 160, 32, "Копировать ответ", app.color(50, 60, 75), app.color(75, 85, 100), app.color(80, 95, 110), app.color(240));
    refreshBtn = new Button(400, 320, 160, 32, "Обновить данные", app.color(70), app.color(100), app.color(60), app.color(255));
    
    // Кнопка избранного в шапке (параметры текста обновляются динамически в draw)
    favBtn = new Button(app.width - 150, 23, 120, 24, "", 0, 0, 0, app.color(255));
  }

  public String getInputText() { return inputBuffer; }
  public void setInputText(String txt) { this.inputBuffer = txt; }

  public boolean isAllDataLoaded() {
    return tf5m != null && tf15m != null && tf30m != null && tf1h != null && tf4h != null &&
           tf5mEma != null && tf15mEma != null && tf30mEma != null && tf1hEma != null && tf4hEma != null;
  }

  public void drawScreen() {
    switch (currentScreen) {
      case SCREEN_FAVORITES: drawFavoritesLayout(); break;
      case SCREEN_SEARCH: drawSearchLayout(); break;
      case SCREEN_ANALYTICS: drawTableLayout(); break;
    }
  }

  private void drawFavoritesLayout() {
    app.fill(255); app.textSize(18);
    app.text("Избранные инструменты", 25, 40);
    app.textSize(13); app.fill(140);
    app.text("Нажмите клавишу 'S' для быстрого открытия окна поиска", 25, 65);

    // Отрисовка через компонент
    searchRedirectBtn.draw(app);

    if (favManager.list.isEmpty()) {
      app.fill(130); app.textSize(14);
      app.text("Список избранного пуст. Добавьте тикеры через поиск.", 25, 170);
    } else {
      int startY = 150;
      for (int i = 0; i < favManager.list.size(); i++) {
        InstrumentItem item = favManager.list.get(i);
        item.updatePosition(25, startY + (i * 75), app.width - 50, 65);
        item.drawItem(app);
        
        app.fill(180, 50, 50); app.textSize(12);
        app.text("[Удалить]", item.x + item.w - 80, item.y + 27);
      }
    }
  }

  private void drawSearchLayout() {
    app.fill(255); app.textSize(16);
    app.text("Поиск тикера (T-Invest API Песочница):", 25, 40);
    app.textSize(12); app.fill(140);
    app.text("Нажмите ESC для возврата к избранному", 25, 120);

    app.noFill();
    app.stroke(broker.isSearching ? app.color(255, 204, 0) : 100);
    app.strokeWeight(1.5);
    app.rect(25, 55, app.width - 50, 42, 6);

    app.fill(255); app.textSize(14);
    String cursor = (app.frameCount / 15 % 2 == 0 && !broker.isSearching) ? "|" : "";
    app.text(inputBuffer + cursor, 38, 82);

    if (broker.foundInstruments.isEmpty()) {
      app.fill(150); app.textSize(14);
      app.text(broker.searchResult, 25, 140);
    } else {
      app.fill(170); app.textSize(14);
      app.text("Нажмите мышкой на нужный инструмент из списка:", 25, 130);
      int startY = 150;
      for (int i = 0; i < broker.foundInstruments.size(); i++) {
        InstrumentItem item = broker.foundInstruments.get(i);
        item.updatePosition(25, startY + (i * 75), app.width - 50, 65);
        item.drawItem(app);
      }
    }
  }

  private void drawTableLayout() {
    app.fill(255); app.textSize(18);
    app.text("Аналитика: " + selectedAsset.name + " (" + selectedAsset.ticker + ")", 30, 40);
    app.textSize(13); app.fill(140);
    app.text("Нажмите ESC или BACKSPACE для возврата к поиску", 30, 65);

    // Динамическое обновление состояний кнопки Избранного перед рендером
    boolean isFav = favManager.contains(selectedAsset.uid);
    favBtn.text = isFav ? " [+] В избранном" : "[-] Добавить";
    favBtn.baseColor = isFav ? app.color(100, 33, 33) : app.color(33, 100, 33);
    favBtn.hoverColor = isFav ? app.color(150, 50, 50) : app.color(50, 150, 50);
    favBtn.strokeColor = isFav ? app.color(255, 100, 100) : app.color(100, 255, 100);
    favBtn.draw(app);

    // Временной штамп системы
    app.fill(0, 140, 200); app.textSize(12); app.textAlign(app.RIGHT, app.BASELINE); 
    String timestamp = app.nf(app.day(), 2) + "." + app.nf(app.month(), 2) + "." + app.year() + " | " 
                     + app.nf(app.hour(), 2) + ":" + app.nf(app.minute(), 2) + ":" + app.nf(app.second(), 2);
    app.text(timestamp, app.width - 30, 65);
    app.textAlign(app.LEFT, app.BASELINE); 

    // Отрисовка переключателей через компоненты
    tfToggle.draw(app);
    emaPeriodToggle.draw(app);

    app.stroke(60);
    app.line(30, 115, app.width - 30, 115);
    app.line(30, 155, app.width - 30, 155);

    // Шапка таблицы
    app.textSize(13); app.fill(0, 160, 255); 
    app.text("Таймфрейм", 45, 132);
    app.text("Stochastic", 170, 132);
    app.text("Дистанция", 310, 132);
    app.text("Стратегия", 460, 132);

    app.fill(130, 145, 165); app.textSize(11); 
    app.text("(Интервал)", 45, 148);
    app.text("Lines %K / %D", 170, 148);
    // Динамический текст в зависимости от числового значения emaPeriod
String currentEmaLabel = "до EMA " + emaPeriod; 
    app.text(currentEmaLabel, 310, 148);
    app.text("Mean Reversion", 460, 148);

    app.textSize(14);

    if (!isAllDataLoaded()) {
      app.fill(255, 204, 0); app.textSize(15);
      app.text("Загрузка индикаторов... Считаем Стохастик и скользящую...", 45, 200);
    } else if (timeframeMode == 0) {
      renderRow("30 Минут (30m)", tf30m, tf30mEma, 190);
      renderRow("15 Минут (15m)", tf15m, tf15mEma, 240);
      renderRow("5 Минут (5m)", tf5m, tf5mEma, 290);
    } else {
      renderRow("4 Часа (4h)", tf4h, tf4hEma, 190);
      renderRow("1 Час (1h)", tf1h, tf1hEma, 240);
      renderRow("30 Минут (30m)", tf30m, tf30mEma, 290);
    }

    // Автосброс текста кнопки копирования
    if (cpBtn.text.equals("Скопировано!") && app.millis() - copyTimestamp > 2500) {
      cpBtn.text = "Копировать ответ";
    }

    // Изменение текста кнопки в зависимости от состояния ИИ
    aiBtn.text = ai.isThinking ? "Анализ..." : "Робот-Аналитик";

    // Отрисовка функциональных кнопок через методы классов
    aiBtn.draw(app);
    cpBtn.draw(app);
    refreshBtn.draw(app);

    if (aiAnalysisTime.length() > 0) {
      app.fill(100, 150, 165); app.textSize(11);
      app.text(aiAnalysisTime, 30, 362);
    }

    app.fill(225); app.textSize(13);
    app.text(ai.aiResponse, 30, 380, app.width - 60, 330); 
  }

  private void renderRow(String title, StochasticResult stoch, EmaResult ema, float y) {
    app.fill(255); app.textSize(14); app.text(title, 45, y);
    
    if (stoch.isError || ema.isError) {
      app.fill(255, 70, 70); app.text("Ошибка расчета индикаторов", 170, y);
      return;
    }

    app.fill(240);
    String stochValues = app.nf(stoch.k, 1, 1) + " / " + app.nf(stoch.d, 1, 1);
    app.text(stochValues, 170, y);

    float textW = app.textWidth(stochValues); 
    float arrowX = 170 + textW + 8; 
    app.textSize(12); 
    if (stoch.k > stoch.d + 0.5f) {
      app.fill(0, 255, 150); app.text("▲", arrowX, y);
    } else if (stoch.k < stoch.d - 0.5f) {
      app.fill(255, 50, 50); app.text("▼", arrowX, y);
    } else {
      app.fill(150); app.text("◆", arrowX, y);
    }
    app.textSize(14);

    String prefix = ema.distancePercent >= 0 ? "+" : "";
    app.fill(ema.distancePercent >= 0 ? app.color(255, 100, 100) : app.color(100, 255, 100));
    app.text(prefix + app.nf(ema.distancePercent, 1, 2) + "% (" + ema.trendDirection + ")", 310, y);

    if (stoch.k <= 20 && ema.distancePercent < -1.5f) {
      app.fill(0, 255, 150); app.text("BUY (Возврат вверх)", 460, y);
    } else if (stoch.k >= 80 && ema.distancePercent > 1.5f) {
      app.fill(255, 50, 50); app.text("SELL (Возврат вниз)", 460, y);
    } else {
      app.fill(150); app.text("Поиск паттерна...", 460, y);
    }
    
    app.stroke(40);
    app.line(30, y + 15, app.width - 30, y + 15);
  }

  public String getClipboardText() {
    try {
    java.awt.datatransfer.Clipboard clipboard = Toolkit.getDefaultToolkit().getSystemClipboard();
    Transferable contents = clipboard.getContents(null);
    if (contents != null && contents.isDataFlavorSupported(DataFlavor.stringFlavor)) {
      return (String) contents.getTransferData(DataFlavor.stringFlavor);
      }
    } catch (Exception e) {
      System.out.println("Ошибка буфера: " + e.getMessage()); 
      }return "";
  }
}