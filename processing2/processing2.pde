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


void setup() {
  backgroundImage = loadImage("Images/endscreen.png");
  size(640, 480);
  frameRate(30);
  oscP5Location2 = new OscP5(this, 6001);
  location1 = new NetAddress("127.0.0.1", 5001);

  squat = new Movie(this, "squat2.mp4");
  squat.loop();
}

void draw() {
  image(backgroundImage, 0, 0, width, height);

  if (incoming == "false") {
    background(0, 255, 0);
  } else if (incoming == "true") {

    if (playing == true) {
      image(backgroundImage, 0, 0, width, height);

      image(movie, 20, 20, 400, 260);

      image(squat, 400, 20, 200, 265);
      
      
 //for (int x = 0; x < movie.width; x++ ) {
 //   for (int y = 0; y < movie.height; y++ ) {
      
 //     int loc = x + y*movie.width;

 //     float r = red(movie.pixels [loc]); 
 //     float g = green(movie.pixels[loc]);
 //     float b = blue(movie.pixels[loc]);

 //     if ((r>200) && (g <1) && (b<1) ){
 //       text("Hello :D i am red now!", 10, 30);
 //       //delay(1000);
 //     movie.speed(2.0);
 //     }else
 //    movie.speed(1.0);
     
 //     }
 //   }
    }
  }
}

void movieEvent(Movie movie) {
  movie.read();
}

void oscEvent(OscMessage theOscMessage) {
  String incomingHeader = theOscMessage.get(0).stringValue();
  print("OSC Message Received: " + incomingHeader);
  incoming = "true";
}

void keyPressed() {
  if (key == 'y' || key == 'Y') {
    movie= new Movie(this, "interactive0.mp4");
    playing = true;
    movie.loop();
    movie.speed(0.05);
  }
}

void mouseClicked() {
  if (mouseX > 455 && mouseX < 570 && mouseY > 340 && mouseY < 383) {
    exit();
  }
}
