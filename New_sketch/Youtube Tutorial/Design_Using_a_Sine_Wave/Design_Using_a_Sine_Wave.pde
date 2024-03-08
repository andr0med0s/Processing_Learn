color[] cols = {#F2BBC9, #4971a6, #02732a, #F2BB16, #F27405};

// int count = 10;
int count = 40;// значение плотности волны
// int count = 20;
int area = count * count;
float w, h;
float xa, ya; //x Angle , y angle
float uoff, voff;

float off = 5;

// PVector pos;
PVector[] pos;
float[] sa; //start angle
color[] col;

color bg = #FFF0DC;

void setup() {
    size(800, 800);
    background(255);
    
    // rectMode(CENTER); // при условии float xoff = sin(sa[n] + xa); 
    noStroke();
    
    pos = new PVector[area];
    sa = new float[area];
    col = new color[area];
    
    // fill(0);
    
    w = width / (float)count;
    h = height / (float)count;

    uoff = 1;
    voff = 1;

    
    for (int n = 0; n < area; n++) {
        int i = n % count;
        int j = n / count;
        
        pos[n] = new PVector(i * w, j * h);
        
        // sa[n] = random(TWO_PI);
        // sa[n] = map (i, 0, count, -TWO_PI, TWO_PI); одна из версий анимации версия
        // sa[n] = map (j, 0, count, -TWO_PI, TWO_PI); // направление движения волны
        sa[n] = map(i * j, 0, area, -TWO_PI, TWO_PI); // направление движения волны
        
        float s = sin(i + j);
        // float s = sin(i + j) + cos;
        int ii = (int) map(s, -1,1,0,cols.length);
        ii = constrain(ii, 0, cols.length - 1);
        
        // col[n] = cols[(int)random(cols.length)];
        col[n] = cols[ii];
        
        
    }
    
    
    /* демо
    // for (int i = 0; i < count; i++) {
    //     // for (int j = 0; j < count; j++) {
    //     //     pos = new PVector(i * w, j * h);
    //     //     // rect(pos.x, pos.y, w, h);
    //     //     // text(i, pos.x, pos.y); //строки 
    //     //     // text(j, pos.x, pos.y); // столбцы
    //     //     textAlign(CENTER);
    //     //     text(j, pos.x, pos.y + h / 2); // столбцы
    //     // }
// }
    */
    /* статика
    for (int n = 0; n < area; n++) {
    int i = n % count;
    int j = n / count;
    
    float xoff = sin(xa);
    float yoff = sin(ya);
    
    pos = new PVector(i * w, j * h);
    // text(n + 1, pos.x + w / 2, pos.y + h / 2);
    
    rect(pos.x, pos.y, w, h);
    // circle(pos.x + w / 2, pos.y + h / 2, w);
}
    */
}

void draw() {
    
    background(bg);
    /*
    for (int n = 0; n < area; n++) {
    int i = n % count;
    int j = n / count;
    
    // float xoff = sin(xa); 
    // float yoff = sin(ya);
    *вырезается в цикл
    float xoff = abs(sin(xa)); // добавляем функцию абсолютизации   
    float yoff = abs(sin(ya)); // что бы небыло отрицательных значений
    *
    // xoff = constrain(xoff, 0.3, 0.8); ограничение смещения
    
    // pos = new PVector(i * w, j * h);
    pos[n] = new PVector(i * w, j * h);
    // text(n + 1, pos.x + w / 2, pos.y + h / 2); вырезается в цикл
    
    // rect(pos.x, pos.y, w, h);
    // circle(pos.x + w / 2, pos.y + h / 2, w);
    sa[n] = random(TWO_PI);
    col[n] = cols[(int)random(cols.length)];
    
    * fill(100); вырезается в цикл
    // rect(pos.x + off, pos.y + off, w * xoff, h * yoff);
    
    
    fill(255);
    rect(pos.x, pos.y, w * xoff, h * yoff);
    *
}
    */
    for (int n = 0; n < area; n++) {
        
        float posx = pos[n].x + w / 2;
        float posy = pos[n].y + h / 2;;
        
        xa = map(n, 0, count + uoff, 0.1, PI*uoff+voff);
        xa = map(n, 0, count + voff, 0.1, TWO_PI*voff + uoff);
        
        // float xoff = abs(sin(sa[n] + xa)); // добавляем функцию абсолютизации   
        float xoff = sin(sa[n] + xa);   
        float yoff = abs(sin(sa[n] + ya)); // что бы небыло отрицательных значений
        
        // fill(0);
        // // text(n + 1, pos.x + w / 2, pos.y + h / 2);
        // text(n + 1, posx, posy);
        
        // fill(100); 
        fill(#DED1B6); 
        // rect(pos.x + off, pos.y + off, w * xoff, h * yoff);
        // rect(posx + off, posy + off, w * xoff, h * yoff);
        rect(posx + off, posy + off, w * xoff, h * yoff, 15);
        
        // fill(255);
        fill(col[n]);
        // rect(pos.x, pos.y, w * xoff, h * yoff);
        // rect(posx, posy, w * xoff, h * yoff);
        rect(posx, posy, w * xoff, h * yoff, 15);
    }
    
    // xa += 0.05;
    xa += 0.1;
    ya += 0.01;
    uoff +=0.005;
    voff -=0.001;
}
