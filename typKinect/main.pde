PVector[] head = new PVector[8];
PVector[] neck = new PVector[8];
PVector[] torso = new PVector[8];
PVector[] Lhip = new PVector[8];
PVector[] Lknee = new PVector[8];
PVector[] Lfoot = new PVector[8];
PVector[] Rhip = new PVector[8];
PVector[] Rknee = new PVector[8];
PVector[] Rfoot = new PVector[8];
PVector[] Lshoulder = new PVector[8];
PVector[] Lelbow = new PVector[8];
PVector[] Lhand = new PVector[8];
PVector[] Rshoulder = new PVector[8];
PVector[] Relbow = new PVector[8];
PVector[] Rhand = new PVector[8];
PFont f;
boolean fullScreen=true;
color[]       userClr = new color[]{ color(241,159,14),
                                     color(241,159,14),
                                     color(241,159,14),
                                     color(241,159,14),
                                     color(241,159,14),
                                     color(241,159,14)
                                   };
                                   
void setup()
{ f = loadFont("SourceSansPro-Black-30.vlw");
  textSize(30);
  //f = createFont("SourceSansPro-Black", 25);
  textFont(f);
  textAlign(CENTER, CENTER);
  size(displayWidth,displayHeight,P3D);
  mappingV=displayHeight;
  mappingH=displayHeight*640/480;
  span=(displayWidth-mappingH)/2;
  kinectSetup();  
}

void draw()

{
fill(#F0E9DF,90);
   rect(0,0,width,height);
  kinectDraw();

  int[] userList = context.getUsers();
  //loadPositions();
  if(userList.length>0){
    //println(userList);
    checkPos(userList);
    for(int i=0;i<userList.length;i++){
      /*println(Rhand[userList[i]].x);*/
      fill(userClr[i]);
      text("HAND",Lhand[userList[i]].x,Lhand[userList[i]].y);
      text("HAND",Rhand[userList[i]].x,Rhand[userList[i]].y);
      text("NECK",neck[userList[i]].x,neck[userList[i]].y);
      text("SHOULDER",Lshoulder[userList[i]].x,Lshoulder[userList[i]].y);
      text("SHOULDER",Rshoulder[userList[i]].x,Rshoulder[userList[i]].y);
      text("ELBOW",Relbow[userList[i]].x,Relbow[userList[i]].y);
      text("ELBOW",Lelbow[userList[i]].x,Lelbow[userList[i]].y);
      text("FOOT",Rfoot[userList[i]].x,Rfoot[userList[i]].y);
      text("FOOT",Lfoot[userList[i]].x,Lfoot[userList[i]].y);
      text("KNEE",Rknee[userList[i]].x,Rknee[userList[i]].y);
      text("KNEE",Lknee[userList[i]].x,Lknee[userList[i]].y);
      text("HIP",Rhip[userList[i]].x,Rhip[userList[i]].y);
      text("HIP",Lhip[userList[i]].x,Lhip[userList[i]].y);
      text("TORSO",torso[userList[i]].x,torso[userList[i]].y);
      text("HEAD",torso[userList[i]].x,head[userList[i]].y);
    }
  }
}
boolean sketchFullScreen() {
  if(fullScreen) return true;
  else return false;
}
