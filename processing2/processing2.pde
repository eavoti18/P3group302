import oscP5.*;
import netP5.*;
import com.hamoid.*;
import processing.video.*;


OscP5 oscP5Location2;
NetAddress location1;
Movie movie;

String incoming = "false";
boolean playing = false;

//the background image
PImage backgroundImage;
Movie squat;

//images with warnings
//PImage red;
//PImage yellow;
//PImage green;

void setup(){
  backgroundImage = loadImage("Images/endscreen.png");
  //red = loadImage("Images/redWar.PNG");
  //yellow = loadImage("Images/yellowWar.PNG");
  //green = loadImage("Images/greenWar.PNG");
  size(640,480);
  frameRate(30);
//background(0,255,0);

oscP5Location2 = new OscP5(this, 6001);
location1 = new NetAddress("127.0.0.1", 5001);
 
  squat = new Movie(this, "squat2.mp4");
  squat.loop();
}

void draw(){
  image(backgroundImage, 0, 0, width, height);
  
     if(incoming == "false"){
    println("inside false");
  background(0,255,0);
  }
  
  else if(incoming == "true"){
    println("inside true");

  if(playing == true){
    image(backgroundImage, 0, 0, width, height);
    //int sizex = 20;
    //int sizey = 320;
    //int size = 100;
    //image(red, sizex, sizey, size,size);
    //image(yellow, sizex+110, sizey, size,size);
    //image(green, sizex+220, sizey, size,size);
    println("inside keypressed true");
    
  image(movie,20,20, 400, 260);
  
  image(squat,400,20,200,265);
  }
  }
}

void movieEvent(Movie movie){
  println("inside movieEvent");
  movie.read();
}

void oscEvent(OscMessage theOscMessage) {
  String incomingHeader = theOscMessage.get(0).stringValue();
  print("OSC Message Received: " + incomingHeader);
  incoming = "true";
  //background(0,0,255);
}

void keyPressed(){
  if(key == 'y' || key == 'Y') {
  movie= new Movie(this, "interactive0.mp4");
    println("movie is playing");
    playing = true;
    movie.loop();
    movie.speed(0.05);
  }
}

void mouseClicked(){
  if(mouseX > 455 && mouseX < 570 && mouseY > 340 && mouseY < 383){
  exit();
  }
}
