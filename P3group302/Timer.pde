class Timer{
float time;

Timer(float fTime){
time = fTime;
}

float getTime(){
return (time);
}
void setTime(float set){
time = set;
}

void countUp(){
time+=1/frameRate;
}

}
