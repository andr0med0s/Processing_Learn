//**********************************************************************
// 7 === ВКЛАДКА: UIComponents ===
class Button {
  float x, y, w, h; 
  String text; 
  int baseColor, hoverColor, strokeColor, textColor;

  Button(float x, float y, float w, float h, String text, int bc, int hc, int sc, int tc) {
    this.x = x; this.y = y; this.w = w; this.h = h; this.text = text; 
    this.baseColor = bc; this.hoverColor = hc; this.strokeColor = sc; this.textColor = tc;
  }

  // Проверка наведения курсора мыши на кнопку
  boolean isHovered(float mx, float my) { 
    return (mx >= x && mx <= x + w && my >= y && my <= y + h); 
  }

  void draw(PApplet app) {
    app.fill(isHovered(app.mouseX, app.mouseY) ? hoverColor : baseColor);
    app.stroke(strokeColor); 
    app.strokeWeight(1); 
    app.rect(x, y, w, h, 5);

    // Отрисовка текста строго по центру кнопки
    app.fill(textColor); 
    app.textSize(13); 
    app.textAlign(app.CENTER, app.CENTER);
    app.text(text, x + w / 2, y + h / 2 - 1); 
    
    app.textAlign(app.LEFT, app.BASELINE); // Сброс глобального выравнивания
  }
}

class Toggle {
  float x, y, w, h; 
  String labelPrefix; 
  String[] stateLabels; 
  int currentState = 0; 
  int baseColor, hoverColor, strokeColor, textColor;

  Toggle(float x, float y, float w, float h, String lp, String[] sl, int bc, int hc, int sc, int tc) {
    this.x = x; this.y = y; this.w = w; this.h = h; this.labelPrefix = lp; 
    this.stateLabels = sl; this.baseColor = bc; this.hoverColor = hc; this.strokeColor = sc; this.textColor = tc;
  }

  // Проверка наведения курсора мыши на тогл
  boolean isHovered(float mx, float my) { 
    return (mx >= x && mx <= x + w && my >= y && my <= y + h); 
  }

  // Циклическое переключение состояний тогла
  void toggleState() { 
    currentState = (currentState + 1) % stateLabels.length; 
  }

  void draw(PApplet app) {
    app.fill(isHovered(app.mouseX, app.mouseY) ? hoverColor : baseColor);
    app.stroke(strokeColor); 
    app.strokeWeight(1); 
    app.rect(x, y, w, h, 5);

    // Отрисовка префикса и текущего выбранного состояния
    app.fill(textColor); 
    app.textSize(12); 
    app.textAlign(app.CENTER, app.CENTER);
    app.text(labelPrefix + ": " + stateLabels[currentState], x + w / 2, y + h / 2); 
    
    app.textAlign(app.LEFT, app.BASELINE); // Сброс глобального выравнивания
  }
}
