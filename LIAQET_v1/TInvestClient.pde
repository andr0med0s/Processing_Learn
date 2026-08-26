// === ВКЛАДКА: TInvestClient ===
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import javax.net.ssl.SSLContext;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;
import java.security.cert.X509Certificate;

class TInvestClient {
  private final String token;
  private final String apiUrl = "https://sandbox-invest-public-api.tbank.ru/rest/tinkoff.public.invest.api.contract.v1.InstrumentsService/FindInstrument";

  public ArrayList<InstrumentItem> foundInstruments = new ArrayList<InstrumentItem>();
  public String searchResult = "Введите тикер и нажмите ENTER...";
  public boolean isSearching = false;

  public TInvestClient(String token) {
    this.token = token;
  }

  public void performSearch(String query) {
    this.isSearching = true;
    this.searchResult = "Отправка запроса брокеру...";
    this.foundInstruments.clear();

    try {
      HttpClient client = createSecureClient();
      String jsonBody = "{\"query\":\"" + query.trim() + "\",\"instrumentKind\":\"INSTRUMENT_TYPE_UNSPECIFIED\"}";
      
      HttpRequest request = HttpRequest.newBuilder()
        .uri(URI.create(apiUrl))
        .header("Content-Type", "application/json")
        .header("Accept", "application/json")
        .header("Authorization", "Bearer " + token)
        .POST(HttpRequest.BodyPublishers.ofString(jsonBody))
        .build();
        
      HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
      
      if (response.statusCode() == 200) {
        parseSearchResponse(response.body(), query);
      } else {
        searchResult = "Ошибка API! Код: " + response.statusCode();
      }
    } catch (Exception e) {
      searchResult = "Ошибка сети: " + e.getMessage();
    } finally {
      this.isSearching = false;
    }
  }

  private void parseSearchResponse(String jsonString, String query) {
    try {
      JSONObject json = parseJSONObject(jsonString);
      JSONArray instruments = json.getJSONArray("instruments");
      if (instruments == null || instruments.size() == 0) {
        searchResult = "Ничего не найдено.";
        return;
      }
      
      int limit = Math.min(instruments.size(), 3);
      for (int i = 0; i < limit; i++) {
        JSONObject asset = instruments.getJSONObject(i);
        foundInstruments.add(new InstrumentItem(
          asset.getString("name", "Без названия"),
          asset.getString("ticker", "—"),
          asset.getString("uid", "—"),
          asset.getString("instrumentType", "UNKNOWN")
        ));
      }
    } catch (Exception e) {
      searchResult = "Ошибка JSON: " + e.getMessage();
    }
  }

  // Метод теперь возвращает пакет индикаторов (Стохастик + EMA 200)
  public IndicatorPackage fetchAndCalculate(String uid, String intervalStr, int daysAgo) {
    try {
      HttpClient client = createSecureClient();
      java.time.Instant toInstant = java.time.Instant.now();
      java.time.Instant fromInstant = toInstant.minus(daysAgo, java.time.temporal.ChronoUnit.DAYS);

      String candlesUrl = "https://sandbox-invest-public-api.tbank.ru/rest/tinkoff.public.invest.api.contract.v1.MarketDataService/GetCandles";
      String jsonBody = "{\"instrumentId\":\"" + uid + "\",\"from\":\"" + fromInstant.toString() + "\",\"to\":\"" + toInstant.toString() + "\",\"interval\":\"" + intervalStr + "\"}";

      HttpRequest request = HttpRequest.newBuilder()
        .uri(URI.create(candlesUrl))
        .header("Content-Type", "application/json")
        .header("Authorization", "Bearer " + token)
        .POST(HttpRequest.BodyPublishers.ofString(jsonBody))
        .build();

      HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
      
      if (response.statusCode() != 200) {
        System.out.println("[ОШИБКА API СВЕЧЕЙ] Интервал: " + intervalStr + " | Код ответа: " + response.statusCode());
        return new IndicatorPackage(new StochasticResult(), new EmaResult());
      }

      JSONObject json = parseJSONObject(response.body());
      JSONArray candlesJson = json.getJSONArray("candles");
      
      // Для качественного расчета EMA 200 нам нужно достаточное количество свечей
      if (candlesJson == null || candlesJson.size() < 10) {
        return new IndicatorPackage(new StochasticResult(), new EmaResult());
      }

      Candle[] candles = new Candle[candlesJson.size()];
      for (int i = 0; i < candlesJson.size(); i++) {
        JSONObject cJson = candlesJson.getJSONObject(i);
        float h = parseQuotation(cJson.getJSONObject("high"));
        float l = parseQuotation(cJson.getJSONObject("low"));
        float c = parseQuotation(cJson.getJSONObject("close"));
        candles[i] = new Candle(h, l, c);
      }
      
      // Рассчитываем Стохастик и EMA параллельно из одной выборки данных
      StochasticResult stoch = calculateStochastic533(candles);
      EmaResult ema = calculateEMA(candles, 200); // Базовый тяжелый период для Mean Reversion
      
      return new IndicatorPackage(stoch, ema);
    } catch (Exception e) {
      return new IndicatorPackage(new StochasticResult(), new EmaResult());
    }
  }

  // Метод математического расчета Экспоненциальной скользящей средней
  private EmaResult calculateEMA(Candle[] candles, int period) {
    int size = candles.length;
    if (size < period) {
      // Если свечей меньше периода индикатора (например, 150 вместо 200),
      // временно адаптируем период под доступный размер, чтобы избежать падения
      period = Math.max(10, size - 5); 
    }
    
    float[] emaValues = new float[size];
    
    // Шаг 1. Первое значение берем как простое среднее (SMA) за базовый период
    float sum = 0;
    for (int i = 0; i < period; i++) {
      sum += candles[i].close;
    }
    emaValues[period - 1] = sum / period;
    
    // Шаг 2. Применяем экспоненциальный коэффициент сглаживания (Multiplier)
    float multiplier = 2.0f / (period + 1);
    for (int i = period; i < size; i++) {
      emaValues[i] = (candles[i].close - emaValues[i - 1]) * multiplier + emaValues[i - 1];
    }
    
    // Текущие финальные метрики на последней свече
    float currentEma = emaValues[size - 1];
    float prevEma = emaValues[size - 2];
    float currentClose = candles[size - 1].close;
    
    // Считаем процентное отклонение цены закрытия от линии скользящей средней
    float distancePercent = ((currentClose - currentEma) / currentEma) * 100.0f;
    
    // Определяем наклон тренда по поведению скользящей средней
    String trendDirection = "флэт";
    float delta = currentEma - prevEma;
    float threshold = currentEma * 0.0001f; // Порог чувствительности для защиты от шума (0.01%)
    
    if (delta > threshold) trendDirection = "вверх";
    else if (delta < -threshold) trendDirection = "вниз";
    
    return new EmaResult(currentEma, distancePercent, trendDirection);
  }

  private HttpClient createSecureClient() throws Exception {
    TrustManager[] trustAllCerts = new TrustManager[] {
      new X509TrustManager() {
        public X509Certificate[] getAcceptedIssuers() { return null; }
        public void checkClientTrusted(X509Certificate[] certs, String authType) {}
        public void checkServerTrusted(X509Certificate[] certs, String authType) {}
      }
    };
    SSLContext sslContext = SSLContext.getInstance("TLS");
    sslContext.init(null, trustAllCerts, new java.security.SecureRandom());
    return HttpClient.newBuilder().sslContext(sslContext).followRedirects(HttpClient.Redirect.NEVER).build();
  }

  private float parseQuotation(JSONObject obj) {
    if (obj == null) return 0;
    long units = obj.getLong("units", 0);
    int nano = obj.getInt("nano", 0);
    return (float) (units + (nano / 1000000000.0));
  }

  private StochasticResult calculateStochastic533(Candle[] candles) {
    int size = candles.length;
    float[] fastK = new float[size];
    for (int i = 4; i < size; i++) {
      float maxHigh = candles[i].high;
      float minLow = candles[i].low;
      for (int j = i - 4; j <= i; j++) {
        if (candles[j].high > maxHigh) maxHigh = candles[j].high;
        if (candles[j].low < minLow) minLow = candles[j].low;
      }
      float range = maxHigh - minLow;
      fastK[i] = (range == 0) ? 50 : ((candles[i].close - minLow) / range) * 100;
    }
    float[] smoothK = new float[size];
    for (int i = 6; i < size; i++) {
      smoothK[i] = (fastK[i] + fastK[i-1] + fastK[i-2]) / 3.0;
    }
    for (int i = 8; i < size; i++) {
      float d = (smoothK[i] + smoothK[i-1] + smoothK[i-2]) / 3.0;
      if (i == size - 1) return new StochasticResult(smoothK[i], d);
    }
    return new StochasticResult();
  }
}
