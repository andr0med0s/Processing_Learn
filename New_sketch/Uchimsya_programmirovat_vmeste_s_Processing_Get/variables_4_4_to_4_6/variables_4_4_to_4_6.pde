// Символы +, - и * в коде называются операторами. Если вы записываете их
// между двумя значениями, то вы получаете выражение

//size(480, 120); //Пример 4-4: Простая арифметика
//int x = 25;
//int h = 20;
//int y = 25;
//rect(x, y, 300, h); // Верхний
//x = x + 100;
//rect(x, y + h, 300, h); // Средний
//x = x - 250;
//rect(x, y + h*2, 300, h); // Нижний

//size(480, 120);//Пример 4-5: Делаем одно и то же несколько раз
//smooth();
//strokeWeight(8);
//line(20, 40, 80, 80);
//line(80, 40, 140, 80);
//line(140, 40, 200, 80);
//line(200, 40, 260, 80);
//line(260, 40, 320, 80);
//line(320, 40, 380, 80);
//line(380, 40, 440, 80);

// Этот код ниже написан короче используя цикл
//Пока i меньше значения 400 будет выполняться цикл
// Стартует цикл со значения 20
// С каждым шагом значение i увеличивается на 60
// то есть на +60 значений изменяются начальные и конечные 
// координаты линий по оси x

size(480, 120); // Пример 4-6: Используем цикл for
smooth();
strokeWeight(8);
for (int i = 20; i < 400; i += 60) {
line(i, 40, i + 60, 80);
}

/*
Цикл for во многом отличается от кода, который мы писали до сих пор.
Обратите внимание на фигурные скобки - символы { и }. Код, заключенный в
фигурные скобки, называется блоком. Именно этот фрагмент кода будет
повторяться в цикле for.
*/

/*
    Три выражения в скобках, разделенные точкой с запятой, определяют, сколько
    раз будет повторяться блок кода. Эти выражения называются initializaton (init),
    (инициализация), test (проверка) и update (обновление):
    for (init; test; update) {
    statements
    }
    Выражение init обычно объявляет новую переменную для использования в
    цикле for и присваивает ей значение. Как правило, используется переменная с
    именем i, но вы можете использовать любую другую. Test оценивает значение
    переменной, а update изменяет это значение.
*/