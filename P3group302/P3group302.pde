//Used to export video file
import com.hamoid.*;
//used for talking to other processing sketch
import netP5.*;
// used to connect to external programs
import oscP5.*;
// import video library
import processing.video.*;
// import Runway library
import com.runwayml.*;
// reference to runway instance
RunwayOSC runway;
//reference to video export instance
VideoExport videoExport;
Movie squat;
//reference to the camera
Capture camera;
PoseNet posenet = new PoseNet();
Measuring measuring = new Measuring();
Timer timer = new Timer(0);
boolean recording = false; //status of recording
// This array will hold all the humans detected
JSONObject data;


// periodically to be updated in RunWay using millis()
int lastMillis;
// takes about 100-200ms for Runway to process a 600x400 PoseNet frame
int waitTime = 210; //210

//state used to change screens in the program
int state = 1;

//the background image
PImage backgroundImage;

void setup() {
  backgroundImage = loadImage("Images/startscreen.png");
  size(640, 480);
  frameRate(45);
  // setup Runway
  runway = new RunwayOSC(this);
  // setup camera
  camera = new Capture(this, 640, 480);
  camera.start();
  // setup timer
  lastMillis = millis();


  noStroke();
  //PATH CAT: "C:/Users/Catharina/Documents/GitHub/P3group302/processing2/data/interactive0.mp4"
  //PATH 
  videoExport = new VideoExport(this, "C:/Users/Catharina/Documents/GitHub/P3group302/processing2/data/interactive0.mp4");
  videoExport.startMovie();
  //Video of pro squatting
  squat = new Movie(this, "squat2.mp4");
  squat.loop();
}

void draw() {
  image(backgroundImage, 0, 0, width, height);

  //changing states
  if (state == 1) { //state 1 is the start screen
    backgroundImage = loadImage("Images/startscreen.png");
  }
  if (state == 2) { //state 2 is the professional video and guide
    backgroundImage = loadImage("Images/profvid.png");
    image(squat, 80, 10, 200, 265);
  }
  if (state == 3) { //state 3 is the exercise part
    backgroundImage = loadImage("Images/record.png");
    //background(0);
    //Show camerafeed
  }

  if (state == 4) {
    //background(255);
    image(camera, 0, 0);
    posenet.drawPoseNetParts(data);
    measuring.measuringAngles(data);

    // update timer
    int currentMillis = millis();
    // if the difference between current millis and last time we checked past the wait time
    if (currentMillis - lastMillis >= waitTime) {
      // call the timed function
      posenet.sendFrameToRunway();
      // update lastMillis, preparing for another wait
      lastMillis = currentMillis;
    }
    if (recording) {
      videoExport.saveFrame();
    }
    timer.countUp();
    println("time counting: " + timer.getTime() + ".");
    if (timer.getTime() >= 20) {
      println("time: " + timer.getTime() +".");
      recording = false;
      videoExport.dispose();
      state = 5;
    }
  }
  if (state == 5) {
    backgroundImage = loadImage("Images/tryagain.png");
  }
}



// this is called when new Runway data is available
void runwayDataEvent(JSONObject runwayData) {
  // point the sketch data to the Runway incoming data 
  data = runwayData;
}

// this is called each time Processing connects to Runway
// Runway sends information about the current model
public void runwayInfoEvent(JSONObject info) {
  println(info);
}
// if anything goes wrong
public void runwayErrorEvent(String message) {
  println("inside error");
  println(message);
}

void movieEvent(Movie m) {
  m.read();
}

void keyPressed() {
  if ( key == 's') {
    recording = false;
    videoExport.dispose();
    state = 5;
  }
}

//Cat will fix buttons to match!

void mouseClicked() {
  //Click on begin it goes to the prof video screen.
  if (state == 1 && mouseX > 455 && mouseX < 570 && mouseY > 344 && mouseY < 390) {
    state = 2;
  }
  //click on I'm ready to go to exercise part
  else if (state == 2 && mouseX > 260 && mouseX < 375 && mouseY > 345 && mouseY < 390) {
    state = 3;
  } else if (state == 3 && mouseX > 287 && mouseX < 400 && mouseY > 342 && mouseY < 385) {
    recording = true;
    state = 4;
  } else if (state == 5 && mouseX > 262 && mouseX < 377 && mouseY > 164 && mouseY < 208) {
    exit();
  } else if (state == 5 && mouseX > 262 && mouseX < 377 && mouseY > 341 && mouseY < 386) {
    state = 2;
  }
}
