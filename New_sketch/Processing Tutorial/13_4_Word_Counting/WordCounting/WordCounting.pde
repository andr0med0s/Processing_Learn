String[] words;

IntDict concordance; //словарь -- список

// int index = 0;
void setup() {
    size(600, 400);
    background(0);
    String[] lines = loadStrings("hamlet.txt");
    String entireplay = join(lines, " ");
    words = splitTokens(entireplay, " ,.!:;"); //пробел указан в качестве разделителя
    concordance = new IntDict();
    
    // concordance.increment("Hello");
    // concordance.increment("goodbye");
    // concordance.increment("Hello");
    // concordance.increment("Hello");
    
    for (int i = 0; i < words.length; i++) {
        // concordance.increment(words[i]);
        concordance.increment(words[i].toLowerCase());
    }
    // println(concordance); 
    concordance.sortValuesReverse();
    println(concordance); 
}

void draw() {
    background(0);
    // fill(255);
    // textSize(64);
    // textAlign(CENTER);
    // text(words[index].toLowerCase(), width/2, height/2); 
    // index++;
    
    String[] keys = concordance.keyArray();
    for (int i = 1000; i < keys.length; i++) {
        int count = concordance.get(keys[i]);
        println(keys[i], count);
    }
    noLoop();
}


