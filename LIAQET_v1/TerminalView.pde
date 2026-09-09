//*********************************
// 5 === ВКЛАДКА: TerminalView ===

import java.awt.Toolkit;
import java.awt.datatransfer.DataFlavor;
import java.awt.datatransfer.Transferable;

class TerminalView {
  private PApplet app; 
  private TInvestClient broker; 
  private LocalAIClient ai;
  
  public float aiScrollY = 0; // Вертикальный скролл текстового блока ИИ

  // Идентификаторы экранов системы
  public static final int SCREEN_FAVORITES = 0;
  public static final int SCREEN_SEARCH = 1;
  public static final int SCREEN_ANALYTICS = 2;

  private String inputBuffer = ""; 
  public int currentScreen = SCREEN_FAVORITES;

  public InstrumentItem selectedAsset = null; 
  public FavoritesManager favManager;
  
  // Кэш результатов технического анализа по таймфреймам
  public StochasticResult tf4h, tf1h, tf30m, tf15m, tf5m;
  public EmaResult tf4hEma, tf1hEma, tf30mEma, tf15mEma, tf5mEma;
  
  // Кэш результатов MFI Divergence v2 (Новые поля)
  public MfiResult tf4hMfi, tf1hMfi, tf30mMfi, tf15mMfi, tf5mMfi;

  public int timeframeMode = 0; // 0 = Младшие (30м/15м/5м), 1 = Старшие (4ч/1ч/30м)
  public int emaPeriod = 200;    // Текущий рабочий период EMA (200 или 50)
  public int copyTimestamp = 0;
  public String aiAnalysisTime = "";

  // Интерактивные компоненты UI
  public Toggle tfToggle, emaPeriodToggle;
  public Button aiBtn, cpBtn, refreshBtn, favBtn, searchRedirectBtn;

  public TerminalView(PApplet app, TInvestClient broker, LocalAIClient ai) {
    this.app = app; this.broker = broker; this.ai = ai; this.favManager = new FavoritesManager(app);
    initUIComponents();
  }

  // Инициализация всех кнопок и переключателей терминала
  private void initUIComponents() {
    searchRedirectBtn = new Button(25, 85, app.width - 50, 40, "+ Найти новый инструмент по тикеру", app.color(33), app.color(45), app.color(80), app.color(200));
    tfToggle = new Toggle(30, 78, 260, 28, "Группа", new String[]{"30м / 15м / 5м", "4ч / 1ч / 30м"}, app.color(40, 48, 62), app.color(55, 65, 85), app.color(70, 80, 100), app.color(200));
    emaPeriodToggle = new Toggle(300, 78, 270, 28, "Период EMA", new String[]{"EMA 200 (Тяжелая)", "EMA 50 (Быстрая)"}, app.color(40, 48, 62), app.color(55, 65, 85), app.color(70, 80, 100), app.color(200));
    aiBtn = new Button(30, 320, 160, 32, "Робот-Аналитик", app.color(0, 110, 60), app.color(0, 160, 90), app.color(0, 140, 80), app.color(255));
    cpBtn = new Button(210, 320, 160, 32, "Копировать ответ", app.color(50, 60, 75), app.color(75, 85, 100), app.color(80, 95, 110), app.color(240));
    refreshBtn = new Button(400, 320, 160, 32, "Обновить данные", app.color(70), app.color(100), app.color(60), app.color(255));
    favBtn = new Button(app.width - 150, 23, 120, 24, "", 0, 0, 0, app.color(255));
  }

  public String getInputText() { return inputBuffer; }
  public void setInputText(String txt) { this.inputBuffer = txt; }
  
  // Метод теперь строго проверяет загрузку всех индикаторов, включая MFI
  public boolean isAllDataLoaded() {
    return tf5m != null && tf15m != null && tf30m != null && tf1h != null && tf4h != null &&
           tf5mEma != null && tf15mEma != null && tf30mEma != null && tf1hEma != null && tf4hEma != null &&
           tf5mMfi != null && tf15mMfi != null && tf30mMfi != null && tf1hMfi != null && tf4hMfi != null;
  }

  public void drawScreen() {
    if (currentScreen == SCREEN_FAVORITES) drawFavoritesLayout();
    else if (currentScreen == SCREEN_SEARCH) drawSearchLayout();
    else if (currentScreen == SCREEN_ANALYTICS) drawTableLayout();
  }

  private void drawFavoritesLayout() {
    app.fill(255); app.textSize(18); app.text("Избранные инструменты", 25, 40);
    app.textSize(13); app.fill(140); app.text("Нажмите клавишу 'S' для быстрого открытия окна поиска", 25, 65);
    searchRedirectBtn.draw(app);

    if (favManager.list.isEmpty()) {
      app.fill(130); app.textSize(14); app.text("Список избранного пуст. Добавьте тикеры через поиск.", 25, 170);
    } else {
      for (int i = 0; i < favManager.list.size(); i++) {
        InstrumentItem item = favManager.list.get(i);
        item.updatePosition(25, 150 + (i * 75), app.width - 50, 65); item.drawItem(app);
        app.fill(180, 50, 50); app.textSize(12); app.text("[Удалить]", item.x + item.w - 80, item.y + 27);
      }
    }
  }

  private void drawSearchLayout() {
    app.fill(255); app.textSize(16); app.text("Поиск тикера:", 25, 40); 
    app.textSize(12); app.fill(140); app.text("Нажмите ESC для возврата к избранному", 25, 120);
    app.noFill(); app.stroke(broker.isSearching ? app.color(255, 204, 0) : 100);
    app.strokeWeight(1.5); app.rect(25, 55, app.width - 50, 42, 6);

    app.fill(255); app.textSize(14);
    String cursor = (app.frameCount / 15 % 2 == 0 && !broker.isSearching) ? "|" : "";
    app.text(inputBuffer + cursor, 38, 82);

    if (broker.foundInstruments.isEmpty()) {
      app.fill(150); app.textSize(14); app.text(broker.searchResult, 25, 140);
    } else {
      app.fill(170); app.textSize(14); app.text("Нажмите мышкой на нужный инструмент из списка:", 25, 130);
      for (int i = 0; i < broker.foundInstruments.size(); i++) {
        InstrumentItem item = broker.foundInstruments.get(i);
        item.updatePosition(25, 150 + (i * 75), app.width - 50, 65); item.drawItem(app);
      }
    }
  }

  private void drawTableLayout() {
    app.fill(255); app.textSize(18); app.text("Аналитика: " + selectedAsset.name + " (" + selectedAsset.ticker + ")", 30, 40);
    app.textSize(13); app.fill(140); app.text("Нажмите ESC или BACKSPACE для возврата к поиску", 30, 65);

    // Логика состояния кнопки Избранного
    boolean isFav = favManager.contains(selectedAsset.uid);
    favBtn.text = isFav ? " [+] В избранном" : "[-] Добавить";
    favBtn.baseColor = isFav ? app.color(100, 33, 33) : app.color(33, 100, 33);
    favBtn.hoverColor = isFav ? app.color(150, 50, 50) : app.color(50, 150, 50);
    favBtn.strokeColor = isFav ? app.color(255, 100, 100) : app.color(100, 255, 100);
    favBtn.draw(app);

    // Метка системного времени
    app.fill(0, 140, 200); app.textSize(12); app.textAlign(app.RIGHT, app.BASELINE); 
    app.text(app.nf(app.day(), 2) + "." + app.nf(app.month(), 2) + "." + app.year() + " | " + app.nf(app.hour(), 2) + ":" + app.nf(app.minute(), 2) + ":" + app.nf(app.second(), 2), app.width - 30, 65);
    app.textAlign(app.LEFT, app.BASELINE); 

    tfToggle.draw(app); emaPeriodToggle.draw(app);
    app.stroke(60); app.line(30, 115, app.width - 30, 115); app.line(30, 155, app.width - 30, 155);

    // Шапка информационной таблицы (Пересчитаны отступы под новые колонки)
    app.textSize(13); app.fill(0, 160, 255); 
    app.text("Таймфрейм", 40, 132); app.text("Stochastic", 155, 132); app.text("MFI v2 Дивер", 255, 132); app.text("до EMA " + emaPeriod, 375, 132); app.text("Стратегия", 475, 132);
    app.fill(130, 145, 165); app.textSize(11); 
    app.text("(Интервал)", 40, 148); app.text("Lines %K / %D", 155, 148); app.text("Осциллятор / Пики", 255, 148); app.text("Отклонение цены", 375, 148); app.text("Mean Reversion", 475, 148);

    if (!isAllDataLoaded()) {
      app.fill(255, 204, 0); app.textSize(15); app.text("Загрузка индикаторов... Считаем Стохастик, MFI и EMA...", 45, 200);
    } else if (timeframeMode == 0) {
      renderRow("30 Минут (30m)", tf30m, tf30mEma, tf30mMfi, 190); 
      renderRow("15 Минут (15m)", tf15m, tf15mEma, tf15mMfi, 240); 
      renderRow("5 Минут (5m)", tf5m, tf5mEma, tf5mMfi, 290);
    } else {
      renderRow("4 Часа (4h)", tf4h, tf4hEma, tf4hMfi, 190); 
      renderRow("1 Час (1h)", tf1h, tf1hEma, tf1hMfi, 240); 
      renderRow("30 Минут (30m)", tf30m, tf30mEma, tf30mMfi, 290);
    }

    if (cpBtn.text.equals("Скопировано!") && app.millis() - copyTimestamp > 2500) cpBtn.text = "Копировать ответ";
    if (ai.isThinking) aiScrollY = 0;
    aiBtn.text = ai.isThinking ? "Анализ..." : "Робот-Аналитик";

    aiBtn.draw(app); cpBtn.draw(app); refreshBtn.draw(app);
    if (aiAnalysisTime.length() > 0) { app.fill(100, 150, 165); app.textSize(11); app.text(aiAnalysisTime, 30, 362); }

    // Контейнер с маской прокрутки для вывода ИИ
    app.clip(30, 380, app.width - 60, 330);
    app.fill(225); app.textSize(13); app.text(ai.aiResponse, 30, 380 + aiScrollY, app.width - 60, 2000); 
    app.noClip();
  }

  // Полностью переписанный метод отрисовки строки с поддержкой TradingView MFI v2
  private void renderRow(String title, StochasticResult stoch, EmaResult ema, MfiResult mfi, float y) {
    app.fill(255); app.textSize(13); app.text(title, 40, y);
    if (stoch.isError || ema.isError || mfi == null || mfi.isError) { 
      app.fill(255, 70, 70); app.text("Ошибка расчетов", 155, y); return; 
    }

    // 1. Колонка Стохастика
    app.fill(235); 
    String vals = app.nf(stoch.k, 1, 1) + "/" + app.nf(stoch.d, 1, 1); 
    app.text(vals, 155, y);
    
    app.textSize(11);
    if (stoch.k > stoch.d + 0.5f) { app.fill(0, 255, 150); app.text("▲", 160 + app.textWidth(vals), y); }
    else if (stoch.k < stoch.d - 0.5f) { app.fill(255, 50, 50); app.text("▼", 160 + app.textWidth(vals), y); }
    
    // 2. Колонка MFI + Детекция Дивергенций
    app.textSize(13); app.fill(180, 215, 255);
    String mfiStr = "MFI:" + app.nf(mfi.value, 1, 0);
    app.text(mfiStr, 255, y);
    
    if (mfi.divergenceType.equals("BULLISH")) {
      app.fill(0, 255, 210); app.textSize(11); app.text("[Δ Бычья]", 258 + app.textWidth(mfiStr), y);
    } else if (mfi.divergenceType.equals("BEARISH")) {
      app.fill(255, 110, 255); app.textSize(11); app.text("[Δ Медв]", 258 + app.textWidth(mfiStr), y);
    }

    // 3. Колонка отклонения цены до EMA
    app.textSize(13); String px = ema.distancePercent >= 0 ? "+" : "";
    app.fill(ema.distancePercent >= 0 ? app.color(255, 110, 110) : app.color(110, 255, 110));
    app.text(px + app.nf(ema.distancePercent, 1, 2) + "%", 375, y);

    // 4. Логика торговой стратегии (Mean Reversion, усиленная фрактальными объемами)
    if (mfi.divergenceType.equals("BULLISH") && ema.distancePercent < -0.8f) {
    app.fill(0, 255, 150); app.text("★ СИЛЬНЫЙ BUY", 475, y); // Крупный игрок копит объемы на сливе цены
    } else if (mfi.divergenceType.equals("BEARISH") && ema.distancePercent > 0.8f) {
    app.fill(255, 50, 50); app.text("★ СИЛЬНЫЙ SELL", 475, y); // Объемы уходят, цену тащат на убой
  } else if (stoch.k <= 20 && ema.distancePercent < -1.5f) {
    app.fill(0, 200, 120); app.text("BUY (Скальп)", 475, y);
  } else if (stoch.k >= 80 && ema.distancePercent > 1.5f) {
    app.fill(200, 50, 50); app.text("SELL (Скальп)", 475, y);
  } else {app.fill(120); app.text("Поиск паттерна", 475, y);
}

app.stroke(40); app.line(30, y + 15, app.width - 30, y + 15);
}

public String getClipboardText() {
    try {
      Transferable c = Toolkit.getDefaultToolkit().getSystemClipboard().getContents(null);
      if (c != null && c.isDataFlavorSupported(DataFlavor.stringFlavor)) return (String) c.getTransferData(DataFlavor.stringFlavor);
    } catch (Exception e) { e.printStackTrace(); }
    return "";
  }
}