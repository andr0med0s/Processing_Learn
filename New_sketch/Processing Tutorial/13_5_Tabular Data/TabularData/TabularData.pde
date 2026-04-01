size(600, 400);
background(0);
String s = "64, 100, 32, 7, 87, 22";

// Table table =loadTable("data.csv");
Table table =loadTable("data.csv", "header");

TableRow row = table.getRow(0);
// TableRow row = table.getRow(1);

// float x = row.getInt(0);
// float y = row.getInt(1);
// float w = row.getInt(2);
// float h = row.getInt(3);

float x = row.getInt("x");
float y = row.getInt("y");
float w = row.getInt("width");
float h = row.getInt("heigth");

rect(x,y,w,h);