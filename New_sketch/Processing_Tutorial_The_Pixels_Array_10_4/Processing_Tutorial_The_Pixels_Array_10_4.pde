size(600, 400);
background(0);

//for(int x = 0; x < width; x++){

//set (x, 200, color(255, 0, 0));
// }
//loadPixels();
//for (int i = 0; i < pixels.length; i++){
//  pixels[i] = color(random(255), 0, random(50, 255));
//}
////pixels[9] = color(255, 0, 0);
//updatePixels();
loadPixels();
for (int x = 0; x < width; x++){
  for(int y = 0; y < height; y++){
    //pixels[x+y*width] = color(0, 255, 0);
        float d = dist(x, y, width/2, height/2);
        //pixels[x+y*width] = color(0, y/2, x/2);
                //pixels[x+y*width] = color(d);
                int index = x+y*width;
                pixels[index] = color(d);
  }
}
updatePixels();
