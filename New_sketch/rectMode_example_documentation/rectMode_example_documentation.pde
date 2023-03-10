/*------------
    Изменяет местоположение, из которого рисуются прямоугольники, 
    изменяя способ, которым параметры задаются rect().
*/
//size(400, 400); 
//rectMode(CORNER);  // rectMode по умолчанию — CORNER.
//fill(255);  //Сделать заливку белой
//rect(100, 100, 200, 200);  // Нарисуйте белый прямоугольник, используя режим CORNER

//rectMode(CORNERS);  // Установите для rectMode значение CORNERS
//fill(100);  // Сделать заливку серой
//rect(100, 100, 200, 200);  //Нарисуйте серый прямоугольник, используя режим CORNERS
size(400, 400);
//rectMode(RADIUS);  // Установите для rectMode значение RADIUS
//fill(255);  // Сделать заливку белой
//rect(200, 200, 120, 120);  //  Нарисуйте белый прямоугольник, используя режим RADIUS 

//rectMode(CENTER);  // Установите для rectMode значение CENTER
//fill(100);  // Сделать заливку серой
//rect(200, 200, 120, 120);  //  Нарисуйте белый прямоугольник, используя режим CENTER 
// Режим по умолчанию — rectMode(CORNER), который интерпретирует первые два параметра 
// rect() как верхний левый угол фигуры, а третий и четвертый параметры — ее ширину и высоту.

// rectMode(CORNERS) интерпретирует первые два параметра rect() как расположение одного угла,
// а третий и четвертый параметры как расположение противоположного угла.

//rectMode(CENTER) интерпретирует первые два параметра rect() как центральную точку фигуры,
//а третий и четвертый параметры — ее ширину и высоту.

//rectMode(RADIUS) также использует первые два параметра rect() в качестве центральной точки фигуры,
//но использует третий и четвертый параметры для указания половины ширины и высоты фигуры.

ellipseMode(RADIUS);
fill(255);
ellipse(200, 200, 120, 120); 

ellipseMode(CENTER);
fill(100);
ellipse(200, 200, 120, 120); 

//ellipseMode(RADIUS);
//fill(50);
//ellipse(200, 200, 60, 60); 
