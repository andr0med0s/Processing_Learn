import java.io.File;
import java.io.OutputStream;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;

// =========================================================================
// ГЛОБАЛЬНЫЕ СЛОИ И ДВИЖОК ФОНОВ
// =========================================================================
PGraphics bgLayer;
PGraphics drawLayer;

String[] bgImages;
int currentBgIndex = 0;
PImage currentBg;

// Динамический параметр: скорость исчезновения линий (теперь управляется ИИ)
float lineFadeSpeed = 4.5; 

// =========================================================================
// КОРНЕВЫЕ НАСТРОЙКИ СВЯЗИ И ГЛИТЧ-ДВИЖКА
// =========================================================================
float aiShiftAmount = 6.0;
float aiGlitchIntensity = 15.0;
int aiColorChannel = 0; 
String aiTextAssociation = "СИНХРОНИЗАЦИЯ"; 

float glitchIntensity = 0.0;
PImage canvasBackup;
int lastAiRequestTime = 0;
int aiInterval = 850; 

// Элементы接口 и логики 4 изменений
float btnX = 25; float btnY = 25; float btnW = 160; float btnH = 40;
boolean isSavingImage = false;

int changeCounter = 0;
final int MAX_CHANGES = 4;
boolean isAIRequesting = false;
String aiStatus = "Готов к работе. ИИ работает циклично.";

// История движений пера
class Movement {
    float x, y, pressure, speed;
    Movement(float x, float y, float p, float s) {
        this.x = x; this.y = y; this.pressure = p; this.speed = s;
        }
}
ArrayList<Movement> history = new ArrayList<Movement>();
int maxHistorySize = 10;

// == = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
// ИНИЦИАЛИЗАЦИЯ И СЕТАП ХОЛСТА
// == = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
void setup() {
    size(1000, 1000, P2D);
    background(12, 12, 16); 
    smooth(8);
    
    canvasBackup = createImage(width, height, RGB);
    textFont(createFont("Courier New", 22, true));
    
    //Инициализация слоев
    bgLayer = createGraphics(width, height);
    drawLayer = createGraphics(width, height);
    
    drawLayer.beginDraw();
    drawLayer.clear();
    drawLayer.endDraw();
    
    //Сканирование папки data на PNG-картинки
    File dir = new File(sketchPath("data"));
    bgImages = dir.list((d, name) -> name.toLowerCase().endsWith(".png"));
    
    loadBackgroundByIndex(0);
    
    //Первыйасинхронный запуск ИИ
    thread("updateAIParamsInBackground");
}

// == = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
// ГЛАВНЫЙ ЦИКЛ ОТРИСОВКИ
// == = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
void draw() {
    //Постепенная смена атмосферы фона
    applyDynamicBackground();
    
    if (mousePressed && !checkButtonHover()) {
        drawContextBrush(); // Рисуем кастомной кистью
        
        float p = getPenPressure();
        float s = PVector.dist(new PVector(pmouseX, pmouseY), new PVector(mouseX, mouseY));
        
        history.add(new Movement(mouseX, mouseY, p, s));
        if (history.size() > maxHistorySize) {
            history.remove(0);
            }
        
        if (millis() - lastAiRequestTime > aiInterval) {
            thread("updateAIParamsInBackground"); 
            lastAiRequestTime = millis();
            }
        }
    
    //Эффект постепенного исчезновения линий на Слое 2 (Параметр контролируется ИИ)
    fadeDrawLayer();
    
    //Отрисовка фонового изображения (Слой 1)
    tint(255, 255); 
    image(bgLayer, 0, 0);
    noTint();
    
    //Накатываем слой рисования (Слой 2) с базовым глитчем
    applyGlitchEffect(drawLayer, glitchIntensity);
    
    //Глитч деструкция полос холста
    if (random(1) < (aiGlitchIntensity / 100.0)) {
        applyHorizontalSlice(int(aiGlitchIntensity));
        }
    
    // Хроматическая аберрация
    applyAiRGBShift(int(aiShiftAmount), aiColorChannel);
    
    // Отрисовка интерфейса
    if (!isSavingImage) {
        drawAiTextOverlay();
        drawSaveButton();
        drawUI(); 
        }
}

// Функция плавного таяния линий
void fadeDrawLayer() {
    drawLayer.beginDraw();
    drawLayer.loadPixels();
    for (int i = 0; i < drawLayer.pixels.length; i++) {
        int pColor = drawLayer.pixels[i];
        float a = alpha(pColor);
        
        if (a > 0) {
            a = max(0, a - lineFadeSpeed); 
            drawLayer.pixels[i] = color(red(pColor), green(pColor), blue(pColor), a);
            }
        }
    drawLayer.updatePixels();
    drawLayer.endDraw();
}

// ДИНАМИЧЕСКИЕ ПАЛИТРЫ И КИСТИ ПОД СОСТОЯНИЯ ИИ
void applyDynamicBackground() {
    noStroke();
    if (aiTextAssociation.equals("ПОТОК")) {
        fill(8, 18, 20, 1); 
        } 
    else if (aiTextAssociation.equals("ЭКСПРЕССИЯ")) {
        fill(22, 10, 24, 1); 
        } 
    else if (aiTextAssociation.equals("ТЯЖЕСТЬ")) {
        fill(24, 12, 10, 1); 
        } 
    else if (aiTextAssociation.equals("КИНЕТИКА")) {
        fill(5, 5, 12, 1);   
        } 
    else {
        fill(12, 12, 16, 1);  
        }
    rect(0, 0, width, height);
}
void drawContextBrush() {
    float pressure = getPenPressure();
    float localBrushSize = map(pressure, 0, 1, 6, 60);
    
    drawLayer.beginDraw();
    
    if (aiTextAssociation.equals("ПОТОК")) {
        drawLayer.stroke(80, 240, 220, 200); 
        drawLayer.strokeWeight(2.0);
        for (int i = 0; i < 5; i++) {
            float offset = random( -localBrushSize, localBrushSize);
            drawLayer.line(pmouseX + offset, pmouseY + offset, mouseX + offset, mouseY + offset);
            }
        } 
    else if (aiTextAssociation.equals("ЭКСПРЕССИЯ")) {
        drawLayer.fill(100, 255, 120, 230);
        drawLayer.noStroke();
        drawLayer.rectMode(CENTER);
        drawLayer.rect(mouseX, mouseY, localBrushSize * 1.5, localBrushSize * 1.5, 4);
        if (random(1) < 0.4) { 
            drawLayer.rect(mouseX + random( -50, 50), mouseY + random( -50, 50), random(4, 12), random(4, 12));
            }
        drawLayer.rectMode(CORNER); 
        } 
    else if (aiTextAssociation.equals("ТЯЖЕСТЬ")) {
        drawLayer.stroke(180, 40, 40, 255);
        drawLayer.strokeWeight(localBrushSize * 2.0);
        drawLayer.line(pmouseX, pmouseY, mouseX, mouseY);
        } 
    else if (aiTextAssociation.equals("КИНЕТИКА")) {
        drawLayer.stroke(255, 255, 255, 255); 
        drawLayer.strokeWeight(2);
        drawLayer.line(pmouseX, pmouseY, mouseX, mouseY);
        
        drawLayer.stroke(60, 130, 245, 200); 
        drawLayer.strokeWeight(localBrushSize / 2);
        drawLayer.line(pmouseX, pmouseY, mouseX, mouseY);
        } 
    else {
        drawLayer.stroke(200, 200, 200, 220);
        drawLayer.strokeWeight(10);
        drawLayer.line(pmouseX, pmouseY, mouseX, mouseY);
        }
    
    drawLayer.endDraw();
}
// ГРАФИЧЕСКИЕ МЕТОДЫ ГЛИТЧА
float getPenPressure() {
    float pressure = 0.5;
    if (mousePressed) {
        pressure = map(PVector.dist(new PVector(pmouseX, pmouseY), new PVector(mouseX, mouseY)), 0, 120, 0.2, 1.0);
        pressure = constrain(pressure, 0.1, 1.0);
        }
    return pressure;
}

void applyGlitchEffect(PGraphics layer, float intensity) {
    if (intensity <= 1) {
        image(layer, 0, 0);
        return;
        }
    layer.loadPixels();
    
    for (int y = 0; y < height; y++) {
        int shift = (random(100) < intensity) ? (int)random( -intensity, intensity) : 0;
        for (int x = 0; x < width; x++) {
            int targetX = (x + shift + width) % width;
            int pColor = layer.pixels[x + y * width];
            if (alpha(pColor) > 0) {
                set(targetX, y, pColor);
                }
            }
        }
}

void applyHorizontalSlice(int intensity) {
    loadPixels();
    int yStart = int(random(0, height - 45)); 
    int sliceHeight = int(random(6, 35)); 
    int shiftX = int(random( - intensity, intensity));
    
    canvasBackup.loadPixels();
    for (int i = 0; i < pixels.length; i++) canvasBackup.pixels[i] = pixels[i];
    canvasBackup.updatePixels();
    
    for (int y = yStart; y < yStart + sliceHeight; y++) {
        for (int x = 0; x < width; x++) {
            int newX = (x + shiftX + width) % width; 
            pixels[y * width + x] = canvasBackup.pixels[y * width + newX];
            }
        }
    updatePixels();
}

void applyAiRGBShift(int shift, int targetChannel) {
    if (shift <= 0) return;
    loadPixels(); 
    canvasBackup.loadPixels();
    
    for (int i = 0; i < pixels.length; i++) canvasBackup.pixels[i] = pixels[i];
    
    for (int y = 0; y < height; y++) {
        for (int x = shift; x < width - shift; x++) {
            int loc = y * width + x; 
            int shiftLoc = y * width + (x - shift);
            
            float r = red(canvasBackup.pixels[loc]); 
            float g = green(canvasBackup.pixels[loc]); 
            float b = blue(canvasBackup.pixels[loc]);
            
            if (targetChannel == 0) r = red(canvasBackup.pixels[shiftLoc]);
            else if (targetChannel == 1) g = green(canvasBackup.pixels[shiftLoc]);
            else b = blue(canvasBackup.pixels[shiftLoc]);
            
            pixels[loc] = color(r, g, b);
            }
        }
    updatePixels();
}

// ================================ = = 
// СЕТЕВОЙ МОДУЛЬ LM STUDIO (ОБНОВЛЕННЫЙ ПРОМПТ ПОД ЗАТУХАНИЕ)
// ================================ = = =
void updateAIParamsInBackground() { 
    if (changeCounter >= MAX_CHANGES) {
        aiStatus = "Лимит изменений(4 / 4) достигнут.Нажмите[C] для сброса.";
        return; 
        }
    if (!isAIRequesting) {
        isAIRequesting = true;
        aiStatus = "Запрос к Llama 3.1 (" + (changeCounter + 1) + "/4)...";
        thread("askLocalAI"); 
        }
}

void askLocalAI() {
  StringBuilder historyData = new StringBuilder();
  historyData.append("[");
  if (history.isEmpty()) {
    historyData.append("{step:0,x:500,y:500,press:0.5,speed:12}");
  } else {
    for (int i = 0; i < history.size(); i++) {
      Movement m = history.get(i);
      historyData.append(String.format(java.util.Locale.US, "{step:%d,x:%d,y:%d,press:%.2f,speed:%.1f}", i, (int)m.x, (int)m.y, m.pressure, m.speed));
      if (i < history.size() - 1) historyData.append(",");
    }
  }
  historyData.append("]");
  
  String json = "{"
    + "\"messages\": ["
    + "  {\"role\": \"system\", \"content\": \"You are a generative art engine. Output string strictly in format: WORD | shift, glitch, channel, fade. Values: shift(1..30), glitch(1..50), channel(0..2), fade(1.0..15.0).\"},"
    + "  {\"role\": \"user\", \"content\": \"Pattern: " + historyData.toString() + "\"}"
    + "],"
    + "\"temperature\": 0.1," 
    + "\"stream\": false"
    + "}";
  
  try {
    java.net.URL url = new java.net.URL("http://localhost:1234/v1/chat/completions");
    java.net.HttpURLConnection conn = (java.net.HttpURLConnection) url.openConnection();
    conn.setRequestMethod("POST");
    conn.setRequestProperty("Content-Type", "application/json");
    conn.setDoOutput(true);
    conn.setConnectTimeout(2500); 
    
    java.io.OutputStream os = conn.getOutputStream();
    os.write(json.getBytes("UTF-8")); 
    os.flush(); 
    os.close();
    
    java.io.BufferedReader in = new java.io.BufferedReader(new java.io.InputStreamReader(conn.getInputStream()));
    String inputLine; StringBuilder response = new StringBuilder();
    while ((inputLine = in.readLine()) != null) { 
      response.append(inputLine); 
    }
    in.close();
    
    JSONObject jsonResponse = parseJSONObject(response.toString());
    String aiText = jsonResponse.getJSONArray("choices").getJSONObject(0).getJSONObject("message").getString("content").trim();
    
    // 1. Проверка на автоматический JSON-перехват от LM Studio
    if (aiText.startsWith("{") || aiText.contains("parameters") || aiText.contains("analyze_drawing_pattern_history")) {
      float currentSpeed = 10; float currentPress = 0.5;
      if (!history.isEmpty()) {
        Movement lastM = history.get(history.size() - 1);
        currentSpeed = lastM.speed; currentPress = lastM.pressure;
      }
      
      if (currentSpeed > 45) {
        aiTextAssociation = "КИНЕТИКА"; aiGlitchIntensity = random(35, 50); aiShiftAmount = random(18, 30); aiColorChannel = 0; lineFadeSpeed = random(10, 15);
      } else if (currentSpeed > 15) {
        aiTextAssociation = "ЭКСПРЕССИЯ"; aiGlitchIntensity = random(20, 35); aiShiftAmount = random(10, 18); aiColorChannel = 1; lineFadeSpeed = random(5, 9);
      } else if (currentPress > 0.7) {
        aiTextAssociation = "ТЯЖЕСТЬ"; aiGlitchIntensity = random(15, 25); aiShiftAmount = random(5, 12); aiColorChannel = 2; lineFadeSpeed = random(1.5, 3.5);
      } else {
        aiTextAssociation = "ПОТОК"; aiGlitchIntensity = random(5, 15); aiShiftAmount = random(2, 6); aiColorChannel = int(random(0, 3)); lineFadeSpeed = random(3.0, 5.5);
      }
      
      glitchIntensity = aiGlitchIntensity;
      changeCounter++;
      aiStatus = "Обновлено (" + changeCounter + "/4).";
      return; 
    }
    
    // 2. Обработка и текстовый парсинг нормального ответа (Нативный синтаксис Processing)
    aiText = aiText.replace("**", "").replace("`", "").trim();
    String[] mainParts = split(aiText, '|');
    mainParts = trim(mainParts); 
    
    if (mainParts.length >= 2) {
      aiTextAssociation = mainParts[0].toUpperCase(); 
      String[] numericParts = split(mainParts[1], ',');
      numericParts = trim(numericParts); 
      
      if (numericParts.length >= 3) {
        // В Processing нативно парсим элементы через float() и int()
        aiShiftAmount = constrain(float(numericParts[0]), 1, 30);
        aiGlitchIntensity = constrain(float(numericParts[1]), 1, 50);
        aiColorChannel = int(constrain(float(numericParts[2]), 0, 2));
        
        if (numericParts.length >= 4) {
          lineFadeSpeed = constrain(float(numericParts[3]), 1.0, 15.0);
        }
      }
    } else if (aiText.length() < 25) {
       aiTextAssociation = aiText.toUpperCase(); 
    }
    
    glitchIntensity = aiGlitchIntensity;
    changeCounter++;
    aiStatus = "Обновлено (" + changeCounter + "/4).";
    
  } catch (Exception e) {
    aiTextAssociation = "СБОЙ СВЯЗИ";
    aiStatus = "Ошибка ИИ. Проверьте LM Studio.";
    e.printStackTrace();
  } finally {
    isAIRequesting = false;
  }
}


// = / / ИНТЕРФЕЙС И УПРАВЛЕНИЕ ХОЛСТОМ// =
void loadBackgroundByIndex(int index) {
    if (bgImages != null && bgImages.length > index && index >= 0) {
        currentBgIndex = index;currentBg = loadImage(bgImages[currentBgIndex]);
        bgLayer.beginDraw();bgLayer.image(currentBg, 0, 0, width, height);
        bgLayer.endDraw();
        }
} 
boolean checkButtonHover() {
    return(mouseX >= btnX && mouseX <= btnX + btnW && mouseY >= btnY && mouseY <= btnY + btnH);
}
void mousePressed() {
    if (checkButtonHover()) { 
        captureScreen(); 
        } 
} 
void drawSaveButton() {
    if (checkButtonHover()) { 
        fill(40, 40, 55); stroke(100, 160, 255);
        }
    else {
        fill(20, 20, 28); stroke(60, 60, 80);
        } 
    strokeWeight(1.5);
    rect(btnX, btnY, btnW, btnH, 4);
    fill(220, 220, 240);textSize(16);
    textAlign(CENTER, CENTER);
    text("СОХРАНИТЬ PNG", btnX + btnW / 2, btnY + btnH / 2);
    textAlign(LEFT, BASELINE);
}    
void drawAiTextOverlay() {
    fill(12, 12, 16, 180); 
    noStroke();
    rect(25, height - 75, 450, 55, 4);
    if (aiTextAssociation.equals("ПОТОК")) fill(80, 240, 220);
    else if (aiTextAssociation.equals("ЭКСПРЕССИЯ")) fill(100, 255, 120);
    else if (aiTextAssociation.equals("ТЯЖЕСТЬ")) fill(245, 80, 80);
    else if (aiTextAssociation.equals("КИНЕТИКА")) fill(100, 160, 255);
    else fill(200, 200, 200);textSize(22);
    text("> АНАЛИЗАТОР ИИ: " + aiTextAssociation, 40, height - 40);
} 
void drawUI() {
    fill(0, 160);
    noStroke();
    rect(width - 410, 25, 385, 115, 6);
    fill(255);
    textSize(12);
    text("Статус: " + aiStatus, width - 395, 45);
    text("Изменения: " + changeCounter + " / " + MAX_CHANGES, width - 395, 65);
    text("Глитч: " + aiGlitchIntensity + " | Сдвиг RGB: " + aiShiftAmount, width - 395, 85);
    text("Клавиши [1-4] - Смена фона | [C] - Сбросить ИИ", width - 395, 105);
    text("ИИ Скорость затухания: " + nf(lineFadeSpeed, 1, 1), width - 395, 125);
} 
void captureScreen() {
    isSavingImage = true;
    String filename = "glitch_art_" + year() + nf(month(),2) + nf(day(),2) + "_" + nf(hour(),2) + nf(minute(),2) + nf(second(),2) + ".png";
    saveFrame("output/" + filename);
    println("Картинка сохранена: output/" + filename);
    isSavingImage = false;
}
void keyPressed() {
    if (key == 's' || key == 'S') {
        captureScreen(); 
        } 
    if (key == '1') {
        loadBackgroundByIndex(0); 
        }
    if (key == '2') { loadBackgroundByIndex(1); 
        }
    if (key == '3') { loadBackgroundByIndex(2); 
        } 
    if (key == '4') { loadBackgroundByIndex(3);
        } 
    if (key == 'c' || key == 'с' || key == 'C' || key == 'С') {
        drawLayer.beginDraw();
        drawLayer.clear();
        drawLayer.endDraw();
        background(12, 12, 16);
        aiTextAssociation = "СИНХРОНИЗАЦИЯ";
        changeCounter = 0;
        aiStatus = "Счетчик изменений сброшен (0/4).";
        } 
}