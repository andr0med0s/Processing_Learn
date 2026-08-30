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
    // Экран поиска (Screen 0)
    if (ui.currentScreen == 0) {
      for (InstrumentItem item : broker.foundInstruments) {
        if (item.isHovered(mx, my)) {
          ui.selectedAsset = item;
          ui.currentScreen = 1;
          ai.aiResponse = "Нажмите кнопку ниже, чтобы запустить анализ ИИ...";
          app.thread("runAnalyticCalculation");
          break;
        }
      }
    }
    // Экран аналитики (Screen 1)
    else if (ui.currentScreen == 1) {
      if (ui.isAllDataLoaded() && mx >= ui.tfToggleX && mx <= ui.tfToggleX + ui.tfToggleW
          && my >= ui.tfToggleY && my <= ui.tfToggleY + ui.tfToggleH) {
        ui.timeframeMode = ui.timeframeMode == 0 ? 1 : 0;
        ai.aiResponse = "Нажмите кнопку ниже, чтобы запустить анализ ИИ...";
        ui.cpBtnText = "Копировать ответ";
        return;
      }

      if (!ui.isAllDataLoaded()) return;

      // Клик по кнопке ИИ
      if (mx >= ui.aiBtnX && mx <= ui.aiBtnX + ui.aiBtnW && my >= ui.aiBtnY && my <= ui.aiBtnY + ui.aiBtnH) {
        if (!ai.isThinking) {
          ui.cpBtnText = "Копировать ответ";
          
          // Фиксируем точное время отправки запроса к ИИ
          ui.aiAnalysisTime = "Расчет ИИ от: " + app.nf(app.day(), 2) + "." + app.nf(app.month(), 2) + "." + app.year() + " в " 
                            + app.nf(app.hour(), 2) + ":" + app.nf(app.minute(), 2) + ":" + app.nf(app.second(), 2);

          // Теперь передаем ИИ пары: Стохастик + EMA для каждого таймфрейма
          if (ui.timeframeMode == 0) {
            ai.analyzeDataAsync(app, ui.selectedAsset.name, ui.selectedAsset.ticker, "скальпинг 30м / 15м / 5м",
              "30 Минут (30m)", ui.tf30m, ui.tf30mEma, 
              "15 Минут (15m)", ui.tf15m, ui.tf15mEma, 
              "5 Минут (5m)", ui.tf5m, ui.tf5mEma);
          } else {
            ai.analyzeDataAsync(app, ui.selectedAsset.name, ui.selectedAsset.ticker, "среднесрок 4ч / 1ч / 30м",
              "4 Часа (4h)", ui.tf4h, ui.tf4hEma, 
              "1 Час (1h)", ui.tf1h, ui.tf1hEma, 
              "30 Минут (30m)", ui.tf30m, ui.tf30mEma);
          }
        }
      }
      // Клик по кнопке "Копировать ответ" (ОБНОВЛЕННЫЙ ВАРИАНТ)
      else if (mx >= ui.cpBtnX && mx <= ui.cpBtnX + ui.cpBtnW && my >= ui.cpBtnY && my <= ui.cpBtnY + ui.cpBtnH) {
        try {
          StringSelection selection = new StringSelection(ai.aiResponse);
          Toolkit.getDefaultToolkit().getSystemClipboard().setContents(selection, selection);
          
          // Фиксируем статус и текущее время в миллисекундах
          ui.cpBtnText = "Скопировано!";
          ui.copyTimestamp = app.millis(); // <--- ВОТ ЭТА СТРОЧКА ДОБАВИЛАСЬ
        }
        catch (Exception e) {
          System.out.println("Ошибка буфера: " + e.getMessage());
        }
      }
    }
    // Клик по кнопке "Обновить данные"
    if (mx >= ui.refreshBtnX && mx <= ui.refreshBtnX + ui.refreshBtnW && 
        my >= ui.refreshBtnY && my <= ui.refreshBtnY + ui.refreshBtnH) {
      // Сбрасываем старые данные, чтобы пользователь видел статус загрузки
      ui.tf4h = null; ui.tf1h = null; ui.tf30m = null; ui.tf15m = null; ui.tf5m = null;
      app.thread("runAnalyticCalculation"); // Запускаем асинхронный пересчет индикаторов
    }

  }

  public void handleKeyPress(char keyChar, int keyCode) {
    if (ui.currentScreen == 1) {
      if (keyChar == BACKSPACE || keyCode == ESC) {
        ui.currentScreen = 0;
        ui.timeframeMode = 0;
        
        // Сброс Стохастика
        ui.tf4h = null; ui.tf1h = null; ui.tf30m = null; ui.tf15m = null; ui.tf5m = null;
        
        // Сброс EMA при возврате к экрану поиска
        ui.tf4hEma = null; ui.tf1hEma = null; ui.tf30mEma = null; ui.tf15mEma = null; ui.tf5mEma = null;
        
        ui.cpBtnText = "Копировать ответ";
        app.key = 0; // Блокируем стандартный ESC
      }
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
