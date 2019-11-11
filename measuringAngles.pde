void measuringAngles(JSONObject data){
  if (data != null) {
    JSONArray humans = data.getJSONArray("poses");
    for(int h = 0; h < humans.size(); h++) {
        JSONArray keypoints = humans.getJSONArray(h);
        for(int r = 0 ; r < angles.length; r++){
           JSONArray anglesone = keypoints.getJSONArray(angles[r][0]);
           JSONArray anglestwo = keypoints.getJSONArray(angles[r][1]);
           JSONArray anglesthree = keypoints.getJSONArray(angles[r][2]);
           float ax = anglesone.getFloat(0) * width;
           float ay = anglesone.getFloat(1) * height;
           float bx = anglestwo.getFloat(0) * width;
           float by = anglestwo.getFloat(1) * height;
           float cx = anglesthree.getFloat(0) * width;
           float cy = anglesthree.getFloat(1) * height;
  
  float sideA = dist(bx, by, cx, cy);
  float sideB = dist(cx, cy, ax, ay);
  float sideC = dist(ax, ay, bx, by);
  
  println("side a: " + sideA);
  println("side b: " + sideB);
  println("side c: " + sideC);
  
  //Joint color function;
  int jointSize = 10;
  int colorRed = 100;
  int colorGreen = 100;
  int colorBlue = 100;
  
 
 /* float cosA = (sq(sideB) + sq(sideC) - sq(sideA)) / (2 * sideB * sideC);
 println("cosA: " + cosA);
 float angleA = RAD_TO_DEG * acos(cosA);
 println("angle A: " + angleA);
 text("angle A: " + angleA, ax, ay-15);
 
if(angleA<45){
  fill(0,255,0); 
}
else{
 fill(255,0,0); 
}
 
 ellipse(ax, ay, 30, 30);*/

 
 float cosB = (sq(sideA) + sq(sideC) - sq(sideB)) / (2 * sideA * sideC);
 //println("cosB: " + cosB);
 float angleB = RAD_TO_DEG * acos(cosB);
  int roundAngleB = round(angleB);
 //println("angle B: " + roundAngleB);
 //text("angle B: " + roundAngleB, bx, by-15);
 
 //coloring the joints
 if(angleB > 110  && angleB < 130){
   colorBlue= 0;
   colorRed = 0;
   colorGreen++;
  fill(colorRed, colorGreen, colorBlue); 
}
 if(angleB > 90  && angleB < 109){
   colorBlue= 0;
   colorRed ++;
   colorGreen ++;
  fill(colorRed, colorGreen, colorBlue); 
}
  if(angleB > 0  && angleB < 89){
   colorBlue= 0;
   colorRed ++;
   colorGreen --;
  fill(colorRed, colorGreen, colorBlue); 
}
else{
 fill(colorRed,colorGreen, colorBlue); 
}
 ellipse(bx, by, jointSize, jointSize);

 
 /*float cosC = (sq(sideA) + sq(sideB) - sq(sideC)) / (2 * sideA * sideB);
 println("cosC: " + cosC);
 float angleC = RAD_TO_DEG * acos(cosC);
 println("angle C: " + angleC);
 text("angle C: " + angleC, cx, cy-15);
 
 float sum = angleA + angleB + angleC;
 println("Sum of angles: " + sum);*/
  
          }
    }
  }

}
