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

boolean fullScreen=false;

void setup()
{
  size(1024,768,P3D);
  kinectSetup();  

}

void draw()
{
  kinectDraw();
  fill(255);
  int[] userList = context.getUsers();
  //loadPositions();
  if(userList.length>0){
    //println(userList);
    checkPos(userList);
    for(int i=0;i<userList.length;i++){
      println(Rhand[userList[i]].x);
      fill(255);
      ellipse(Rhand[userList[i]].x,Rhand[userList[i]].y,100,100);
      ellipse(Lhand[userList[i]].x,Lhand[userList[i]].y,100,100);
      ellipse(neck[userList[i]].x,neck[userList[i]].y,100,100);
    }
 /* ellipse(Rhand[0].x,Rhand[0].y,100,100);
  ellipse(Rhand[1].x,Rhand[1].y,100,100);
  ellipse(Rhand[2].x,Rhand[2].y,100,100);
  ellipse(Rhand[3].x,Rhand[3].y,100,100);
  */}
}
boolean sketchFullScreen() {
  if(fullScreen) return true;
  else return false;
}
