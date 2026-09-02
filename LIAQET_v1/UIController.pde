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
      // Клик по кнопке "Перейти к поиску"
      float btnX = 25, btnY = 85, btnW = app.width - 50, btnH = 40;
      if (mx > btnX && mx < btnX + btnW && my > btnY && my < btnY + btnH) {
        ui.currentScreen = TerminalView.SCREEN_SEARCH;
        ui.setInputText("");
        return;
      }

        // Клик по элементам списка избранного
      for (InstrumentItem item : ui.favManager.list) {
        if (item.isHovered(mx, my)) {
          // Проверяем, не нажал ли пользователь на зону кнопки [Удалить]
          if (mx > item.x + item.w - 90 && mx < item.x + item.w - 10) {
            ui.favManager.remove(item.uid);
          } else {
            // Выбираем и уходим на анализ
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
      // Обработка кнопки добавления/удаления из избранного в шапке
      float favBtnX = app.width - 150, favBtnY = 23, favBtnW = 120, favBtnH = 24;
      if (mx > favBtnX && mx < favBtnX + favBtnW && my > favBtnY && my < favBtnY + favBtnH) {
        if (ui.favManager.contains(ui.selectedAsset.uid)) ui.favManager.remove(ui.selectedAsset.uid);
        else ui.favManager.add(ui.selectedAsset);
        return;
      }
      
      if (ui.isAllDataLoaded() && mx >= ui.tfToggleX && mx <= ui.tfToggleX + ui.tfToggleW && my >= ui.tfToggleY && my <= ui.tfToggleY + ui.tfToggleH) {
      ui.timeframeMode = ui.timeframeMode == 0 ? 1 : 0;
      ai.aiResponse = "Нажмите кнопку ниже, чтобы запустить анализ ИИ...";
      ui.cpBtnText = "Копировать ответ"; return;
      }

      if (!ui.isAllDataLoaded()) return;

      if (mx >= ui.aiBtnX && mx <= ui.aiBtnX + ui.aiBtnW && my >= ui.aiBtnY && my <= ui.aiBtnY + ui.aiBtnH) {
        if (!ai.isThinking) {
          ui.cpBtnText = "Копировать ответ";
          ui.aiAnalysisTime = "Расчет ИИ от: " + app.nf(app.day(), 2) + "." + app.nf(app.month(), 2) + "." + app.year() + " в " + app.nf(app.hour(), 2) + ":" + app.nf(app.minute(), 2) + ":" + app.nf(app.second(), 2);
          if (ui.timeframeMode == 0) {
            ai.analyzeDataAsync(app, ui.selectedAsset.name, ui.selectedAsset.ticker, "скальпинг 30м / 15м / 5м", "30 Минут (30m)", ui.tf30m, ui.tf30mEma, "15 Минут (15m)", ui.tf15m, ui.tf15mEma, "5 Минут (5m)", ui.tf5m, ui.tf5mEma);
          } else {
            ai.analyzeDataAsync(app, ui.selectedAsset.name, ui.selectedAsset.ticker, "среднесрок 4ч / 1ч / 30м", "4 Часа (4h)", ui.tf4h, ui.tf4hEma, "1 Час (1h)", ui.tf1h, ui.tf1hEma, "30 Минут (30m)", ui.tf30m, ui.tf30mEma);
          }
        }
      }
      else if (mx >= ui.cpBtnX && mx <= ui.cpBtnX + ui.cpBtnW && my >= ui.cpBtnY && my <= ui.cpBtnY + ui.cpBtnH) {
        try {
          StringSelection selection = new StringSelection(ai.aiResponse);
          Toolkit.getDefaultToolkit().getSystemClipboard().setContents(selection, selection);
          ui.cpBtnText = "Скопировано!";
          ui.copyTimestamp = app.millis();
        } catch (Exception e) { System.out.println("Ошибка буфера: " + e.getMessage()); }
      }

      if (mx >= ui.refreshBtnX && mx <= ui.refreshBtnX + ui.refreshBtnW && my >= ui.refreshBtnY && my <= ui.refreshBtnY + ui.refreshBtnH) {
        ui.tf4h = null; ui.tf1h = null; ui.tf30m = null; ui.tf15m = null; ui.tf5m = null;
        app.thread("runAnalyticCalculation");
      }
    }
  }
  
  public void handleKeyPress(char keyChar, int keyCode) {
        // Находясь на экране Аналитики, шаг назад возвращает на предыдущий экран
    if (ui.currentScreen == TerminalView.SCREEN_ANALYTICS) {
      if (keyChar == BACKSPACE || keyCode == ESC) {
        // Очищаем индикаторы
        ui.tf4h = null; ui.tf1h = null; ui.tf30m = null; ui.tf15m = null; ui.tf5m = null;
        ui.tf4hEma = null; ui.tf1hEma = null; ui.tf30mEma = null; ui.tf15mEma = null; ui.tf5mEma = null;
        ui.cpBtnText = "Копировать ответ";
        
        // Возвращаемся в Избранное (или можно сделать проверку, откуда пришли, но Избранное — безопасный хаб)
        ui.currentScreen = TerminalView.SCREEN_FAVORITES;
        ui.timeframeMode = 0;
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

        // Находясь на экране Поиска, шаг назад возвращает в список Избранного
    if (ui.currentScreen == TerminalView.SCREEN_SEARCH) {
      if (keyChar == BACKSPACE && ui.getInputText().length() == 0 || keyCode == ESC) {
        ui.currentScreen = TerminalView.SCREEN_FAVORITES;
        app.key = 0;
        return;
      }
      
      if (broker.isSearching) return;

      // Вставка Ctrl+V / Cmd+V
      if (app.keyEvent != null && (keyChar == 22 || (app.keyEvent.isControlDown() || app.keyEvent.isMetaDown()) && (keyChar == 'v' || keyChar == 'V'))) {
        String pastedText = ui.getClipboardText();
        if (pastedText.length() > 0) {
          pastedText = pastedText.trim().toUpperCase().replaceAll("[^A-Z0-9-]", "");
          if (pastedText.length() > 12) pastedText = pastedText.substring(0, 12);
          ui.setInputText(ui.getInputText() + pastedText);
        }
        return;
      }

      if (keyChar == BACKSPACE) {
        String buffer = ui.getInputText();
        if (buffer.length() > 0) ui.setInputText(buffer.substring(0, buffer.length() - 1));
      } else if (keyChar == ENTER || keyChar == RETURN) {
        if (ui.getInputText().trim().length() > 0) app.thread("runNetworkSearch");
      } else if (keyChar != CODED && keyChar != ESC) {
        if (ui.getInputText().length() < 12) ui.setInputText(ui.getInputText() + Character.toUpperCase(keyChar));
      }
    }
  }
}
