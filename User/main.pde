boolean fullScreen=false;

boolean showDepth=false;
boolean showRGB=false;
boolean showCenterMass=false;
boolean showSkeletons=false;
PFont font;
void setup(){

setupNi();
font = loadFont("SourceSansPro-Black-12.vlw");
textFont(font, 12);
textAlign(CENTER);
if(fullScreen) size(displayWidth, displayHeight);
else size(640, 480);
}

void draw(){
  background(#F0E9DF);
  drawNi();
  noStroke();
  
  int[] userList = context.getUsers();

  if(userList.length>0){
    checkPos(userList);
    for(int i=0;i<userList.length;i++){
      loadPositions(userList[i]);
      println("ok go"+userList.length+" h:"+bodies[userList[i]][1].x);
      
      for(int j=0;j<15;j++){
        fill(#DDCBE1);
        if(j==0) {
          ellipse(bodies[userList[i]][j].x,bodies[userList[i]][j].y-30,65,65);
          fill(0);
          text(j,bodies[userList[i]][j].x,bodies[userList[i]][j].y-26);
        }
        else {
          ellipse(bodies[userList[i]][j].x,bodies[userList[i]][j].y,25,25);
          fill(0);
          text(j,bodies[userList[i]][j].x,bodies[userList[i]][j].y+4);
        }
      }
      //ellipse(bodies[userList[i]][11].x,bodies[userList[i]][11].y,100,100);
     // ellipse(bodies[userList[i]][14].x,bodies[userList[i]][14].y,100,100);
    }
  }
}



void keyPressed()
{
  switch(key)
  {
  case ' ':
    context.setMirror(!context.mirror());
    break;
  case '0':
    showRGB=!showRGB;
    break;
  case '1':
    showDepth=!showDepth;
    break;
    
  case '2':
    showCenterMass=!showCenterMass;
    break;
    
  case '3':
    showSkeletons=!showSkeletons;
    break;
  }
}  


boolean sketchFullScreen() {
  if(fullScreen) return true;
  else return false;
}
