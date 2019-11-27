import oscP5.*;
import netP5.*;
import com.hamoid.*;
import processing.video.*;

Movie movie;

String incoming = "false";
boolean playing = false;

//the background image
PImage backgroundImage;
Movie squat;
PImage resultback;
PImage resultknee;

int state = 1;
float visible;

void setup() {
  backgroundImage = loadImage("Images/resultsbuttonscreen.png");
  resultback = loadImage("Images/resultBack.png");
  resultknee = loadImage("Images/resultKnee.png");
  size(640, 480);
  frameRate(30);

  squat = new Movie(this, "squat2.mp4");
  squat.loop();
}

void draw() {
  
   if(state == 1){
      image(backgroundImage, 0, 0, width, height);
    }
  
  if(state == 2){
     visible= 255;

    image(backgroundImage, 0, 0, width, height);
    image(movie, 20, 20, 400, 260);
    tint(255, visible);
    image(squat, 400, 20, 200, 265);
    
    
    image(resultback, 400, 20, 200, 124);
    


      
 for (int x = 0; x < movie.width; x++ ) {
    for (int y = 0; y < movie.height; y++ ) {
      
      int loc = x + y*movie.width;

      float r = red(movie.pixels [loc]); 
      float g = green(movie.pixels[loc]);
      float b = blue(movie.pixels[loc]);


// checking if the knees red color is present
      if ((r== 255) && (g == 60) && (b==0) ){
        text("Hello :D i am red fo now!", 10, 30);
            image(resultknee, 400, 160, 200, 124);
            
      //movie.speed(2.0);
      }
      // checking if the backs red color is present
      if ((r== 255) && (g == 0) && (b==60) ){
        text("Hello :D i am red fo now!", 10, 30);
            image(resultback, 400, 160, 200, 124);
            visible=0;
      }else{
       visible=100;
      }
    }
    }
  }
}


void movieEvent(Movie movie) {
  movie.read();
}

void mouseClicked() {
  if(state == 1 && mouseX > 250 && mouseX < 385 && mouseY > 210 && mouseY < 262){
  backgroundImage = loadImage("Images/endscreen.png");
  movie= new Movie(this, "interactive0.mp4");
    playing = true;
    movie.loop();
    movie.speed(0.5);
  state = 2;
  }
  else if (state == 2 && mouseX > 455 && mouseX < 570 && mouseY > 340 && mouseY < 383) {
    exit();
  }
}
