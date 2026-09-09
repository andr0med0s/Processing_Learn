//*********************************
// 4 === ВКЛАДКА: LocalAIClient ===

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

class LocalAIClient {
  private final String aiUrl = "http://localhost:1234/v1/chat/completions";
  public String aiResponse = "Нажмите кнопку ниже, чтобы запустить анализ ИИ...";
  public boolean isThinking = false;

  // Асинхронный метод отправки данных в LM Studio с комплексным анализом Стохастика, EMA и MFI v2 Дивергенций
  public void analyzeDataAsync(PApplet app, String assetName, String ticker, String groupLabel, int emaPeriod,
      String label1, StochasticResult tf1, EmaResult ema1, MfiResult mfi1,
      String label2, StochasticResult tf2, EmaResult ema2, MfiResult mfi2,
      String label3, StochasticResult tf3, EmaResult ema3, MfiResult mfi3) {
    
    this.isThinking = true;
    this.aiResponse = "ИИ изучает показатели таймфреймов и скрытые объемы торгов...";

    // Переводим комплексные структуры данных в развернутый человекочитаемый текст
    String row1 = formatMarketStateToText(app, label1, tf1, ema1, mfi1, emaPeriod);
    String row2 = formatMarketStateToText(app, label2, tf2, ema2, mfi2, emaPeriod);
    String row3 = formatMarketStateToText(app, label3, tf3, ema3, mfi3, emaPeriod);

    // Строгий системный промпт с жестким якорем для полярности сделок Mean Reversion
    String prompt = "Привет! Проанализируй текущую рыночную ситуацию по инструменту " + assetName + " (" + ticker + ").\n"
                    + "Мы используем стратегию Возврата к средней (Mean Reversion), усиленную TradingView-индикатором MFI Divergence v2 (фрактальный анализ объемов и денежных потоков).\n"
                    + "В качестве ключевой линии баланса используется скользящая средняя EMA " + emaPeriod + ".\n\n" 
                    + "ЖЕСТКОЕ ПРАВИЛО ПОЛЯРНОСТИ ТОРГОВЫХ РЕШЕНИЙ (НАРУШАТЬ ЗАПРЕЩЕНО):\n"
                    + "1. Если цена находится ВЫШЕ скользящей средней (отклонение имеет знак +%) и зафиксирована МЕДВЕЖЬЯ дивергенция (BEARISH) — это сигнал на откат вниз к средней. Финальный вывод может быть ТОЛЬКО: «Итог: SELL».\n"
                    + "2. Если цена находится НИЖЕ скользящей средней (отклонение имеет знак -%) и зафиксирована БЫЧЬЯ дивергенция (BULLISH) — это сигнал на откат вверх к средней. Финальный вывод может быть ТОЛЬКО: «Итог: BUY».\n"
                    + "Тщательно сверяй знак отклонения цены от средней перед формированием итога!\n\n"
                    + "Текущее состояние рынка по выбранным таймфреймам:\n"
                    + "1. " + row1 + "\n"
                    + "2. " + row2 + "\n"
                    + "3. " + row3 + "\n\n"
                    + "На основе этих метрик сформируй профессиональный аналитический обзор для трейдера на русском языке:\n"
                    + "- Дай краткую оценку каждому таймфрейму. Если обнаружена фрактальная дивергенция MFI — выдели это как важнейший фактор скрытых действий крупного капитала.\n"
                    + "- Рассчитай критичность натянутой «резинки» отклонения цены от средней линии EMA " + emaPeriod + ".\n"
                    + "- Проверь, подтверждают ли объемы (MFI) разворотные сигналы осциллятора Стохастик.\n"
                    + "- В самом конце обзора напиши итоговую строчку строго в формате: «Итог: [Твое конкретное торговое решение: BUY, SELL, или НАБЛЮДЕНИЕ]».\n\n"
                    + "Пиши исключительно обычным связным профессиональным текстом. Никакого программного кода, markdown-таблиц или JSON структур.";

    new Thread(new Runnable() { public void run() { sendToLMStudio(prompt); } }).start();
  }

  // Транслятор сухих цифр индикаторов в понятные для нейросети рыночные паттерны
  private String formatMarketStateToText(PApplet app, String label, StochasticResult stoch, EmaResult ema, MfiResult mfi, int emaPeriod) {
    if (stoch == null || stoch.isError || ema == null || ema.isError || mfi == null || mfi.isError) {
      return "На таймфрейме " + label + " технические индикаторы временно недоступны.";
    }
    
    String zoneText = "находится в нейтральной зоне баланса";
    if (stoch.k >= 80) zoneText = "критически перекуплен";
    if (stoch.k <= 20) zoneText = "глубоко перепродан";
    
    String momentumText = "линии Стохастика сближены, явного импульса нет";
    if (stoch.k > stoch.d + 0.5) momentumText = "быстрая линия Стохастика пробивает сигнальную снизу вверх (бычий импульс)";
    if (stoch.k < stoch.d - 0.5) momentumText = "быстрая линия Стохастика падает под сигнальную сверху вниз (медвежий импульс)";

    String emaPosition = ema.distancePercent >= 0 ? "выше" : "ниже";
    String trendText = "при этом линия средней имеет направленный тренд " + ema.trendDirection;
    if (ema.trendDirection.equals("флэт")) trendText = "при этом линия средней находится в горизонтальном флэте (идеальное состояние для Mean Reversion)";

    // Формируем блок анализа денежных потоков и фрактальных аномалий
    String divText = "скрытых расхождений по объемам не обнаружено";
    if (mfi.divergenceType.equals("BULLISH")) {
      divText = "КРИТИЧЕСКИЙ СИГНАЛ: Выявлена подтвержденная БЫЧЬЯ фрактальная дивергенция v2! Цена падает на новые минимумы, но индекс денежного потока MFI разворачивается вверх — крупный капитал скрыто выкупает пролив";
    } else if (mfi.divergenceType.equals("BEARISH")) {
      divText = "КРИТИЧЕСКИЙ СИГНАЛ: Выявлена подтвержденная МЕДВЕЖЬЯ фрактальная дивергенция v2! Цена обновляет локальные максимумы, но индекс MFI падает — крупные деньги скрыто выходят из актива, распределяя позицию об толпу";
    }

    return "На таймфрейме " + label + " осциллятор Стохастик " + zoneText + " (%K=" + app.nf(stoch.k, 1, 1) + ", %D=" + app.nf(stoch.d, 1, 1) + ", " + momentumText + "). "
        + "Текущее значение индекса денежного потока MFI равно " + app.nf(mfi.value, 1, 0) + ", при этом " + divText + ". "
        + "Цена находится " + emaPosition + " скользящей средней EMA " + emaPeriod + " на " + app.nf(Math.abs(ema.distancePercent), 1, 2) + "%, " + trendText + ".";
  }

  private String escapeJson(String text) {
    if (text == null) return "";
    return text.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r").replace("\t", "\\t");
  }

  private void sendToLMStudio(String prompt) {
    try {
      HttpClient client = HttpClient.newHttpClient();
      String systemPrompt = "Ты старший количественный финансовый аналитик (Quant Trader). Ты торгуешь по стратегии возврата к средней и мастерски анализируешь дивергенции объемов. Твой тон уважительный, лаконичный и строго математический. Общаешься только на русском языке.";
      
      // СТРОГО ИСПРАВЛЕНО: Установили температуру 0.0 для максимальной логической стабильности и точности выводов
      String jsonBody = "{\"messages\":[{\"role\":\"system\",\"content\":\"" + escapeJson(systemPrompt) + "\"},{\"role\":\"user\",\"content\":\"" + escapeJson(prompt) + "\"}],\"temperature\":0.0,\"stream\":false,\"thinking\":false}";

      HttpRequest request = HttpRequest.newBuilder().uri(URI.create(aiUrl)).header("Content-Type", "application/json").POST(HttpRequest.BodyPublishers.ofString(jsonBody)).build();
      HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());

      if (response.statusCode() == 200) {
        JSONObject json = parseJSONObject(response.body());
        if (json != null && !json.isNull("choices")) {
          JSONArray choices = json.getJSONArray("choices");
          if (choices != null && choices.size() > 0) {
            JSONObject msg = choices.getJSONObject(0).getJSONObject("message");
            String content = msg.hasKey("content") ? msg.getString("content", "").trim() : "";
            String reasoning = msg.hasKey("reasoning_content") ? msg.getString("reasoning_content", "").trim() : "";
            String finalOutput = !content.isEmpty() ? content : reasoning;
            
            if (!finalOutput.isEmpty()) {
              if (finalOutput.startsWith("\"") && finalOutput.endsWith("\"") && finalOutput.length() > 1) {
                finalOutput = finalOutput.substring(1, finalOutput.length() - 1).trim();
              }
              aiResponse = finalOutput;
            } else { aiResponse = "Предупреждение: ИИ вернул пустой ответ."; }
          }
        }
      } else { aiResponse = "LM Studio вернул ошибку HTTP: " + response.statusCode(); }
    } catch (Exception e) { aiResponse = "Ошибка подключения: " + e.getMessage(); }
    finally { this.isThinking = false; }
  }
}
