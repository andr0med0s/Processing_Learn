float x = 0;

void setup() {
    size(600, 400);
}

void draw() {
    background(0);
    stroke(255);
    strokeWeight(4);
    line(x, 0, x, height);
    
    x = x + 10;
    if (x > width) {
        x = 0;
    }
    if (frameCount % 60 == 0) { // % --остаток от деления
    thread("loadData");
    // loadData();
    }
    // loadData();
}

void loadData() {
    println("GOT DATA");
    delay(1000);
}
