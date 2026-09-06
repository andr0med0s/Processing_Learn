// === ВКЛАДКА: UIController ===

import java.awt.Toolkit;
import java.awt.datatransfer.StringSelection;

class UIController {
  private PApplet app;
  private TInvestClient broker;
  private TerminalView ui;
  private LocalAIClient ai;

  public UIController(PApplet app, TInvestClient broker, TerminalView ui, LocalAIClient ai) {
    this.app = app;
    this.broker = broker;
    this.ui = ui;
    this.ai = ai;
  }

  public void handleMousePress(float mx, float my) {
    // 1. ЛОГИКА ЭКРАНА ИЗБРАННОГО
    if (ui.currentScreen == TerminalView.SCREEN_FAVORITES) {
      if (ui.tfToggle.isHovered(mx, my)) { // Использование общего метода для перехода к поиску
        ui.currentScreen = TerminalView.SCREEN_SEARCH;
        ui.setInputText("");
        return;
      }

      for (InstrumentItem item : ui.favManager.list) {
        if (item.isHovered(mx, my)) {
          if (mx > item.x + item.w - 90 && mx < item.x + item.w - 10) {
            ui.favManager.remove(item.uid);
          } else {
            ui.selectedAsset = item;
            ui.currentScreen = TerminalView.SCREEN_ANALYTICS;
            ai.aiResponse = "Нажмите кнопку ниже, чтобы запустить анализ ИИ...";
            app.thread("runAnalyticCalculation");
          }
          break;
        }
      }
    }

    // 2. ЛОГИКА ЭКРАНА ПОИСКА
    else if (ui.currentScreen == TerminalView.SCREEN_SEARCH) {
      for (InstrumentItem item : broker.foundInstruments) {
        if (item.isHovered(mx, my)) {
          ui.selectedAsset = item;
          ui.currentScreen = TerminalView.SCREEN_ANALYTICS;
          ai.aiResponse = "Нажмите кнопку ниже, чтобы запустить анализ ИИ...";
          app.thread("runAnalyticCalculation");
          break;
        }
      }
    }
    
    // 3. ЛОГИКА ЭКРАНА АНАЛИТИКИ
    else if (ui.currentScreen == TerminalView.SCREEN_ANALYTICS) {
      // Клик по кнопке "Избранное"
      if (ui.favBtn.isHovered(mx, my)) {
        if (ui.favManager.contains(ui.selectedAsset.uid)) ui.favManager.remove(ui.selectedAsset.uid);
        else ui.favManager.add(ui.selectedAsset);
        return;
      }
      
      // Клик по тоглу Таймфреймов
      if (ui.isAllDataLoaded() && ui.tfToggle.isHovered(mx, my)) {
        ui.tfToggle.toggleState();
        ui.timeframeMode = ui.tfToggle.currentState;
        ai.aiResponse = "Нажмите кнопку ниже, чтобы запустить анализ ИИ...";
        ui.cpBtn.text = "Копировать ответ"; 
        return;
      }

      // Клик по тоглу периода EMA (просто меняет состояние визуализации в рамках Демонстрации)
      if (ui.isAllDataLoaded() && ui.emaPeriodToggle.isHovered(mx, my)) {
        ui.emaPeriodToggle.toggleState();
        return;
      }

      if (!ui.isAllDataLoaded()) return;

      // Клик по кнопке "Робот-Аналитик"
      if (ui.aiBtn.isHovered(mx, my)) {
        if (!ai.isThinking) {
          ui.cpBtn.text = "Копировать ответ";
          ui.aiAnalysisTime = "Расчет ИИ от: " + app.nf(app.day(), 2) + "." + app.nf(app.month(), 2) + "." + app.year() + " в " + app.nf(app.hour(), 2) + ":" + app.nf(app.minute(), 2) + ":" + app.nf(app.second(), 2);
          
          String modeLabel = ui.timeframeMode == 0 ? "скальпинг 30м / 15м / 5м" : "среднесрок 4ч / 1ч / 30м";
          if (ui.timeframeMode == 0) {
            ai.analyzeDataAsync(app, ui.selectedAsset.name, ui.selectedAsset.ticker, modeLabel, "30 Минут (30m)", ui.tf30m, ui.tf30mEma, "15 Минут (15m)", ui.tf15m, ui.tf15mEma, "5 Минут (5m)", ui.tf5m, ui.tf5mEma);
          } else {
            ai.analyzeDataAsync(app, ui.selectedAsset.name, ui.selectedAsset.ticker, modeLabel, "4 Часа (4h)", ui.tf4h, ui.tf4hEma, "1 Час (1h)", ui.tf1h, ui.tf1hEma, "30 Минут (30m)", ui.tf30m, ui.tf30mEma);
          }
        }
      }
      
      // Клик по кнопке "Копировать ответ"
      else if (ui.cpBtn.isHovered(mx, my)) {
        try {
          StringSelection selection = new StringSelection(ai.aiResponse);
          Toolkit.getDefaultToolkit().getSystemClipboard().setContents(selection, selection);
          ui.cpBtn.text = "Скопировано!";
          ui.copyTimestamp = app.millis();
        } catch (Exception e) { System.out.println("Ошибка буфера: " + e.getMessage()); }
      }

      // Клик по кнопке "Обновить данные"
      if (ui.refreshBtn.isHovered(mx, my)) {
        ui.tf4h = null; ui.tf1h = null; ui.tf30m = null; ui.tf15m = null; ui.tf5m = null;
        app.thread("runAnalyticCalculation");
      }
    }
  }
  
  public void handleKeyPress(char keyChar, int keyCode) {
    if (ui.currentScreen == TerminalView.SCREEN_ANALYTICS) {
      if (keyChar == app.BACKSPACE || keyCode == app.ESC) {
        ui.tf4h = null; ui.tf1h = null; ui.tf30m = null; ui.tf15m = null; ui.tf5m = null;
        ui.tf4hEma = null; ui.tf1hEma = null; ui.tf30mEma = null; ui.tf15mEma = null; ui.tf5mEma = null;
        ui.cpBtn.text = "Копировать ответ";
        
        ui.currentScreen = TerminalView.SCREEN_FAVORITES;
        ui.timeframeMode = 0;
        ui.tfToggle.currentState = 0;
        app.key = 0; 
      }
      return;
    }

    if (ui.currentScreen == TerminalView.SCREEN_FAVORITES) {
      if (keyChar == 's' || keyChar == 'S') {
        ui.currentScreen = TerminalView.SCREEN_SEARCH;
        ui.setInputText(""); app.key = 0;
      }
      return;
    }

    if (ui.currentScreen == TerminalView.SCREEN_SEARCH) {
      if (keyChar == app.BACKSPACE && ui.getInputText().length() == 0 || keyCode == app.ESC) {
        ui.currentScreen = TerminalView.SCREEN_FAVORITES;
        app.key = 0;
        return;
      }
      
      if (broker.isSearching) return;

      if (app.keyEvent != null && (keyChar == 22 || (app.keyEvent.isControlDown() || app.keyEvent.isMetaDown()) && (keyChar == 'v' || keyChar == 'V'))) {
        String pastedText = ui.getClipboardText();
        if (pastedText.length() > 0) {
          pastedText = pastedText.trim().toUpperCase().replaceAll("[^A-Z0-9-]", "");
          if (pastedText.length() > 12) pastedText = pastedText.substring(0, 12);
          ui.setInputText(ui.getInputText() + pastedText);
        }
        return;
      }

      if (keyChar == app.BACKSPACE) {
        String buffer = ui.getInputText();
        if (buffer.length() > 0) ui.setInputText(buffer.substring(0, buffer.length() - 1));
      } else if (keyChar == app.ENTER || keyChar == app.RETURN) {
        if (ui.getInputText().trim().length() > 0) app.thread("runNetworkSearch");
      } else if (keyChar != app.CODED && keyChar != app.ESC) {
        if (ui.getInputText().length() < 12) ui.setInputText(ui.getInputText() + Character.toUpperCase(keyChar));
      }
    }
  }
}