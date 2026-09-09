//*********************************
// 6 === ВКЛАДКА: TInvestClient ===

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
  // Единый официальный боевой эндпоинт T-Invest API
  private final String apiUrl = "https://invest-public-api.tbank.ru/rest/tinkoff.public.invest.api.contract.v1.InstrumentsService/FindInstrument";
  
  public ArrayList<InstrumentItem> foundInstruments = new ArrayList<InstrumentItem>();
  public String searchResult = "Введите тикер и нажмите ENTER...";
  public boolean isSearching = false;

  public TInvestClient(String token) { this.token = token; }

  // Поиск инструментов на Московской Бирже
  public void performSearch(String query) {
    this.isSearching = true; 
    this.searchResult = "Отправка запроса брокеру..."; 
    this.foundInstruments.clear();
    
    try {
      HttpClient client = createSecureClient();
      // СТРОГО ИСПРАВЛЕНО: gRPC-совместимый параметр UNSPECIFIED для бесперебойного поиска
      String jsonBody = "{\"query\":\"" + query.trim() + "\",\"instrumentKind\":\"INSTRUMENT_KIND_UNSPECIFIED\"}";
      
      HttpRequest request = HttpRequest.newBuilder()
        .uri(URI.create(apiUrl))
        .header("Content-Type", "application/json")
        .header("Accept", "application/json")
        .header("Authorization", "Bearer " + token)
        .POST(HttpRequest.BodyPublishers.ofString(jsonBody))
        .build();
        
      HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
      if (response.statusCode() == 200) {
        parseSearchResponse(response.body());
      } else {
        searchResult = "Ошибка API! Код: " + response.statusCode();
      }
    } catch (Exception e) { 
      searchResult = "Ошибка сети: " + e.getMessage(); 
    } finally { 
      this.isSearching = false; 
    }
  }

  // Двухпроходной парсинг: поднимает боевые акции TQBR на первое место, а затем добавляет фьючерсы
  private void parseSearchResponse(String jsonString) {
    try {
      JSONObject json = parseJSONObject(jsonString);
      if (json == null || json.isNull("instruments")) { searchResult = "Ничего не найдено."; return; }
      JSONArray instruments = json.getJSONArray("instruments");
      if (instruments == null || instruments.size() == 0) { searchResult = "Ничего не найдено."; return; }
      
      foundInstruments.clear(); 
      int addedCount = 0;
      
      // pass = 1 (собираем акции TQBR), pass = 2 (собираем фьючерсы SPBFUT)
      for (int pass = 1; pass <= 2; pass++) {
        for (int i = 0; i < instruments.size(); i++) {
          if (addedCount >= 3) break; // Лимит вывода на экран UI
          
          JSONObject asset = instruments.getJSONObject(i);
          String classCode = asset.getString("classCode", "").toUpperCase().trim();
          String name = asset.getString("name", "").toLowerCase();
          
          if (pass == 1 && classCode.equals("TQBR")) {
            addInstrumentFromJSON(asset, cleanKindStr(asset.getString("instrumentKind", "UNKNOWN")));
            addedCount++;
          } else if (pass == 2 && classCode.equals("SPBFUT")) {
            // Защита от архивного мусора прошлых лет в базе Песочницы
            if (name.contains("-6.22") || name.contains("-9.22") || name.contains("-6.23") || name.contains("-9.23") || name.contains("-3.25") || name.contains("-6.25") || name.contains("-9.25") || name.contains("-12.25")) continue;
            addInstrumentFromJSON(asset, cleanKindStr(asset.getString("instrumentKind", "UNKNOWN")));
            addedCount++;
          }
        }
      }
      if (foundInstruments.isEmpty()) searchResult = "Боевые инструменты не найдены.";
    } catch (Exception e) { 
      searchResult = "Ошибка JSON: " + e.getMessage(); 
    }
  }

  private void addInstrumentFromJSON(JSONObject asset, String type) {
    foundInstruments.add(new InstrumentItem(asset.getString("name", "Без названия"), asset.getString("ticker", "—"), asset.getString("uid", "—"), type));
  }
  
  private String cleanKindStr(String raw) {
    return raw.replace("INSTRUMENT_TYPE_", "").replace("INSTRUMENT_KIND_", "").toLowerCase().trim();
  }

  // Загрузка исторических свечей и отправка на расчет индикаторов
  public IndicatorPackage fetchAndCalculate(String uid, String intervalStr, int daysAgo, int emaPeriod, String ticker) {
    try {
      HttpClient client = createSecureClient();
      
      // Железобетонная генерация дат ISO-8601 без сбойных миллисекунд
      java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
      sdf.setTimeZone(java.util.TimeZone.getTimeZone("UTC"));
      java.util.Calendar cal = java.util.Calendar.getInstance();
      String toStr = sdf.format(cal.getTime());
      cal.add(java.util.Calendar.DAY_OF_YEAR, -daysAgo);
      String fromStr = sdf.format(cal.getTime());

      String candlesUrl = "https://invest-public-api.tbank.ru/rest/tinkoff.public.invest.api.contract.v1.MarketDataService/GetCandles";
      String jsonBody = "{\"instrumentId\":\"" + uid + "\",\"from\":\"" + fromStr + "\",\"to\":\"" + toStr + "\",\"interval\":\"" + intervalStr + "\",\"limit\":2000}";
      System.out.println("[ОТПРАВКА] Тикер: " + ticker + " | UID: " + uid + " | Диапазон: " + fromStr + " -> " + toStr);

      HttpRequest request = HttpRequest.newBuilder().uri(URI.create(candlesUrl)).header("Content-Type", "application/json").header("Authorization", "Bearer " + token).POST(HttpRequest.BodyPublishers.ofString(jsonBody)).build();
      HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
      
      if (response == null || response.statusCode() != 200) return new IndicatorPackage(new StochasticResult(), new EmaResult(), new MfiResult());
      
      JSONObject json = parseJSONObject(response.body());
      JSONArray candlesJson = json.getJSONArray("candles");
      int candlesCount = (candlesJson != null) ? candlesJson.size() : 0;
      System.out.println("[ЛОГ СВЕЧЕЙ] Интервал: " + intervalStr + " | Получено боевых свечей: " + candlesCount);

      // Защита от нехватки истории (для MFI(14) и фракталов плечом 5 нужно минимум 30-40 свечей)
      if (candlesCount < 30) return new IndicatorPackage(new StochasticResult(), new EmaResult(), new MfiResult());

      Candle[] candles = new Candle[candlesCount];
      for (int i = 0; i < candlesCount; i++) {
        JSONObject cJson = candlesJson.getJSONObject(i);
        // Вытягиваем объем торгов (long) из структуры TInvest API
        long vol = cJson.hasKey("volume") ? cJson.getLong("volume") : 0;
        
        candles[i] = new Candle(
          parseQuotation(cJson.getJSONObject("high")), 
          parseQuotation(cJson.getJSONObject("low")), 
          parseQuotation(cJson.getJSONObject("close")),
          (float)vol
        );
      }
      return new IndicatorPackage(
        calculateStochastic533(candles), 
        calculateEMA(candles, emaPeriod),
        calculateMfiDivergenceV2(candles, 14) // Расчет MFI v2 по TradingView с периодом 14
      );
    } catch (Exception e) { 
      return new IndicatorPackage(new StochasticResult(), new EmaResult(), new MfiResult()); 
    }
  }

  // Алгоритм математического расчета Экспоненциальной скользящей средней (EMA)
  private EmaResult calculateEMA(Candle[] candles, int period) {
    int size = candles.length;
    if (size < period) period = Math.max(10, size - 5); // Адаптация периода под мелкую историю
    float[] emaValues = new float[size];
    float sum = 0;
    for (int i = 0; i < period; i++) sum += candles[i].close;
    emaValues[period - 1] = sum / period;
    
    float multiplier = 2.0f / (period + 1);
    for (int i = period; i < size; i++) emaValues[i] = (candles[i].close - emaValues[i - 1]) * multiplier + emaValues[i - 1];
    
    float currentEma = emaValues[size - 1], prevEma = emaValues[size - 2], currentClose = candles[size - 1].close;
    float delta = currentEma - prevEma, threshold = currentEma * 0.0001f;
    String trendDirection = "флэт";
    if (delta > threshold) trendDirection = "вверх"; else if (delta < -threshold) trendDirection = "вниз";
    
    return new EmaResult(currentEma, ((currentClose - currentEma) / currentEma) * 100.0f, trendDirection);
  }

  // Алгоритм математического расчета Осциллятора Стохастик (5, 3, 3)
  private StochasticResult calculateStochastic533(Candle[] candles) {
    int size = candles.length; float[] fastK = new float[size];
    for (int i = 4; i < size; i++) {
      float maxH = candles[i].high, minL = candles[i].low;
      for (int j = i - 4; j <= i; j++) {
        if (candles[j].high > maxH) maxH = candles[j].high; if (candles[j].low < minL) minL = candles[j].low;
      }
      fastK[i] = (maxH - minL == 0) ? 50 : ((candles[i].close - minL) / (maxH - minL)) * 100;
    }
    float[] smoothK = new float[size];
    for (int i = 6; i < size; i++) smoothK[i] = (fastK[i] + fastK[i-1] + fastK[i-2]) / 3.0f;
    for (int i = 8; i < size; i++) {
      float d = (smoothK[i] + smoothK[i-1] + smoothK[i-2]) / 3.0f;
      if (i == size - 1) return new StochasticResult(smoothK[i], d);
    }
    return new StochasticResult();
  }

  // Настоящий TradingView MFI Divergence v2 движок с фрактальным поиском пиков
  private MfiResult calculateMfiDivergenceV2(Candle[] candles, int mfiPeriod) {
    int size = candles.length;
    if (size < mfiPeriod + 20) return new MfiResult();

    float[] typicalPrices = new float[size];
    float[] moneyFlow = new float[size];
    float[] mfi = new float[size];

    // Шаг 1: Расчет типичной цены и объема денежного потока
    for (int i = 0; i < size; i++) {
      typicalPrices[i] = (candles[i].high + candles[i].low + candles[i].close) / 3.0f;
      moneyFlow[i] = typicalPrices[i] * candles[i].volume;
    }

    // Шаг 2: Расчет стандартного осциллятора MFI
    for (int i = mfiPeriod; i < size; i++) {
      float posFlow = 0, negFlow = 0;
      for (int j = i - mfiPeriod + 1; j <= i; j++) {
        if (typicalPrices[j] > typicalPrices[j - 1]) posFlow += moneyFlow[j];
        else if (typicalPrices[j] < typicalPrices[j - 1]) negFlow += moneyFlow[j];
      }
      mfi[i] = (negFlow == 0) ? 100 : 100.0f - (100.0f / (1.0f + (posFlow / negFlow)));
    }

    // Шаг 3: Математический поиск Pivot Points (Фракталов) плечом в 5 свечей
    String divType = "NONE";
    int current = size - 1;
    int leftLeft = 5; // Свечей слева и справа для подтверждения фрактального пика

    // Ищем последний подтвержденный Pivot High цены
    int currentPivotHighIdx = -1;
    for (int i = current - leftLeft; i > mfiPeriod + leftLeft; i--) {
      boolean isPivot = true;
      for (int j = 1; j <= leftLeft; j++) {
        if (candles[i].high < candles[i-j].high || candles[i].high < candles[i+j].high) {
          isPivot = false; break;
        }
      }
      if (isPivot) { currentPivotHighIdx = i; break; }
    }

    // Ищем предыдущий Pivot High для сравнения вершин
    int prevPivotHighIdx = -1;
    if (currentPivotHighIdx != -1) {
      for (int i = currentPivotHighIdx - leftLeft - 1; i > mfiPeriod + leftLeft; i--) {
        boolean isPivot = true;
        for (int j = 1; j <= leftLeft; j++) {
          if (candles[i].high < candles[i-j].high || candles[i].high < candles[i+j].high) {
            isPivot = false; break;
          }
        }
        if (isPivot) { prevPivotHighIdx = i; break; }
      }
    }

    // Детекция Медвежьей Дивергенции (Медвежий пик цены растет, а денежный приток MFI слабеет)
    if (currentPivotHighIdx != -1 && prevPivotHighIdx != -1) {
    if (candles[currentPivotHighIdx].high > candles[prevPivotHighIdx].high &&
     mfi[currentPivotHighIdx] < mfi[prevPivotHighIdx]) {
     // Сигнал актуален, если фрактал сформировался в пределах последних 8 свечей
      if (current - currentPivotHighIdx <= 8) divType = "BEARISH";
    }
  }

  // Ищем последний подтвержденный Pivot Low цены
  int currentPivotLowIdx = -1;
  for (int i = current - leftLeft; i > mfiPeriod + leftLeft; i--) {
    boolean isPivot = true;
    for (int j = 1; j <= leftLeft; j++) {
      if (candles[i].low > candles[i-j].low || candles[i].low > candles[i+j].low) {
        isPivot = false; break;
      }
    }
    if (isPivot) { currentPivotLowIdx = i; break; }
  }

  // Ищем предыдущий Pivot Low для сравнения низин
  int prevPivotLowIdx = -1;
  if (currentPivotLowIdx != -1) {
    for (int i = currentPivotLowIdx - leftLeft - 1; i > mfiPeriod + leftLeft; i--) {
      boolean isPivot = true;
      for (int j = 1; j <= leftLeft; j++) {
        if (candles[i].low > candles[i-j].low || candles[i].low > candles[i+j].low) {
          isPivot = false; break;
        }
      }
      if (isPivot) { prevPivotLowIdx = i; break; }
    }
  }

  // Детекция Бычьей Дивергенции (Низина цены падает, но MFI формирует 
  // сильное накопление объемов выше предыдущего)
  if (currentPivotLowIdx != -1 && prevPivotLowIdx != -1 && divType.equals("NONE")) {
    if (candles[currentPivotLowIdx].low < candles[prevPivotLowIdx].low &&
     mfi[currentPivotLowIdx] > mfi[prevPivotLowIdx]) {
      if (current - currentPivotLowIdx <= 8) divType = "BULLISH";
    }
  }

  return new MfiResult(mfi[current], divType);
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
// Строго Redirect.NEVER, чтобы Т-Банк не стирал заголовок Authorization при внутренних переходах
return 
HttpClient.newBuilder().sslContext(sslContext).followRedirects(HttpClient.Redirect.NEVER).build();
}

private float parseQuotation(JSONObject obj) {
  return obj == null ? 0 : (float) (obj.getLong("units", 0) + (obj.getInt("nano", 0) / 1000000000.0));
  }
}