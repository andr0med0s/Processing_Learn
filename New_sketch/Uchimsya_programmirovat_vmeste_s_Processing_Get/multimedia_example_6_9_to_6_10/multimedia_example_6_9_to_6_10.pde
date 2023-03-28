//---------Пример 6-9: Рисуем фигуры--------

/*
Для загрузки и отображения файла SVG нужно выполнить три шага:
1. Добавьте SVG-файл в папку data.
2. Для хранения векторного файла создайте переменную PShape.
3. Загрузите векторный файл в переменную в помощью функции loadShape().
*/

//PShape network;

//void setup(){
//  size(960, 480);
//  smooth();
//  network = loadShape("network.svg");
//}

//void draw (){
//  background(0);
//  shape(network, 30,10);
//  shape(network, 180, 10, 280, 280);
//}

/*
Параметры функции shape() аналогичны функции image(). Первый параметр
- это название SVG-файла, следующие два устанавливают позицию
изображения в окне. Дополнительные четвертый и пятый параметры
задают длину и ширину изображения.
*/

//-------------Пример 6-10: Масштабирование фигур---------

//PShape network;

//void setup(){
//  size(960, 960);
//  smooth();
//  shapeMode(CENTER);
//  network = loadShape("network.svg");
//}

//void draw(){
//  background(255);
//  float diameter = map(mouseX, 0, width, 10, 960);
//  shape(network, 480, 480, diameter, diameter);
//}

/*
Тип данных для хранения фигур. Перед использованием формы в нее необходимо 
загрузить loadShape() или созданный с помощью createShape(). В shape() функция
используется для рисования фигуры в окне отображения. Обработка в настоящее время
может загружать и отображать SVG (масштабируемую векторную графику) и формы OBJ. 
Файлы OBJ можно открыть только с помощью P3D. В loadShape() функция поддерживает 
SVG-файлы, созданные с помощью Inkscape и Adobe Illustrator. Это не полная реализация
SVG, но предлагает некоторую простую поддержку для обработки векторных данных.

PShape объект содержит группу методов, которые могут работать с данными формы. 
Некоторые из методов перечислены ниже, но полный список, используемый для создания 
и изменения фигур доступно здесь, в обработке Javadoc.

Чтобы создать новую фигуру, используйте createShape(). 
Не используйте синтаксис new PShape().
*/

/*
Конструкторы      PShape(g, kind, params)  

Поля
                  width  Форма ширина документа
                  height  Форма высота документа
Методы
                  isVisible()  Возвращает логическое значение true, 
                  если изображение установлено как видимое, false, если нет
                  
                  setVisible()  Задает видимую или невидимую форму
                  
                  disableStyle()  Отключает данные стиля фигуры и использует
                  стили обработки
                  
                  enableStyle()  Включает данные стиля фигуры и игнорирует 
                  стили обработки
                  
                  beginContour()  Запускает новый контур
                  
                  endContour()  Завершает контур
                  
                  beginShape()  Запускает создание нового PShape
                  
                  endShape()  Завершает создание нового PShape
                  
                  getChildCount()  Возвращает количество дочерних элементов
                  
                  getChild()  Возвращает дочерний элемент фигуры как объект PShape
                  
                  addChild()  Добавляет нового дочернего элемента
                  
                  getVertexCount()  Возвращает общее количество вершин в виде int
                  
                  getVertex()  Возвращает вершину в позиции индекса
                  
                  setVertex()  Устанавливает вершину в положение индекса
                  
                  setFill()  Установите значение заполнения
                  
                  setStroke()  Установите значение штриха
                  
                  translate()  Смещает форму
                  
                  rotateX()  Поворачивает фигуру вокруг оси x
                  
                  rotateY()  Поворачивает фигуру вокруг оси y
                  
                  rotateZ()  Поворачивает фигуру вокруг оси z
                  
                  scale()  Увеличивает и уменьшает размер фигуры
                  
                  resetMatrix()  Заменяет текущую матрицу фигуры на единичную матрицу
*/