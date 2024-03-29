

class Circl {
    int x;
    int y;
    Circl(int x, int y) {
        this.x = x;
        this.y = y;
    }  
    
    void circl() {
        fill(255, 0, 0);
        ellipse(x, y, 50, 50);
    }
}

void display() {
    int[] x = {50, 100, 150, 200,250,300,350};
    int[] y = {50, 100, 150, 200,250,300,350};


    int index = int(random(x.length));
    int index1 = int(random(y.length));

    for (int i = 0; i < 7; i++) {
        Circl сir = new Circl(x[index], y[index1]);
        сir.circl();
    }
    
}    
