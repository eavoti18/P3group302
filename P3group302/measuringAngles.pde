class Measuring {

   int[][] hip = {
    // 3 // shoulder - hip - knee
    {ModelUtils.POSE_LEFT_SHOULDER_INDEX, ModelUtils.POSE_LEFT_HIP_INDEX, ModelUtils.POSE_LEFT_KNEE_INDEX}, 
    {ModelUtils.POSE_RIGHT_SHOULDER_INDEX, ModelUtils.POSE_RIGHT_HIP_INDEX, ModelUtils.POSE_RIGHT_KNEE_INDEX}, 
  };
  int[][] otherHip = {
    // 5 // knee - hip - other hip
    {ModelUtils.POSE_LEFT_KNEE_INDEX, ModelUtils.POSE_LEFT_HIP_INDEX, ModelUtils.POSE_RIGHT_HIP_INDEX}, 
    {ModelUtils.POSE_RIGHT_KNEE_INDEX, ModelUtils.POSE_RIGHT_HIP_INDEX, ModelUtils.POSE_LEFT_HIP_INDEX}, 
  };
  int[][] knee = {
    // 2 // hip - knee - ankle
    {ModelUtils.POSE_LEFT_HIP_INDEX, ModelUtils.POSE_LEFT_KNEE_INDEX, ModelUtils.POSE_LEFT_ANKLE_INDEX}, 
    {ModelUtils.POSE_RIGHT_HIP_INDEX, ModelUtils.POSE_RIGHT_KNEE_INDEX, ModelUtils.POSE_RIGHT_ANKLE_INDEX}, 
  };
 
  int jointSize = 10;
  int colorRed = 100;
  int colorGreen = 100;
  int colorBlue = 100;
  int colorGray = color(#908F8F);

  void measuringAngles(JSONObject data) {
    if (data != null) {
      JSONArray humans = data.getJSONArray("poses");
      for (int h = 0; h < humans.size(); h++) {
        JSONArray keypoints = humans.getJSONArray(h);
        

        ///// /////  /////  ///// ///// ///// ///// ///// ///// ///// ///// /////
        // H I P (OUTSIDE) (shoulder - hip - knee)
        ///// /////  /////  ///// ///// ///// ///// ///// ///// ///// ///// /////

        for (int r = 0; r < hip.length; r++) {
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

          float cosB = (sq(sideA) + sq(sideC) - sq(sideB)) / (2 * sideA * sideC);
          float angleHip3 = RAD_TO_DEG * acos(cosB);
          int roundAngleHip3 = round(angleHip3);

          fill(#908F8F);

          if (roundAngleHip3 > 85  && roundAngleHip3 < 105) { //green
            for (int i=0; i<255; i++) {
              colorBlue= 100-i;
              colorRed = 100-i;
              colorGreen= 100+i;
              fill(colorRed, colorGreen, colorBlue); 
              noStroke();
            }
          } else if (roundAngleHip3 > 68  && roundAngleHip3 < 85 ) {//yellow
            for (int i=0; i<255; i++) {
              colorBlue= 100-i;
              colorRed= 100+i;
              colorGreen= 100+i;
              fill(colorRed, colorGreen, colorBlue); 
              noStroke();
            }
          } else if (roundAngleHip3 > 0  && roundAngleHip3 < 68) {//red
              fill(255, 0, 60);
              noStroke();
          } else { //neutral
            fill(#908F8F);
          }

          ellipse(bx, by, jointSize, jointSize);
        }


        ///// /////  /////  ///// ///// ///// ///// ///// ///// ///// ///// /////
        // K N E E (hip - knee - ankle)
        ///// /////  /////  ///// ///// ///// ///// ///// ///// ///// ///// /////

        for (int r = 0; r < knee.length; r++) {
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

          float cosB = (sq(sideA) + sq(sideC) - sq(sideB)) / (2 * sideA * sideC);
          float angleKnee2 = RAD_TO_DEG * acos(cosB);
          int roundAngleKnee2 = round(angleKnee2);

          fill(#908F8F);
          
          if (roundAngleKnee2 > 75  && roundAngleKnee2 < 105) { //Green
            for (int i=0; i<255; i++) {
              colorBlue= 100-i;
              colorRed = 100-i;
              colorGreen= 100+i;
              fill(colorRed, colorGreen, colorBlue); 
              noStroke();
            }
          } else if (roundAngleKnee2 > 60  && roundAngleKnee2 < 75) { //yellow
            for (int i=0; i<255; i++) {
              colorBlue= 100-i;
              colorRed= 100+i;
              colorGreen= 100+i;
              fill(colorRed, colorGreen, colorBlue); 
              noStroke();
            }
          } else if (roundAngleKnee2 > 0  && roundAngleKnee2 < 60) { //red
              fill(255, 60, 0); 
              noStroke();
          } else { //neutral
            fill(#908F8F);
          }
          //circle on joints
          ellipse(bx, by, jointSize, jointSize);
        }
      }
    }
  }
}
