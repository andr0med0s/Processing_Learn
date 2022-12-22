size(480, 120); //Пример 3-13: Установить атрибуты линий
smooth();
strokeWeight(12);
strokeJoin(ROUND); // Скруглить углы
rect(40, 25, 70, 70);
strokeJoin(BEVEL); // Сделать скос на углах
rect(140, 25, 70, 70);
strokeCap(SQUARE); // Концы линий - квадратные
line(270, 25, 340, 95);
strokeCap(ROUND); // Скруглить концы линий
line(350, 25, 420, 95);
