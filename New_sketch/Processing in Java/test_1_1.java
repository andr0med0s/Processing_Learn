import processing.core.PApplet;
// import processing.core.*;
public class test_1_1 extends PApplet{
    
    public void setup(){
        fill(120,50,240);
    }

    public void draw(){
        ellipse(width/2,height/2,second(),second());
    }
    
    public void settings(){
        size(300,300);
    }

    public static void main(String[] passedArgs) {
        PApplet.main("test_1_1");
    }

}

