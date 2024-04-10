size(600, 400);
background(0);
String s = "100,90,32,7,87";

String[] nums = split(s, ",");

int[] vals = int(nums); // преобразование типа

for (int i = 0; i < nums.length; i++) {
    
    // ellipse(i*50, 200, nums[i], nums[i]); // будет ошибка разные типы
    ellipse(i * 50, 200, vals[i], vals[i]); 
}