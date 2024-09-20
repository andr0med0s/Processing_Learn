String s = "To be or not to be.";
String[] words;
int index = 0;
void setup() {
    size(600, 400);
    background(0);
    String[] lines = loadStrings("hamlet.txt");
    String entireplay = join(lines, " ");
    // printArray(lines);
    printArray(entireplay);
    // words = split(s, " "); //пробел указан в качестве разделителя
    // words = split(entireplay, " "); //пробел указан в качестве разделителя
    words = splitTokens(entireplay, ",.&?!: "); //пробел указан в качестве разделителя
    printArray(words);
    frameRate(5);
    
}

void draw() {
    background(0);
    fill(255);
    textSize(64);
    textAlign(CENTER);
    // text(words[index], 50 + i * 100, 200); 
    // text(words[index], width/2, height/2); 
    text(words[index].toLowerCase(), width/2, height/2); 
    index++;
}


