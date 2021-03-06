//Used to export video file
import com.hamoid.*;
// used to connect to external programs
import oscP5.*;
// import video library
import processing.video.*;
// import Runway library
import com.runwayml.*;
// importing the sound libary
import processing.sound.*; 
// reference to runway instance
RunwayOSC runway;
//reference to video export instance
VideoExport videoExport;
Movie squat;
//reference to sound
SoundFile startEx;
//reference to the camera
Capture camera;
SoundFile stopSound;
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

Movie movie;
boolean playing = false;
boolean kneeWrong= false;
boolean hipWrong = false;
boolean music;
PImage resultback;
PImage resultknee;

void setup() {
  backgroundImage = loadImage("Images/startscreen.png");
  stopSound=new SoundFile(this, "stopsound.mp3");
  startEx = new SoundFile (this,"guide.mp3" );
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
  videoExport = new VideoExport(this, "data/interactive0.mp4");
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
  if (state == 3) { //state 3 is informing the user that they have 20 seconds to squat
    backgroundImage = loadImage("Images/record.png");
     music=true;
  }

  if (state == 4) { //state 4 is the exercise part
    image(camera, 0, 0);
   
Guide();

 
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
      stopSound.play();
      recording = false;
      videoExport.dispose();
      state = 5;
    }
  }
  if (state == 5) { //state 5 provide the possibility to see results or try again.
    backgroundImage = loadImage("Images/tryagain.png");
  }
  if (state == 6) { //state 6 is the results
    backgroundImage = loadImage("Images/endscreen.png");
    image(movie, 20, 20, 400, 260);
    image(squat, 400, 20, 200, 265);
    resultback = loadImage("Images/resultBack.png");
    resultknee = loadImage("Images/resultKnee.png");

    for (int x = 0; x < movie.width; x++ ) {
      for (int y = 0; y < movie.height; y++ ) {

        int loc = x + y*movie.width;

        float r = red(movie.pixels [loc]); 
        float g = green(movie.pixels[loc]);
        float b = blue(movie.pixels[loc]);

        // checking if the knees red color is present
        if ((r== 255) && (g == 60) && (b==0) ) {
          kneeWrong = true;
        }
        // checking if the backs red color is present
        if ((r== 255) && (g == 0) && (b==60) ) {
          hipWrong = true;
        }
      }
    }
    if (kneeWrong) {
      image(resultknee, 240, 300, 204, 163);
    }
    if (hipWrong) {
      image(resultback, 20, 300, 204, 163);
    }
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
  //Press 's' to stop the recording before the 20 seconds are done
  if ( key == 's') {
    recording = false;
    videoExport.dispose();
    state = 5;
  }
}

void mouseClicked() {
  //Click on begin it goes to the prof video screen.
  if (state == 1 && mouseX > 455 && mouseX < 570 && mouseY > 344 && mouseY < 390) {
    state = 2;
  }
  //click on I'm ready to go to information about how long they have to perform squats
  else if (state == 2 && mouseX > 260 && mouseX < 375 && mouseY > 345 && mouseY < 390) {
    state = 3;
  } 
  //click on record to start recording
  else if (state == 3 && mouseX > 287 && mouseX < 400 && mouseY > 342 && mouseY < 385) {
    recording = true;
    state = 4;
  } 
  //click on results to see the results
  else if (state == 5 && mouseX > 262 && mouseX < 377 && mouseY > 164 && mouseY < 208) {
    movie= new Movie(this, "interactive0.mp4");
    playing = true;
    movie.loop();
    movie.speed(0.5);
    state = 6;
  } 
  //click on try again to go back to state 2 (the guided screen)
  else if (state == 5 && mouseX > 262 && mouseX < 377 && mouseY > 341 && mouseY < 386) {
    state = 2;
  } 
  //click on end to end the program
  else if (state == 6 && mouseX > 475 && mouseX < 590 && mouseY > 340 && mouseY < 383) {
    exit();
  }
}

public void Guide (){
      if( music== true){
    startEx.play();
    music=false;
    }
}
