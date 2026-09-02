// === ВКЛАДКА: TerminalView ===
import java.awt.Toolkit;
import java.awt.datatransfer.DataFlavor;
import java.awt.datatransfer.Transferable;

class TerminalView {
  private PApplet app;
  private TInvestClient broker;
  private LocalAIClient ai;

  // КОНСТАНТЫ  ЭКРАНОВ
  public static final int SCREEN_FAVORITES = 0; //  стартовое окно!
  public static final int SCREEN_SEARCH = 1;
  public static final int SCREEN_ANALYTICS = 2;

  private String inputBuffer = "";
  public int currentScreen = SCREEN_FAVORITES; // По умолчанию открываем Избранное

  public InstrumentItem selectedAsset = null;
  public FavoritesManager favManager; //  JSON менеджер

  
  // Данные Стохастика
  public StochasticResult tf4h, tf1h, tf30m, tf15m, tf5m;
  // Данные EMA
  public EmaResult tf4hEma, tf1hEma, tf30mEma, tf15mEma, tf5mEma;

  // 0 = 30m/15m/5m, 1 = 4h/1h/30m
  public int timeframeMode = 0;

  // Управление статусом копирования
  public String cpBtnText = "Копировать ответ";
  public int copyTimestamp = 0; // Время, когда кнопка была нажата

  public String aiAnalysisTime = ""; // Штамп времени для анализа ИИ


  public final float tfToggleX = 30, tfToggleY = 78, tfToggleW = 540, tfToggleH = 28;
  public final float aiBtnX = 30, aiBtnY = 320, aiBtnW = 160, aiBtnH = 32;
  public final float cpBtnX = 210, cpBtnY = 320, cpBtnW = 160, cpBtnH = 32;
  public final float refreshBtnX = 400, refreshBtnY = 320, refreshBtnW = 160, refreshBtnH = 32;

  public TerminalView(PApplet app, TInvestClient broker, LocalAIClient ai) {
    this.app = app;
    this.broker = broker;
    this.ai = ai;
    this.favManager = new FavoritesManager(app); // Инициализируем менеджер
  }

  public String getInputText() { return inputBuffer; }
  public void setInputText(String txt) { this.inputBuffer = txt; }

  // Теперь проверяем загрузку всех индикаторов для Mean Reversion стратегии
  public boolean isAllDataLoaded() {
    return tf5m != null && tf15m != null && tf30m != null && tf1h != null && tf4h != null &&
           tf5mEma != null && tf15mEma != null && tf30mEma != null && tf1hEma != null && tf4hEma != null;
  }

  public String getToggleLabel() {
    return timeframeMode == 0 ? "→ 4ч / 1ч / 30м" : "→ 30м / 15м / 5м";
  }

  public void drawScreen() {
    switch (currentScreen) {
      case SCREEN_FAVORITES:
        drawFavoritesLayout();
        break;
      case SCREEN_SEARCH:
        drawSearchLayout();
        break;
      case SCREEN_ANALYTICS:
        drawTableLayout();
        break;
    }
  }

  private void drawFavoritesLayout() {
    app.fill(255); app.textSize(18);
    app.text("Избранные инструменты", 25, 40);
    app.textSize(13); app.fill(140);
    app.text("Нажмите клавишу 'S' для быстрого открытия окна поиска", 25, 65);

    // Кнопка перехода к поиску
    float btnX = 25, btnY = 85, btnW = app.width - 50, btnH = 40;
    boolean hoverSearch = (app.mouseX > btnX && app.mouseX < btnX + btnW && app.mouseY > btnY && app.mouseY < btnY + btnH);
    app.fill(hoverSearch ? 45 : 33);
    app.stroke(hoverSearch ? app.color(0, 150, 255) : 80);
    app.rect(btnX, btnY, btnW, btnH, 6);
    app.fill(200); app.textSize(14); app.textAlign(CENTER, CENTER);
    app.text("+ Найти новый инструмент по тикеру", btnX + btnW/2, btnY + btnH/2);
    app.textAlign(LEFT, BASELINE);

    // Отрисовка списка избранного
    if (favManager.list.isEmpty()) {
      app.fill(130); app.textSize(14);
      app.text("Список избранного пуст. Добавьте тикеры через поиск.", 25, 170);
    } else {
      int startY = 150;
      for (int i = 0; i < favManager.list.size(); i++) {
        InstrumentItem item = favManager.list.get(i);
        item.updatePosition(25, startY + (i * 75), app.width - 50, 65);
        item.drawItem(app);
        
        // Рисуем маленькую иконку удаления (крестик) в углу карточки инструмента
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

    // Добавляем кнопку «В избранное» на экран Аналитики
    // Динамическая кнопка Избранного (Звезда)
    float favBtnX = app.width - 150, favBtnY = 23, favBtnW = 120, favBtnH = 24;
    boolean isFav = favManager.contains(selectedAsset.uid);
    boolean hoverFav = (app.mouseX > favBtnX && app.mouseX < favBtnX + favBtnW && app.mouseY > favBtnY && app.mouseY < favBtnY + favBtnH);

    app.fill(hoverFav ? (isFav ? app.color(150,50,50) : app.color(50,150,50)) : (isFav ? app.color(100,33,33) : app.color(33,100,33)));
    app.stroke(isFav ? app.color(255,100,100) : app.color(100,255,100));
    app.rect(favBtnX, favBtnY, favBtnW, favBtnH, 4);
    app.fill(255); app.textSize(11); app.textAlign(CENTER, CENTER);
    app.text(isFav ? " [+] В избранном" : "[-] Добавить", favBtnX + favBtnW/2, favBtnY + favBtnH/2);
    app.textAlign(LEFT, BASELINE);


    //  Таймштамп отрисовки интерфейса
    app.fill(0, 140, 200); app.textSize(12); app.textAlign(RIGHT, BASELINE); 
    // Форматируем дату и время с ведущими нулями (чтобы вместо 9:5 было 09:05)
    String timestamp = app.nf(day(), 2) + "." + app.nf(month(), 2) + "." + year() + " | " 
                     + app.nf(hour(), 2) + ":" + app.nf(minute(), 2) + ":" + app.nf(second(), 2);
    app.text(timestamp, app.width - 30, 65);
    app.textAlign(LEFT, BASELINE); 

    drawTimeframeToggle();

    app.stroke(60);
    app.line(30, 115, app.width - 30, 115);
    app.line(30, 155, app.width - 30, 155);

    // === ОПТИМИЗИРОВАННАЯ ДВУХСТРОЧНАЯ ШАПКА ТАБЛИЦЫ ===
    app.textSize(13); app.fill(0, 160, 255); 
    app.text("Таймфрейм", 45, 132);
    app.text("Stochastic", 170, 132);
    app.text("Дистанция", 310, 132);
    app.text("Стратегия", 460, 132);

    // Вторая строка (Спецификации и подписи) 
    app.fill(130, 145, 165); app.textSize(11); 
    app.text("(Интервал)", 45, 148);
    app.text("Lines %K / %D", 170, 148);
    app.text("до EMA 200", 310, 148);
    app.text("Mean Reversion", 460, 148);

    app.textSize(14); // Возвращаем исходный размер для строк с данными

    if (!isAllDataLoaded()) {
      app.fill(255, 204, 0); app.textSize(15);
      app.text("Загрузка индикаторов... Считаем Стохастик и EMA 200...", 45, 200);
    } else if (timeframeMode == 0) {
      renderRow("30 Минут (30m)", tf30m, tf30mEma, 190);
      renderRow("15 Минут (15m)", tf15m, tf15mEma, 240);
      renderRow("5 Минут (5m)", tf5m, tf5mEma, 290);
    } else {
      renderRow("4 Часа (4h)", tf4h, tf4hEma, 190);
      renderRow("1 Час (1h)", tf1h, tf1hEma, 240);
      renderRow("30 Минут (30m)", tf30m, tf30mEma, 290);
    }

    // Кнопка ИИ
    boolean isAiHovered = app.mouseX >= aiBtnX && app.mouseX <= aiBtnX + aiBtnW && app.mouseY >= aiBtnY && app.mouseY <= aiBtnY + aiBtnH;
    app.fill(isAiHovered ? app.color(0, 160, 90) : app.color(0, 110, 60));
    app.stroke(isAiHovered ? app.color(0, 210, 120) : app.color(0, 140, 80));
    app.rect(aiBtnX, aiBtnY, aiBtnW, aiBtnH, 5);
    app.fill(255); app.textSize(13); app.textAlign(CENTER, CENTER);
    app.text(ai.isThinking ? "Анализ..." : "Робот-Аналитик", aiBtnX + aiBtnW/2, aiBtnY + aiBtnH/2 - 1);

    // Кнопка Копирования  === АВТОСБРОС ТЕКСТА КНОПКИ КОПИРОВАНИЯ ===
    if (cpBtnText.equals("Скопировано!") && app.millis() - copyTimestamp > 2500) {
      cpBtnText = "Копировать ответ";
    }

    // Кнопка Копирования 
    boolean isCpHovered = app.mouseX >= cpBtnX && app.mouseX <= cpBtnX + cpBtnW && app.mouseY >= cpBtnY && app.mouseY <= cpBtnY + cpBtnH;
    app.fill(isCpHovered ? app.color(75, 85, 100) : app.color(50, 60, 75));
    app.stroke(isCpHovered ? app.color(110, 125, 145) : app.color(80, 95, 110));
    app.rect(cpBtnX, cpBtnY, cpBtnW, cpBtnH, 5);
    app.fill(240); app.textSize(12);
    app.text(cpBtnText, cpBtnX + cpBtnW/2, cpBtnY + cpBtnH/2 - 1);
    app.textAlign(LEFT, BASELINE);

    // Кнопка Обновления данных 
    boolean isRefreshHovered =  app.mouseX >= refreshBtnX && app.mouseX <= refreshBtnX + refreshBtnW && 
                                app.mouseY >= refreshBtnY && app.mouseY <= refreshBtnY + refreshBtnH;
    app.fill(isRefreshHovered ? app.color(100, 100, 100) : app.color(70, 70, 70));
    app.rect(refreshBtnX, refreshBtnY, refreshBtnW, refreshBtnH, 5);
    app.fill(255); app.textAlign(CENTER, CENTER);
    app.text("Обновить данные", refreshBtnX + refreshBtnW/2, refreshBtnY + refreshBtnH/2);
    app.textAlign(LEFT, BASELINE);

    // Отрисовка штампа времени ИИ (если запрос уже делался)
    if (aiAnalysisTime.length() > 0) {
      app.fill(100, 150, 165); app.textSize(11);
      app.text(aiAnalysisTime, 30, 362); // Выводим чуть выше основного текста ИИ
    }

    // Поле ответа ИИ (ваш стандартный код вывода)
    app.fill(225); app.textSize(13);
    app.text(ai.aiResponse, 30, 380, app.width - 60, 330); 
  }

  private void drawTimeframeToggle() {
    boolean hover = app.mouseX >= tfToggleX && app.mouseX <= tfToggleX + tfToggleW && app.mouseY >= tfToggleY && app.mouseY <= tfToggleY + tfToggleH;
    app.fill(hover ? app.color(55, 65, 85) : app.color(40, 48, 62));
    app.stroke(hover ? app.color(0, 150, 255) : app.color(70, 80, 100));
    app.rect(tfToggleX, tfToggleY, tfToggleW, tfToggleH, 5);
    app.fill(200); app.textSize(12); app.textAlign(CENTER, CENTER);
    app.text("Группа: " + (timeframeMode == 0 ? "30м / 15м / 5м" : "4ч / 1ч / 30м") + "   |   " + getToggleLabel(), tfToggleX + tfToggleW / 2, tfToggleY + tfToggleH / 2);
    app.textAlign(LEFT, BASELINE);
  }

  // Обновленная строка вывода с поддержкой комплексной Mean Reversion оценки
  private void renderRow(String title, StochasticResult stoch, EmaResult ema, float y) {
    app.fill(255); app.textSize(14); app.text(title, 45, y);
    
    if (stoch.isError || ema.isError) {
      app.fill(255, 70, 70);
      app.text("Ошибка расчета индикаторов", 170, y);
      return;
    }

    //1 Вывод Стохастика
    app.fill(240);
    String stochValues = app.nf(stoch.k, 1, 1) + " / " + app.nf(stoch.d, 1, 1);
    app.text(stochValues, 170, y);

    // 2. Отрисовка стрелочки импульса Стохастика на основе пересечения линий K и D
    float textW = app.textWidth(stochValues); 
    float arrowX = 170 + textW + 8; 
    app.textSize(12); 
    if (stoch.k > stoch.d + 0.5f) {
      app.fill(0, 255, 150); // Зеленый цвет для бычьего импульса
      app.text("▲", arrowX, y);
    } else if (stoch.k < stoch.d - 0.5f) {
      app.fill(255, 50, 50); // Красный цвет для медвежьего импульса
      app.text("▼", arrowX, y);
    } else {
      app.fill(150); // Серый цвет, если линии сплетены (флэт)
      app.text("◆", arrowX, y); // Квадрат/ромб как символ нейтрального положения
    }
    app.textSize(14); // Возвращаем стандартный размер шрифта для следующих колонок

    //3 Вывод параметров отклонения цены от EMA 200
    String prefix = ema.distancePercent >= 0 ? "+" : "";
    app.fill(ema.distancePercent >= 0 ? app.color(255, 100, 100) : app.color(100, 255, 100));
    app.text(prefix + app.nf(ema.distancePercent, 1, 2) + "% (" + ema.trendDirection + ")", 310, y);

    //4 Логика визуального Mean Reversion сигнала для трейдера
    if (stoch.k <= 20 && ema.distancePercent < -1.5f) {
      app.fill(0, 255, 150);
      app.text("BUY (Возврат вверх)", 460, y);
    } else if (stoch.k >= 80 && ema.distancePercent > 1.5f) {
      app.fill(255, 50, 50);
      app.text("SELL (Возврат вниз)", 460, y);
    } else {
      app.fill(150);
      app.text("Поиск паттерна...", 460, y);
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
    }
    return "";
  }
}
