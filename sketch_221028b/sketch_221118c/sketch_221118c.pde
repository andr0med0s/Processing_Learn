// Пример 5-12: Кликаем мышью
/*
Кроме позиции курсора Processing может отслеживать состояние кнопок мыши.
Переменная mousePressed принимает различные значения в зависимости от
того, нажата кнопка мыши или нет. В переменной mousePressed сохраняются
данные типа boolean; это значит, что она принимает два значения: истина
(true) и ложь (false). Когда нажата кнопка мыши, mousePressed принимает
значение истина
*/

/*
void setup() {
  size(240, 120);
  smooth();
  strokeWeight(30);
}
void draw() {
  background(204);
  stroke(102);
  line(40, 0, 70, height);
  if (mousePressed == true) {
    stroke(0);
  }
  line(0, 70, width, 50);
}
*/

/*
В приведенном примере код в блоке if запускается, когда нажата кнопка
мыши. Если кнопка отжата, этот код игнорируется. Как и цикл for, который мы
обсуждали в главе 4, оператор if имеет выражение test, которое оценивается
как ложь или истина:
if (test) {
 statements
}
Если test является истиной, код в блоке запускается; если ложью, код не
запускается. Ваш компьютер вычисляет выражение, заключенное в скобки и
оценивает, является выражение test истиной или ложью. (Если вы хотите
освежить свои знания об операторах сравнения, откройте страницу с
пояснениями к примеру 4-6).
Символ == проверяет, действительно ли равны выражения слева и справа.
Символ == не следует путать с оператором присвоения =. Символ == как бы
спрашивает: “Эти выражения - равны?”, а символ = просто присваивает
значение переменной
*/

// Events(mousePressed, keyPressed)
void setup(){                      // Выполняется раз
  // Set the size of the window
  size(640, 360);
  background(50);
}

void draw() {                      // Выполняется несколько раз
  stroke(255);
  line(pmouseX, pmouseY, mouseX, mouseY);
}

void mousePressed(){               // Событие: Нажата кнопка мыши
 background(50);     // то что должно произойти при нажатии
}

void keyPressed(){                 // Событие: Нажата клавиша
  background(0,255,0); // то что должно произойти при нажатии
}
