  // P3 >>>>>
  int jointSize = 10;
  int colorRed = 100;
  int colorGreen = 100;
  int colorBlue = 100;
  
   int imageSize=100;
   int imageLoc = 10; 
   
void measuringAngles(JSONObject data){
  // Feedback pictures and strings
  PImage red;
   red = loadImage("Images/redWar.PNG");
  PImage yellow;
   yellow = loadImage("Images/yellowWar.PNG");
  PImage green;
   green = loadImage("Images/greenWar.PNG");
   
   
  if (data != null) {
    JSONArray humans = data.getJSONArray("poses");
    for(int h = 0; h < humans.size(); h++) {
        JSONArray keypoints = humans.getJSONArray(h);
        
        
 ///// /////  /////  ///// ///// ///// ///// ///// ///// ///// ///// /////
 // E L B O W 
 ///// /////  /////  ///// ///// ///// ///// ///// ///// ///// ///// /////
 
        for(int r = 0 ; r < elbow.length; r++){
           JSONArray anglesone = keypoints.getJSONArray(elbow[r][0]);
           JSONArray anglestwo = keypoints.getJSONArray(elbow[r][1]);
           JSONArray anglesthree = keypoints.getJSONArray(elbow[r][2]);
           float ax = anglesone.getFloat(0) * width;
           float ay = anglesone.getFloat(1) * height;
           float bx = anglestwo.getFloat(0) * width;
           float by = anglestwo.getFloat(1) * height;
           float cx = anglesthree.getFloat(0) * width;
           float cy = anglesthree.getFloat(1) * height;
  
  float sideA = dist(bx, by, cx, cy);
  float sideB = dist(cx, cy, ax, ay);
  float sideC = dist(ax, ay, bx, by);
  
  println("side b: " + sideB);
  
   float cosB = (sq(sideA) + sq(sideC) - sq(sideB)) / (2 * sideA * sideC);
 println("cosB: " + cosB);
 
//
// 1 // wrist - elbow - shoulder
//

 float angleElbow1 = RAD_TO_DEG * acos(cosB);
  int roundAngleElbow1 = round(angleElbow1);
 println("angle-elbow: " + roundAngleElbow1);
 fill(#908F8F);
 //textSize(20);
     //text(roundAngleElbow1 + " °", bx, by-15); 
 
 if(roundAngleElbow1 > 110  && roundAngleElbow1 < 130){
   for(int i=0; i<255;i++){
   colorBlue= 100-i;
   colorRed = 100-i;
   colorGreen= 100+i;
 //  println("You might not yet have peformed a squat, try go deeper!");
  fill(colorRed, colorGreen, colorBlue); 
  noStroke();
   }
}

 if(roundAngleElbow1 > 90  && roundAngleElbow1 < 109){
   for(int i=0; i<255;i++){
   colorBlue= 100-i;
   colorRed= 100+i;
   colorGreen= 100+i;
   // println("You are doing it great, try aim for this lenght at every squat");
  fill(colorRed, colorGreen, colorBlue); 
  noStroke();
   }
}
  if(roundAngleElbow1 > 0  && roundAngleElbow1 < 89){
    for(int i=0; i<255; i++){
   colorBlue= 100-i;
   colorRed = 100+i;
   colorGreen = 100-i;
  // println("You might have gone too deep into the squat, try not going so deep!");
  fill(colorRed, colorGreen, colorBlue); 
  noStroke();
    }
} else {
  fill (colorRed, colorGreen, colorBlue);
}

 ellipse(bx, by, jointSize, jointSize);
        }
 
 ///// /////  /////  ///// ///// ///// ///// ///// ///// ///// ///// /////
 // K N E E 
 ///// /////  /////  ///// ///// ///// ///// ///// ///// ///// ///// /////
 
          for(int r = 0 ; r < knee.length; r++){
           JSONArray anglesone = keypoints.getJSONArray(knee[r][0]);
           JSONArray anglestwo = keypoints.getJSONArray(knee[r][1]);
           JSONArray anglesthree = keypoints.getJSONArray(knee[r][2]);
           float ax = anglesone.getFloat(0) * width;
           float ay = anglesone.getFloat(1) * height;
           float bx = anglestwo.getFloat(0) * width;
           float by = anglestwo.getFloat(1) * height;
           float cx = anglesthree.getFloat(0) * width;
           float cy = anglesthree.getFloat(1) * height;
  
  float sideA = dist(bx, by, cx, cy);
  float sideB = dist(cx, cy, ax, ay);
  float sideC = dist(ax, ay, bx, by);
  
  println("side b: " + sideB);
 
 float cosB = (sq(sideA) + sq(sideC) - sq(sideB)) / (2 * sideA * sideC);
 println("cosB: " + cosB);
 
//
// 2 // hip - knee - ankle
//

 float angleKnee2 = RAD_TO_DEG * acos(cosB);
  int roundAngleKnee2 = round(angleKnee2);
 println("angle-knee: " + roundAngleKnee2);
 fill(#908F8F);
 //textSize(20);
     //text(roundAngleKnee2 + " °", bx, by-15);
     
if(roundAngleKnee2 > 110  && roundAngleKnee2 < 130){
   for(int i=0; i<255;i++){
   colorBlue= 100-i;
   colorRed = 100-i;
   colorGreen= 100+i;
 //  println("You might not yet have peformed a squat, try go deeper!");
  fill(colorRed, colorGreen, colorBlue); 
  noStroke();
  image(green, imageLoc, imageLoc, imageSize, imageSize);
   }
}

 if(roundAngleKnee2 > 90  && roundAngleKnee2 < 109){
   for(int i=0; i<255;i++){
   colorBlue= 100-i;
   colorRed= 100+i;
   colorGreen= 100+i;
   // println("You are doing it great, try aim for this lenght at every squat");
  fill(colorRed, colorGreen, colorBlue); 
  noStroke();
  image(yellow, imageLoc, imageLoc, imageSize, imageSize);
   }
}
  if(roundAngleKnee2 > 0  && roundAngleKnee2 < 89){
    for(int i=0; i<255; i++){
   colorBlue= 100-i;
   colorRed = 100+i;
   colorGreen = 100-i;
  // println("You might have gone too deep into the squat, try not going so deep!");
  fill(colorRed, colorGreen, colorBlue); 
  noStroke();
  image(red, imageLoc, imageLoc, imageSize, imageSize);
    }
} else {
  fill (colorRed, colorGreen, colorBlue);
}

 ellipse(bx, by, jointSize, jointSize);
          }

 ///// /////  /////  ///// ///// ///// ///// ///// ///// ///// ///// /////
 // H I P  
 ///// /////  /////  ///// ///// ///// ///// ///// ///// ///// ///// /////

          for(int r = 0 ; r < hip.length; r++){
           JSONArray anglesone = keypoints.getJSONArray(hip[r][0]);
           JSONArray anglestwo = keypoints.getJSONArray(hip[r][1]);
           JSONArray anglesthree = keypoints.getJSONArray(hip[r][2]);
           float ax = anglesone.getFloat(0) * width;
           float ay = anglesone.getFloat(1) * height;
           float bx = anglestwo.getFloat(0) * width;
           float by = anglestwo.getFloat(1) * height;
           float cx = anglesthree.getFloat(0) * width;
           float cy = anglesthree.getFloat(1) * height;
  
  float sideA = dist(bx, by, cx, cy);
  float sideB = dist(cx, cy, ax, ay);
  float sideC = dist(ax, ay, bx, by);
  
  println("side b: " + sideB);
 
 float cosB = (sq(sideA) + sq(sideC) - sq(sideB)) / (2 * sideA * sideC);
 println("cosB: " + cosB);
 
//
// 3 // shoulder - hip - knee
//

 float angleHip3 = RAD_TO_DEG * acos(cosB);
  int roundAngleHip3 = round(angleHip3);
 println("angle-knee: " + roundAngleHip3);
 fill(#908F8F);
 //textSize(20);
 //text(roundAngleHip3 + " °", bx, by-15);
     
 if(roundAngleHip3 > 110  && roundAngleHip3 < 130){
   for(int i=0; i<255;i++){
   colorBlue= 100-i;
   colorRed = 100-i;
   colorGreen= 100+i;
 //  println("You might not yet have peformed a squat, try go deeper!");
  fill(colorRed, colorGreen, colorBlue); 
  noStroke();
   }
}

 if(roundAngleHip3 > 90  && roundAngleHip3 < 109){
   for(int i=0; i<255;i++){
   colorBlue= 100-i;
   colorRed= 100+i;
   colorGreen= 100+i;
   // println("You are doing it great, try aim for this lenght at every squat");
  fill(colorRed, colorGreen, colorBlue); 
  noStroke();
   }
}
  if(roundAngleHip3 > 0  && roundAngleHip3 < 89){
    for(int i=0; i<255; i++){
   colorBlue= 100-i;
   colorRed = 100+i;
   colorGreen = 100-i;
  // println("You might have gone too deep into the squat, try not going so deep!");
  fill(colorRed, colorGreen, colorBlue); 
  noStroke();
    }
} else {
  fill (colorRed, colorGreen, colorBlue);
}

 ellipse(bx, by, jointSize, jointSize);
          }
 
 ///// /////  /////  ///// ///// ///// ///// ///// ///// ///// ///// /////
 // S H O U L D E R   
 ///// /////  /////  ///// ///// ///// ///// ///// ///// ///// ///// /////
 
  
          for(int r = 0 ; r < shoulder.length; r++){
           JSONArray anglesone = keypoints.getJSONArray(shoulder[r][0]);
           JSONArray anglestwo = keypoints.getJSONArray(shoulder[r][1]);
           JSONArray anglesthree = keypoints.getJSONArray(shoulder[r][2]);
           float ax = anglesone.getFloat(0) * width;
           float ay = anglesone.getFloat(1) * height;
           float bx = anglestwo.getFloat(0) * width;
           float by = anglestwo.getFloat(1) * height;
           float cx = anglesthree.getFloat(0) * width;
           float cy = anglesthree.getFloat(1) * height;
  
  float sideA = dist(bx, by, cx, cy);
  float sideB = dist(cx, cy, ax, ay);
  float sideC = dist(ax, ay, bx, by);
  
  println("side b: " + sideB);
 
 float cosB = (sq(sideA) + sq(sideC) - sq(sideB)) / (2 * sideA * sideC);
 println("cosB: " + cosB);
 
//
// 4 // elbow - shoulder - hip
//

 float angleShoulder4 = RAD_TO_DEG * acos(cosB);
  int roundAngleShoulder4 = round(angleShoulder4);
 println("angle-shoulder" + roundAngleShoulder4);
 fill(#908F8F);
 //textSize(20);
 //text(roundAngleShoulder4 + " °", bx, by-15);
 
  if(roundAngleShoulder4 > 110  && roundAngleShoulder4 < 130){
   for(int i=0; i<255;i++){
   colorBlue= 100-i;
   colorRed = 100-i;
   colorGreen= 100+i;
 //  println("You might not yet have peformed a squat, try go deeper!");
  fill(colorRed, colorGreen, colorBlue); 
  noStroke();
   }
}

 if(roundAngleShoulder4 > 90  && roundAngleShoulder4 < 109){
   for(int i=0; i<255;i++){
   colorBlue= 100-i;
   colorRed= 100+i;
   colorGreen= 100+i;
   // println("You are doing it great, try aim for this lenght at every squat");
  fill(colorRed, colorGreen, colorBlue); 
  noStroke();
   }
}
  if(roundAngleShoulder4 > 0  && roundAngleShoulder4 < 89){
    for(int i=0; i<255; i++){
   colorBlue= 100-i;
   colorRed = 100+i;
   colorGreen = 100-i;
  // println("You might have gone too deep into the squat, try not going so deep!");
  fill(colorRed, colorGreen, colorBlue); 
  noStroke();
    }
} else {
  fill (colorRed, colorGreen, colorBlue);
}
 ellipse(bx, by, jointSize, jointSize);
          }
 
 ///// /////  /////  ///// ///// ///// ///// ///// ///// ///// ///// /////
 // H I P    O T H E R  
 ///// /////  /////  ///// ///// ///// ///// ///// ///// ///// ///// /////

           for(int r = 0 ; r < shoulder.length; r++){
           JSONArray anglesone = keypoints.getJSONArray(shoulder[r][0]);
           JSONArray anglestwo = keypoints.getJSONArray(shoulder[r][1]);
           JSONArray anglesthree = keypoints.getJSONArray(shoulder[r][2]);
           float ax = anglesone.getFloat(0) * width;
           float ay = anglesone.getFloat(1) * height;
           float bx = anglestwo.getFloat(0) * width;
           float by = anglestwo.getFloat(1) * height;
           float cx = anglesthree.getFloat(0) * width;
           float cy = anglesthree.getFloat(1) * height;
  
  float sideA = dist(bx, by, cx, cy);
  float sideB = dist(cx, cy, ax, ay);
  float sideC = dist(ax, ay, bx, by);
  
  println("side b: " + sideB);
 
 float cosB = (sq(sideA) + sq(sideC) - sq(sideB)) / (2 * sideA * sideC);
 println("cosB: " + cosB);
 
//
// 5 // knee - hip - other hip 
//

 float angleHip5 = RAD_TO_DEG * acos(cosB);
  int roundAngleHip5 = round(angleHip5);
 println("angle-hip" + roundAngleHip5);
 fill(#908F8F);
 //textSize(20);
 //text(roundAngleHip5 + " °", bx, by-15);
     
   if(roundAngleHip5 > 110  && roundAngleHip5 < 130){
   for(int i=0; i<255;i++){
   colorBlue= 100-i;
   colorRed = 100-i;
   colorGreen= 100+i;
 //  println("You might not yet have peformed a squat, try go deeper!");
  fill(colorRed, colorGreen, colorBlue); 
  noStroke();
   }
}

 if(roundAngleHip5 > 90  && roundAngleHip5 < 109){
   for(int i=0; i<255;i++){
   colorBlue= 100-i;
   colorRed= 100+i;
   colorGreen= 100+i;
   // println("You are doing it great, try aim for this lenght at every squat");
  fill(colorRed, colorGreen, colorBlue); 
  noStroke();
   }
}
  if(roundAngleHip5 > 0  && roundAngleHip5 < 89){
    for(int i=0; i<255; i++){
   colorBlue= 100-i;
   colorRed = 100+i;
   colorGreen = 100-i;
  // println("You might have gone too deep into the squat, try not going so deep!");
  fill(colorRed, colorGreen, colorBlue); 
  noStroke();
    }
} else {
  fill (colorRed, colorGreen, colorBlue);
}
 ellipse(bx, by, jointSize, jointSize);
           }
         }
      }
    }

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
 
 
  /*float cosC = (sq(sideA) + sq(sideB) - sq(sideC)) / (2 * sideA * sideB);
 println("cosC: " + cosC);
 float angleC = RAD_TO_DEG * acos(cosC);
 println("angle C: " + angleC);
 text("angle C: " + angleC, cx, cy-15);
 
 float sum = angleA + angleB + angleC;
 println("Sum of angles: " + sum);*/
 
