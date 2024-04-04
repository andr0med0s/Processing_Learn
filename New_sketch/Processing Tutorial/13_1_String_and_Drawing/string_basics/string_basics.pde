size(640, 400);
background(0);

println(PFont.list());

// PFont f = createFont("Georgia", 64);
PFont f = createFont("Bauhaus 93", 64);

String s = "To be or not to be.";

textFont(f);
textSize(64);
// textAlign(CENTER);
text(s, 10, 100);
// text(s, width/2, 100); //текст по центру

// text(s.charAt(0), 10, 300); первый символ
// text(s.charAt(3), 10, 300); четвертый символ

float x = 10;
for (int i = 0; i  < s.length(); i++)   {
    // text(s.charAt(3), 10, 300);
    // text(s.charAt(i), 10, 300); // все символы рисуются на одной заданной координате
    char c = s.charAt(i);
    // text(s.charAt(i), x, 300);
    
    // fill(random(255)); // случайная заливка символов
    textSize(random(12,128));// случайный размер символа

    text(c, x, 300);
    // x = x + 32; // растояние между символами
    x = x + textWidth(c); // каждый последующий символ смещяется на величину
                          // ширины предыдущего символа
}