    // === ВКЛАДКА: UIComponents ===

    class Button {
    float x, y, w, h;
    String text;
    int baseColor, hoverColor;
    int strokeColor;
    int textColor;

    Button(float x, float y, float w, float h, String text, int baseColor, int hoverColor, int strokeColor, int textColor) {
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;
        this.text = text;
        this.baseColor = baseColor;
        this.hoverColor = hoverColor;
        this.strokeColor = strokeColor;
        this.textColor = textColor;
    }

    boolean isHovered(float mx, float my) {
        return (mx >= x && mx <= x + w && my >= y && my <= y + h);
    }

    void draw(PApplet app) {
        boolean hover = isHovered(app.mouseX, app.mouseY);
        app.fill(hover ? hoverColor : baseColor);
        app.stroke(strokeColor);
        app.strokeWeight(1);
        app.rect(x, y, w, h, 5);

        app.fill(textColor);
        app.textSize(13);
        app.textAlign(app.CENTER, app.CENTER);
        app.text(text, x + w / 2, y + h / 2 - 1);
        app.textAlign(app.LEFT, app.BASELINE); // Сброс выравнивания
    }
    }

    class Toggle {
    float x, y, w, h;
    String labelPrefix;
    String[] stateLabels;
    int currentState = 0;
    int baseColor, hoverColor, strokeColor, textColor;

    Toggle(float x, float y, float w, float h, String labelPrefix, String[] stateLabels, int baseColor, int hoverColor, int strokeColor, int textColor) {
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;
        this.labelPrefix = labelPrefix;
        this.stateLabels = stateLabels;
        this.baseColor = baseColor;
        this.hoverColor = hoverColor;
        this.strokeColor = strokeColor;
        this.textColor = textColor;
    }

    boolean isHovered(float mx, float my) {
        return (mx >= x && mx <= x + w && my >= y && my <= y + h);
    }

    void toggleState() {
        currentState = (currentState + 1) % stateLabels.length;
    }

    void draw(PApplet app) {
        boolean hover = isHovered(app.mouseX, app.mouseY);
        app.fill(hover ? hoverColor : baseColor);
        app.stroke(strokeColor);
        app.strokeWeight(1);
        app.rect(x, y, w, h, 5);

        app.fill(textColor);
        app.textSize(12);
        app.textAlign(app.CENTER, app.CENTER);
        String fullText = labelPrefix + ": " + stateLabels[currentState];
        app.text(fullText, x + w / 2, y + h / 2);
        app.textAlign(app.LEFT, app.BASELINE); // Сброс выравнивания
    }
}
