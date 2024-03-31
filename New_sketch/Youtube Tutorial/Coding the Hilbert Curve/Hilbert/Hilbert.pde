// int order = 1;
// int order = 2;
// int order = 3;
// int order = 4;
int order = 6;
// int order = 8;
int N = int(pow(2, order));
int total = N * N;

PVector[] path = new PVector[total];

void setup() {
    size(1024 , 1024);

    colorMode(HSB, 360, 255, 255); // добавление цвета

    background(0);
    
    for (int i = 0; i < total; i++) {
        // PVector v = hilbert(i);
        path[i] = hilbert(i);
        // float len =0.5 * width / N;
        float len = width / N;
        path[i].mult(len);
        path[i].add(len / 2, len / 2);
    }
}

PVector hilbert(int i) {
    PVector[] points = {
        new PVector(0,0),
            new PVector(0,1),
            new PVector(1,1),
            new PVector(1,0)
        };
    
    int index = i & 3;
    PVector v =  points[index]; //вставлено здесь
    for (int j = 1; j < order; j++) {
        i = i >>> 2;
        index = i & 3;
        
        // return points[index];  points[index] взято отсюда
        
        // float len = order;
        // float len = j * 2;
        float len = pow(2, j);
        
        if (index == 0) {
            float temp = v.x;
            v.x = v.y;
            v.y = temp;
        } else if (index == 1) {
            v.y += len;
        } else if (index == 2) {
            v.x += len;
            v.y += len;
        } else if (index == 3) {
            float temp = len - 1 - v.x;
            v.x = len - 1 - v.y;
            v.y = temp;
            v.x += len;
        }
    }
    return v;
}

int counter = 0;
void draw() {
    background(0);
    
    stroke(255);
    strokeWeight(2);
    noFill();
    // beginShape();
    // for (int i = 0; i < path.length; i++) {
    // for (int i = 0; i < counter; i++) {
    // for (int i = 1; i < counter; i++) {
    for (int i = 1; i < total; i++) { // отрисовка целиком

        float h = map(i,0,path.length,0,360);//карта для заливки цветом
        stroke(h,255,255);
        // vertex(path[i].x, path[i].y); //работает с вершинами
        line(path[i].x, path[i].y, path[i-1].x, path[i-1].y); //работает с линиями
    }
    // endShape();
    
    // strokeWeight(4);
    // for (int i = 0; i < path.length; i++) {
    //     point(path[i].x, path[i].y);
    //     text(i,path[i].x + 5,path[i].y);
    // }

    // counter ++;
    counter +=100;
    // if (counter == path.length) {
    if (counter > path.length) {
        counter = 0;
    }
}
