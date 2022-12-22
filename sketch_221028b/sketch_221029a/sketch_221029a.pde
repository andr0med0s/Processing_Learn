// Пример 3-14: Оттенки серого

//size(480, 120);
//smooth();
//background(0); // Черный
//fill(204); // Светло-серый
//ellipse(132, 82, 200, 200); // Светло-серый круг
//fill(153); // Серый
//ellipse(228, -16, 200, 200); // Серый круг
//fill(102); // Темно-серый
//ellipse(268, 118, 200, 200); // Темно-серый круг

// Пример 3-14: Цвета фигур и линий

//size(480, 120);
//smooth();
//fill(153); // Серый
//ellipse(132, 82, 200, 200); // Серый круг
//noFill(); // Выключаем заливку
//ellipse(228, -16, 200, 200); // Контур круга
//noStroke(); // Делаем линии невидимыми, убрана обводка эллипса
////fill(155); // но если добавить заливку отличную от бэкграунда, то эллипс видим
//ellipse(268, 118, 200, 200); // Этот эллипс невидим, потому что значение заливки совпадает 
//                             //со значением цвета фона и выключена обводка

// Пример 3-16: Рисуем цветные фигуры

//size(480, 120);
//noStroke(); // без обводки
//smooth(); // включено сглаживание по умолчанию
//background(0, 26, 51); // Темно-синий цвет , фоновый цвет
//fill(255, 0, 0); // Красный , заливка
//ellipse(132, 82, 200, 200); // Красный круг
//fill(0, 255, 0); // Зеленый
//ellipse(228, -16, 200, 200); // Зеленый круг
//fill(0, 0, 255); // Синий
//ellipse(268, 118, 200, 200); // Синий круг
//// Выберите желаемый цвет, а затем используйте параметры R, G
//// и B для функций background(), fill() и stroke().

// Пример 3-17: Устанавливаем прозрачность

//size(480, 120); // размер окна
//noStroke(); // без обводки
//smooth(); // сглаживание включено
//background(204, 226, 225); // Светло-синий
//fill(255, 0, 0, 160); // Красный
//ellipse(132, 82, 200, 200); // Красный круг
//fill(0, 255, 0, 160); // Зеленый
//ellipse(228, -16, 200, 200); // Зеленый круг
//fill(0, 0, 255, 160); // Синий
//ellipse(268, 118, 200, 200); // Синий круг

// Пример 3-18: Рисуем стрелку

size(480, 120);
beginShape(); //функция сигнализирующяя о начале построения фигуры
vertex(180, 82); //координаты узлов фигуры
vertex(207, 36);
vertex(214, 63);
vertex(407, 11);
vertex(412, 30);
vertex(219, 82);
vertex(226, 109);
endShape(CLOSE); //функция endShape сигнализирует об окончании создания фигуры
                 //параметр CLOSE соединяет начальную точку с конечной
