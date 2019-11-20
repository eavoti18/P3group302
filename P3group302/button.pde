color rectColor;
  
class Button {

  int x1;    //Button's left side x value
  int y1;    //Button's top y value
  int x2;    //Button's right side x value
  int y2;    //Button's bottom y value
  
  //Constructor
  Button (int X1, int X2, int Y1, int Y2) {
    x1 = X1;
    x2 = X2;
    y1 = Y1;
    y2 = Y2;
    
   fill(255,0,0);  
   rect(x1,y1,x2,y2);
   
  }
  
  //This function checks if the mouse is clicked inside the button
  boolean clicked() {
    if (key=='w' ) {
      //&& mouseX > x1 && mouseX < x2 && mouseY > y1 && mouseY < y2
      return true;
    } else {
      return false;
    }
    
  }
  
  boolean rectOver()  {
  if (mouseX >= x1 && mouseX <= x2 && 
      mouseY >= y1 && mouseY <= y2) {

    return true;
  } else {
    return false;
  }
}
}
