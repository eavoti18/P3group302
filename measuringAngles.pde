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
  
/*  float cosA = (sq(sideB) + sq(sideC) - sq(sideA)) / (2 * sideB * sideC);
 println("cosA: " + cosA);
 
 float angleA = RAD_TO_DEG * acos(cosA);
  int roundAngleA = round(angleA);
 println("angle A: " + roundAngleA);
 text("angle A: " + roundAngleA, ax, ay-15);*/
 
 float cosB = (sq(sideA) + sq(sideC) - sq(sideB)) / (2 * sideA * sideC);
 println("cosB: " + cosB);
 
 float angleB = RAD_TO_DEG * acos(cosB);
   int roundAngleB = round(angleB);
   
 println("angle B: " + roundAngleB);
 text("angle B: " + roundAngleB, bx, by-15);
 
 if(angleB > 110  && angleB < 180){
  fill(0,255, 0); 
}
else{
 fill(255,0,0); 
}
 
 ellipse(bx, by, 10, 10);

 
/* float cosC = (sq(sideA) + sq(sideB) - sq(sideC)) / (2 * sideA * sideB);
 println("cosC: " + cosC);
 float angleC = RAD_TO_DEG * acos(cosC);
    int roundAngleC = round(angleC);
 println("angle C: " + roundAngleC);
 text("angle C: " + roundAngleC, cx, cy-15);
 
 float sum = angleA + angleB + angleC;
 println("Sum of angles: " + sum);*/
  
          }
    }
  }

}
