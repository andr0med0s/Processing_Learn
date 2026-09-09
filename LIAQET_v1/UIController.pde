//*********************************
// 8 === ВКЛАДКА: UIController ===

import java.awt.Toolkit;
import java.awt.datatransfer.StringSelection;

class UIController {
  private PApplet app; 
  private TInvestClient broker; 
  private TerminalView ui; 
  private LocalAIClient ai;
  
  public UIController(PApplet app, TInvestClient broker, TerminalView ui, LocalAIClient ai) {
    this.app = app; this.broker = broker; this.ui = ui; this.ai = ai;
  }

  // Обработка кликов мыши на всех экранах терминала
  public void handleMousePress(float mx, float my) {
    // 1. ЛОГИКА ЭКРАНА ИЗБРАННОГО
    if (ui.currentScreen == TerminalView.SCREEN_FAVORITES) {
      if (ui.searchRedirectBtn.isHovered(mx, my)) { 
        ui.currentScreen = TerminalView.SCREEN_SEARCH; 
        ui.setInputText(""); 
        return; 
      }
      for (InstrumentItem item : ui.favManager.list) {
        if (item.isHovered(mx, my)) {
          if (mx > item.x + item.w - 90 && mx < item.x + item.w - 10) {
            ui.favManager.remove(item.uid);
          } else { 
            openAnalyticsForAsset(item); 
          }
          break;
        }
      }
    } 
    // 2. ЛОГИКА ЭКРАНА ПОИСКА
    else if (ui.currentScreen == TerminalView.SCREEN_SEARCH) {
      for (InstrumentItem item : broker.foundInstruments) {
        if (item.isHovered(mx, my)) { 
          openAnalyticsForAsset(item); 
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
      } 
      // Клик по тоглу Таймфреймов
      else if (ui.isAllDataLoaded() && ui.tfToggle.isHovered(mx, my)) {
        ui.tfToggle.toggleState(); 
        ui.timeframeMode = ui.tfToggle.currentState;
        resetAIStatus();
      } 
      // Клик по тоглу периода EMA
      else if (ui.isAllDataLoaded() && ui.emaPeriodToggle.isHovered(mx, my)) {
        ui.emaPeriodToggle.toggleState();
        ui.emaPeriod = (ui.emaPeriodToggle.currentState == 0) ? 200 : 50;
        clearAllCache(); // Полная очистка кэша при смене периода
        resetAIStatus();
        app.thread("runAnalyticCalculation");
      } 
      // Клик по кнопке "Робот-Аналитик" с пробросом MFI Divergence v2
      else if (ui.isAllDataLoaded() && ui.aiBtn.isHovered(mx, my) && !ai.isThinking) {
        ui.cpBtn.text = "Копировать ответ";
        ui.aiAnalysisTime = "Расчет ИИ от: " + app.nf(app.day(), 2) + "." + app.nf(app.month(), 2) + "." + app.year() + " в " + app.nf(app.hour(), 2) + ":" + app.nf(app.minute(), 2) + ":" + app.nf(app.second(), 2);
        String grp = ui.timeframeMode == 0 ? "скальпинг 30м / 15м / 5м" : "среднесрок 4ч / 1ч / 30м";
        
        if (ui.timeframeMode == 0) {
          ai.analyzeDataAsync(app, ui.selectedAsset.name, ui.selectedAsset.ticker, grp, ui.emaPeriod, 
                              "30 Минут (30m)", ui.tf30m, ui.tf30mEma, ui.tf30mMfi, 
                              "15 Минут (15m)", ui.tf15m, ui.tf15mEma, ui.tf15mMfi, 
                              "5 Минут (5m)", ui.tf5m, ui.tf5mEma, ui.tf5mMfi);
        } else {
          ai.analyzeDataAsync(app, ui.selectedAsset.name, ui.selectedAsset.ticker, grp, ui.emaPeriod, 
                              "4 Часа (4h)", ui.tf4h, ui.tf4hEma, ui.tf4hMfi, 
                              "1 Час (1h)", ui.tf1h, ui.tf1hEma, ui.tf1hMfi, 
                              "30 Минут (30m)", ui.tf30m, ui.tf30mEma, ui.tf30mMfi);
        }
      } 
      // Клик по кнопке "Копировать ответ"
      else if (ui.cpBtn.isHovered(mx, my)) {
        try {
          Toolkit.getDefaultToolkit().getSystemClipboard().setContents(new StringSelection(ai.aiResponse), null);
          ui.cpBtn.text = "Скопировано!"; 
          ui.copyTimestamp = app.millis();
        } catch (Exception e) { e.printStackTrace(); }
      } 
      // Клик по кнопке "Обновить данные"
      else if (ui.refreshBtn.isHovered(mx, my)) { 
        app.thread("runAnalyticCalculation"); 
      }
    }
  }

  // Вспомогательные методы оптимизации интерфейса
  private void openAnalyticsForAsset(InstrumentItem item) {
    ui.selectedAsset = item; 
    ui.currentScreen = TerminalView.SCREEN_ANALYTICS;
    resetAIStatus(); 
    app.thread("runAnalyticCalculation");
  }
  
  private void resetAIStatus() { 
    ai.aiResponse = "Нажмите кнопку ниже, чтобы запустить анализ ИИ..."; 
    ui.cpBtn.text = "Копировать ответ"; 
  }
  
  // Железобетонная очистка оперативной памяти от старых индикаторов
  private void clearAllCache() { 
    ui.tf5m = null;    ui.tf15m = null;    ui.tf30m = null;    ui.tf1h = null;    ui.tf4h = null; 
    ui.tf5mEma = null; ui.tf15mEma = null; ui.tf30mEma = null; ui.tf1hEma = null; ui.tf4hEma = null; 
    ui.tf5mMfi = null; ui.tf15mMfi = null; ui.tf30mMfi = null; ui.tf1hMfi = null; ui.tf4hMfi = null; 
  }

  // Обработка ввода с клавиатуры
  public void handleKeyPress(char keyChar, int keyCode) {
    if (ui.currentScreen == TerminalView.SCREEN_ANALYTICS) {
      if (keyChar == app.BACKSPACE || keyCode == app.ESC) {
        clearAllCache(); // Стираем кэш, чтобы разгрузить UI при выходе
        ui.cpBtn.text = "Копировать ответ"; 
        ui.aiScrollY = 0; 
        ui.currentScreen = TerminalView.SCREEN_FAVORITES;
        ui.timeframeMode = 0; 
        ui.tfToggle.currentState = 0; 
        app.key = 0;
      }
    } else if (ui.currentScreen == TerminalView.SCREEN_FAVORITES && (keyChar == 's' || keyChar == 'S')) {
      ui.currentScreen = TerminalView.SCREEN_SEARCH; 
      ui.setInputText(""); 
      app.key = 0;
    } else if (ui.currentScreen == TerminalView.SCREEN_SEARCH) {
      if ((keyChar == app.BACKSPACE && ui.getInputText().length() == 0) || keyCode == app.ESC) {
        ui.currentScreen = TerminalView.SCREEN_FAVORITES; 
        app.key = 0;
      } else if (!broker.isSearching) {
        // Поддержка CTRL+V / Paste в буфер
        if (app.keyEvent != null && (keyChar == 22 || ((app.keyEvent.isControlDown() || app.keyEvent.isMetaDown()) && (keyChar == 'v' || keyChar == 'V')))) {
          String pasted = ui.getClipboardText().trim().toUpperCase().replaceAll("[^A-Z0-9-]", "");
          if (pasted.length() > 12) pasted = pasted.substring(0, 12);
          ui.setInputText(ui.getInputText() + pasted);
        } else if (keyChar == app.BACKSPACE) {
          String buffer = ui.getInputText(); 
          if (buffer.length() > 0) ui.setInputText(buffer.substring(0, buffer.length() - 1));
        } else if (keyChar == app.ENTER || keyChar == app.RETURN) {
          if (ui.getInputText().trim().length() > 0) app.thread("runNetworkSearch");
        } else if (keyChar != app.CODED && keyChar != app.ESC && ui.getInputText().length() < 12) {
          ui.setInputText(ui.getInputText() + Character.toUpperCase(keyChar));
        }
      }
    }
  }

  // Вертикальный скроллинг обзора ИИ
  public void handleMouseWheel(float count) {
    if (ui.currentScreen == TerminalView.SCREEN_ANALYTICS && app.mouseX >= 30 && app.mouseX <= app.width - 30 && app.mouseY >= 380 && app.mouseY <= 710) {
      ui.aiScrollY -= count * 15;
      if (ui.aiScrollY > 0) ui.aiScrollY = 0;
      if (ui.aiScrollY < -1500) ui.aiScrollY = -1500;
    }
  }
}
