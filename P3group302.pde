String runwayHost = "127.0.0.1";
int runwayPort = 57100;

import oscP5.*;
import netP5.*;

import videoExport;

OscP5 oscP5;
NetAddress myBroadcastLocation;


Button startButton;
  int buttonX = 50;
  int buttonY = 50;
  int buttonW = 100;
  int buttonH = 100;
  
  
 import processing.video.*;
 import com.hamoid.*;

import oscP5.*;
// import video library
import processing.video.*;
// import Runway library
import com.runwayml.*;
// reference to runway instance
RunwayOSC runway;

VideoExport videoExport;
Movie movie;

// This array will hold all the humans detected
JSONObject data;
JSONArray humans;
 
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

  // P3 >>>>>
int[][] elbow = {
  // 1 // shoulder - elbow - wrist
  {ModelUtils.POSE_LEFT_SHOULDER_INDEX,ModelUtils.POSE_LEFT_ELBOW_INDEX,ModelUtils.POSE_LEFT_WRIST_INDEX},
  {ModelUtils.POSE_RIGHT_SHOULDER_INDEX,ModelUtils.POSE_RIGHT_ELBOW_INDEX,ModelUtils.POSE_RIGHT_WRIST_INDEX},
};
int[][] knee = {
  // 2 // hip - knee - ankle
  {ModelUtils.POSE_LEFT_HIP_INDEX, ModelUtils.POSE_LEFT_KNEE_INDEX, ModelUtils.POSE_LEFT_ANKLE_INDEX},
  {ModelUtils.POSE_RIGHT_HIP_INDEX, ModelUtils.POSE_RIGHT_KNEE_INDEX, ModelUtils.POSE_RIGHT_ANKLE_INDEX},
};
int[][] hip = {
  // 3 // shoulder - hip - knee
  {ModelUtils.POSE_LEFT_SHOULDER_INDEX, ModelUtils.POSE_LEFT_HIP_INDEX, ModelUtils.POSE_LEFT_KNEE_INDEX},
  {ModelUtils.POSE_RIGHT_SHOULDER_INDEX, ModelUtils.POSE_RIGHT_HIP_INDEX, ModelUtils.POSE_RIGHT_KNEE_INDEX},
};
int[][] shoulder = {
  // 4 // elbow - shoulder - hip
  {ModelUtils.POSE_LEFT_ELBOW_INDEX, ModelUtils.POSE_LEFT_SHOULDER_INDEX, ModelUtils.POSE_LEFT_HIP_INDEX},
  {ModelUtils.POSE_RIGHT_ELBOW_INDEX, ModelUtils.POSE_RIGHT_SHOULDER_INDEX, ModelUtils.POSE_RIGHT_HIP_INDEX},
};
int[][] otherHip = {
  // 5 // knee - hip - other hip
  {ModelUtils.POSE_LEFT_KNEE_INDEX, ModelUtils.POSE_LEFT_HIP_INDEX, ModelUtils.POSE_RIGHT_HIP_INDEX},
  {ModelUtils.POSE_RIGHT_KNEE_INDEX, ModelUtils.POSE_RIGHT_HIP_INDEX, ModelUtils.POSE_LEFT_HIP_INDEX},
};
  // P3 <<<<<

//reference to the camera
Capture camera;

// periocally to be updated using millis()
int lastMillis;
// how often should the above be updated and a time action take place ?
// takes about 100-200ms for Runway to process a 600x400 PoseNet frame
int waitTime = 210;

//state used to change screens in the program
int state = 1;

//the background image
PImage backgroundImage;

void setup(){
  // match sketch size to default model camera setup
    //background(0);
    size(600,400);
    backgroundImage = loadImage("Images/startscreen.png");
    frameRate(35);
    
    
  // setup Runway
  
  OscProperties properties = new OscProperties();
  properties.setRemoteAddress("127.0.0.1", 57200);
  properties.setListeningPort(57200);
  properties.setDatagramSize(99999999);
  properties.setSRSP(OscProperties.ON);
  oscP5 = new OscP5(this, properties);
  
  myBroadcastLocation = new NetAddress(runwayHost, runwayPort);
  connect();
  
  
  runway = new RunwayOSC(this);
   // setup camera
  camera = new Capture(this,640,480);
  camera.start();
  // setup timer
  lastMillis = millis();
  
  
  startButton = new Button(buttonX, buttonX+buttonW, buttonY, buttonH);
  
  videoExport = new VideoExport(this, "data/camera.mp4");
  videoExport.startMovie();
}

void draw(){
    //background(0);
    image(backgroundImage, 0, 0, width, height);
    
    //changing states
    if(state == 1){ //state 1 is the start screen
      backgroundImage = loadImage("Images/startscreen.png");
    }
    if(state == 2){ //state 2 is the professional video and guide
      backgroundImage = loadImage("Images/profvid.png");
    }
    if(state == 3){ //state 3 is the exercise part
      background(0);
       if (startButton.rectOver()) {
          rectColor = color(200,50,0);
        }
  
        if (startButton.clicked()) {
            background(255);
            image(camera,0,0);
            drawPoseNetParts(data);
            measuringAngles(data);
    
        }

         // update timer
          int currentMillis = millis();
          // if the difference between current millis and last time we checked past the wait time
       if(currentMillis - lastMillis >= waitTime){
          // call the timed function
          sendFrameToRunway();
          // update lastMillis, preparing for another wait
          lastMillis = currentMillis;
        }
      videoExport.saveFrame();
    }
    if(state == 4){ //state 4 is the end screen
      backgroundImage = loadImage("Images/endscreen.png");
    }
  }

  // manually draw PoseNet parts
  
// drawPoseNetParts(data);
// measuringAngles(data);

void keyPressed(){
if(key=='q'){
videoExport.endMovie();
exit();
}
}
 

void sendFrameToRunway(){
  // nothing to send if there's no new camera data available
  if(camera.available() == false){
    return;
  }
  // read a new frame
  camera.read();
  // crop image to Runway input format (600x400)
  PImage image = camera.get(0,0,600,400);
  // query Runway with webcam image 
  runway.query(image);
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

void connect() {
  OscMessage m = new OscMessage("/server/connect");
  oscP5.send(m, myBroadcastLocation);
}

// OSC Event: listens to data coming from Runway
void oscEvent(OscMessage theOscMessage) {
  if (!theOscMessage.addrPattern().equals("/data")) return;
  // The data is in a JSON string, so first we get the string value
  String dataString = theOscMessage.get(0).stringValue();

  // We then parse it as a JSONObject
  data = parseJSONObject(dataString);
}

void mouseClicked(){
  //Click on begin it goes to the prof video screen.
  if(state == 1 && mouseX > 0 && mouseX < width && mouseY > height-100 && mouseY < height){
    state = 2;
  }
  //click on I'm ready to go to exercise part
  else if(state == 2 && mouseX > 0 && mouseX < width && mouseY > height-100 && mouseY < height){
  state = 3;
  }
  //go to end screen (maybe should be changed)
  else if(state == 3 && mouseX > 0 && mouseX < width && mouseY > height-100 && mouseY < height){
  state = 4;
  }
  //go from end screen to start screen
  else if(state == 4 && mouseX > 0 && mouseX < width/2 && mouseY > 300 && mouseY < height){
  state = 1;
  }
  //exit program
  else if(state == 4 && mouseX > width/2 && mouseX < width && mouseY > 300 && mouseY < height){
  exit();
  }
}
