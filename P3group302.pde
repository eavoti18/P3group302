// code example for drawing lines

// import Runway library
import com.runwayml.*;
// reference to runway instance
RunwayHTTP runway;

// This array will hold all the humans detected
JSONObject data;

// This are the pair of body connections we want to form. 
// Try creating new ones!
int[][] connections = {
  {ModelUtils.POSE_NOSE_INDEX, ModelUtils.POSE_LEFT_EYE_INDEX},
  {ModelUtils.POSE_LEFT_EYE_INDEX, ModelUtils.POSE_LEFT_EAR_INDEX},
  {ModelUtils.POSE_NOSE_INDEX,ModelUtils.POSE_RIGHT_EYE_INDEX},
  {ModelUtils.POSE_RIGHT_EYE_INDEX,ModelUtils.POSE_RIGHT_EAR_INDEX},
  
  // added >>>>>
  {ModelUtils.POSE_LEFT_SHOULDER_INDEX,ModelUtils.POSE_RIGHT_SHOULDER_INDEX},
  {ModelUtils.POSE_LEFT_SHOULDER_INDEX,ModelUtils.POSE_LEFT_HIP_INDEX},
  {ModelUtils.POSE_RIGHT_SHOULDER_INDEX,ModelUtils.POSE_RIGHT_HIP_INDEX},
  {ModelUtils.POSE_LEFT_HIP_INDEX,ModelUtils.POSE_RIGHT_HIP_INDEX},
  // added <<<<<
  
  {ModelUtils.POSE_RIGHT_SHOULDER_INDEX,ModelUtils.POSE_RIGHT_ELBOW_INDEX},
  {ModelUtils.POSE_RIGHT_ELBOW_INDEX,ModelUtils.POSE_RIGHT_WRIST_INDEX},
  {ModelUtils.POSE_LEFT_SHOULDER_INDEX,ModelUtils.POSE_LEFT_ELBOW_INDEX},
  {ModelUtils.POSE_LEFT_ELBOW_INDEX,ModelUtils.POSE_LEFT_WRIST_INDEX}, 
  {ModelUtils.POSE_RIGHT_HIP_INDEX,ModelUtils.POSE_RIGHT_KNEE_INDEX},
  {ModelUtils.POSE_RIGHT_KNEE_INDEX,ModelUtils.POSE_RIGHT_ANKLE_INDEX},
  {ModelUtils.POSE_LEFT_HIP_INDEX,ModelUtils.POSE_LEFT_KNEE_INDEX},
  {ModelUtils.POSE_LEFT_KNEE_INDEX,ModelUtils.POSE_LEFT_ANKLE_INDEX}
};

int[][] angles = {
  {ModelUtils.POSE_LEFT_SHOULDER_INDEX,ModelUtils.POSE_LEFT_ELBOW_INDEX,ModelUtils.POSE_LEFT_WRIST_INDEX},
  {ModelUtils.POSE_RIGHT_SHOULDER_INDEX,ModelUtils.POSE_RIGHT_ELBOW_INDEX,ModelUtils.POSE_RIGHT_WRIST_INDEX}
};

void setup(){
  // match sketch size to default model camera setup
  size(600,400);
  // change default black stroke
  stroke(#E1FF03);
  strokeWeight(3);
  // setup Runway
  runway = new RunwayHTTP(this);
}

void draw(){
  background(0);
  // manually draw PoseNet parts
  drawPoseNetParts(data);
  measuringAngles(data);
}

void drawPoseNetParts(JSONObject data){
  // Only if there are any humans detected
  if (data != null) {
    JSONArray humans = data.getJSONArray("poses");
    for(int h = 0; h < humans.size(); h++) {
      JSONArray keypoints = humans.getJSONArray(h);
      // Now that we have one human, let's draw its body parts
      for(int i = 0 ; i < connections.length; i++){
        
        JSONArray startPart = keypoints.getJSONArray(connections[i][0]);
        JSONArray endPart   = keypoints.getJSONArray(connections[i][1]);
        // extract floats fron JSON array and scale normalized value to sketch size
        float startX = startPart.getFloat(0) * width;
        float startY = startPart.getFloat(1) * height;
        float endX   = endPart.getFloat(0) * width;
        float endY   = endPart.getFloat(1) * height; 
        line(startX,startY,endX,endY);
      }
    }
  }
}

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
  
  float cosA = (sq(sideB) + sq(sideC) - sq(sideA)) / (2 * sideB * sideC);
 println("cosA: " + cosA);
 float angleA = RAD_TO_DEG * acos(cosA);
 println("angle A: " + angleA);
 text("angle A: " + angleA, ax, ay-15);
 
 float cosB = (sq(sideA) + sq(sideC) - sq(sideB)) / (2 * sideA * sideC);
 println("cosB: " + cosB);
 float angleB = RAD_TO_DEG * acos(cosB);
 println("angle B: " + angleB);
 text("angle B: " + angleB, bx, by-15);
 
 float cosC = (sq(sideA) + sq(sideB) - sq(sideC)) / (2 * sideA * sideB);
 println("cosC: " + cosC);
 float angleC = RAD_TO_DEG * acos(cosC);
 println("angle C: " + angleC);
 text("angle C: " + angleC, cx, cy-15);
 
 float sum = angleA + angleB + angleC;
 println("Sum of angles: " + sum);
  
          }
    }
  }

}

// this is called when new Runway data is available
void runwayDataEvent(JSONObject runwayData){
  // point the sketch data to the Runway incoming data 
  data = runwayData;
  
}

// this is called each time Processing connects to Runway
// Runway sends information about the current model
public void runwayInfoEvent(JSONObject info){
  println(info);
}
// if anything goes wrong
public void runwayErrorEvent(String message){
  println(message);
}
