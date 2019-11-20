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

void setup(){
  backgroundImage = loadImage("Images/endscreen.png");
  size(1000,500);
  frameRate(30);
//background(0,255,0);

oscP5Location2 = new OscP5(this, 6001);
location1 = new NetAddress("127.0.0.1", 5001);
 
}

void draw(){
  backgroundImage = loadImage("Images/endscreen.png");
  
     if(incoming == "false"){
    println("inside false");
  background(0,255,0);
  }
  
  else if(incoming == "true"){
    println("inside true");

  if(playing == true){
    println("inside keypressed true");
  image(movie,0,0);
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
