// === ВКЛАДКА: LocalAIClient ===
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

class LocalAIClient {
  private final String aiUrl = "http://localhost:1234/v1/chat/completions";

  public String aiResponse = "Нажмите кнопку ниже, чтобы запустить анализ ИИ...";
  public boolean isThinking = false;

  // Метод теперь принимает пары: StochasticResult + EmaResult для каждого таймфрейма
  public void analyzeDataAsync(PApplet app, String assetName, String ticker, String groupLabel,
      String label1, StochasticResult tf1, EmaResult ema1,
      String label2, StochasticResult tf2, EmaResult ema2,
      String label3, StochasticResult tf3, EmaResult ema3) {
    this.isThinking = true;
    this.aiResponse = "ИИ изучает показатели таймфреймов...";

    // Форматируем комплексное описание (Стохастик + EMA) в человеческий текст
    String row1 = formatMarketStateToText(app, label1, tf1, ema1);
    String row2 = formatMarketStateToText(app, label2, tf2, ema2);
    String row3 = formatMarketStateToText(app, label3, tf3, ema3);

    String prompt = "Привет! Проанализируй текущую рыночную ситуацию по инструменту " + assetName + " (" + ticker + ").\n"
                  + "Мы используем стратегию Возврата к средней (Mean Reversion) для группы таймфреймов: " + groupLabel + ".\n\n"
                  + "Вот текстовое описание текущего состояния рынка:\n"
                  + "1. " + row1 + "\n"
                  + "2. " + row2 + "\n"
                  + "3. " + row3 + "\n\n"
                  + "На основе этих данных напиши профессиональный аналитический обзор для трейдера на русском языке:\n"
                  + "- Кратко интерпретируй ситуацию для каждого таймфрейма (по одному предложению).\n"
                  + "- Оцени потенциал возврата цены к средней линии EMA 200 (натянута ли «резинка» отклонения).\n"
                  + "- Проверь, согласуются ли сигналы Стохастика и отклонения цены между таймфреймами.\n"
                  + "- В самом конце напиши финальную строчку строго в формате: «Итог: [Твое торговое решение]».\n\n"
                  + "Пиши исключительно обычным связным текстом. Никакого программного кода или JSON структур.";

    new Thread(new Runnable() {
      public void run() {
        sendToLMStudio(prompt);
      }
    }).start();
  }

  // Переводим Стохастик и отклонение EMA в естественные предложения для финансовой модели
  private String formatMarketStateToText(PApplet app, String label, StochasticResult stoch, EmaResult ema) {
    if (stoch == null || stoch.isError || ema == null || ema.isError) {
      return "На таймфрейме " + label + " технические индикаторы временно недоступны.";
    }
    
    String zoneText = "находится в нейтральной зоне";
    if (stoch.k >= 80) zoneText = "глубоко зашел в зону перекупленности";
    if (stoch.k <= 20) zoneText = "сильно опустился в зону перепроданности";
    
    String momentumText = "линии индикатора сближены";
    if (stoch.k > stoch.d + 0.5) momentumText = "быстрая линия пробивает сигнальную снизу вверх (бычий импульс)";
    if (stoch.k < stoch.d - 0.5) momentumText = "быстрая линия уходит под сигнальную сверху вниз (медвежий импульс)";

    String emaPosition = ema.distancePercent >= 0 ? "выше" : "ниже";
    String trendText = "при этом сама линия средней имеет тренд " + ema.trendDirection;
    if (ema.trendDirection.equals("флэт")) trendText = "при этом линия средней находится в горизонтальном флэте, что идеально для Mean Reversion";

    return "На таймфрейме " + label + " осциллятор Стохастик " + zoneText + " (%K=" + app.nf(stoch.k, 1, 1) + ", %D=" + app.nf(stoch.d, 1, 1) + ", " + momentumText + "). "
         + "Текущая цена отклонилась и находится " + emaPosition + " скользящей средней EMA 200 на " + app.nf(Math.abs(ema.distancePercent), 1, 2) + "%, "
         + trendText + ".";
  }

  private String escapeJson(String text) {
    if (text == null) return "";
    return text.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r").replace("\t", "\\t");
  }

  private void sendToLMStudio(String prompt) {
    try {
      HttpClient client = HttpClient.newHttpClient();
      String systemPrompt = "Ты опытный финансовый аналитик, торгующий по стратегии возврата к средней. Общайся с трейдером уважительно и профессионально, исключительно текстом на русском языке без кода.";

      String jsonBody = "{"
        + "\"messages\": ["
        + "{"
        + "\"role\": \"system\","
        + "\"content\": \"" + escapeJson(systemPrompt) + "\""
        + "},"
        + "{"
        + "\"role\": \"user\","
        + "\"content\": \"" + escapeJson(prompt) + "\""
        + "}"
        + "],"
        + "\"temperature\": 0.6,"
        + "\"stream\": false"
        + "}";

      HttpRequest request = HttpRequest.newBuilder()
        .uri(URI.create(aiUrl))
        .header("Content-Type", "application/json")
        .POST(HttpRequest.BodyPublishers.ofString(jsonBody))
        .build();

      HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());

      if (response.statusCode() == 200) {
        String responseBody = response.body();
        try {
          JSONObject json = parseJSONObject(responseBody);
          if (json != null && !json.isNull("choices")) {
            JSONArray choices = json.getJSONArray("choices");
            if (choices != null && choices.size() > 0) {
              JSONObject firstChoice = choices.getJSONObject(0);
              if (firstChoice != null && !firstChoice.isNull("message")) {
                JSONObject message = firstChoice.getJSONObject("message");
                String content = message.getString("content", "").trim();
                
                if (content.startsWith("\"") && content.endsWith("\"") && content.length() > 1) {
                  content = content.substring(1, content.length() - 1).trim();
                }
                
                aiResponse = content;
                System.out.println("[УСПЕХ ИИ] Анализ Mean Reversion успешно выведен.");
              }
            }
          }
        } catch (Exception parseEx) {
          aiResponse = "Ошибка разбора ответа: " + parseEx.getMessage();
        }
      } else {
        aiResponse = "LM Studio вернул ошибку HTTP: " + response.statusCode();
      }
    } catch (Exception e) {
      aiResponse = "Ошибка подключения: " + e.getMessage();
    } finally {
      this.isThinking = false;
    }
  }
}
