/* --------------------------------------------------------------------------
 * SimpleOpenNI User3d Test
 * --------------------------------------------------------------------------
 * Processing Wrapper for the OpenNI/Kinect 2 library
 * http://code.google.com/p/simple-openni
 * --------------------------------------------------------------------------
 * prog:  Max Rheiner / Interaction Design / Zhdk / http://iad.zhdk.ch/
 * date:  12/12/2012 (m/d/y)
 * ----------------------------------------------------------------------------
 */
 
import SimpleOpenNI.*;


SimpleOpenNI context;
float        zoomF =0.5f;
float        rotX = radians(180);  // by default rotate the hole scene 180deg around the x-axis, 
                                   // the data from openni comes upside down
float        rotY = radians(0);
boolean      autoCalib=true;

PVector      bodyCenter = new PVector();
PVector      bodyDir = new PVector();
PVector      com = new PVector();                                   
PVector      com2d = new PVector();                                   
color[]       userClr = new color[]{ color(255,0,0),
                                     color(0,255,0),
                                     color(0,0,255),
                                     color(255,255,0),
                                     color(255,0,255),
                                     color(0,255,255)
                                   };

void kinectSetup()
{
 context = new SimpleOpenNI(this);
  if(context.isInit() == false)
  {
     println("Can't init SimpleOpenNI, maybe the camera is not connected!"); 
     exit();
     return;  
  }
  context.enableDepth();  // enable depthMap generation 
  context.enableUser();  // enable skeleton generation for all joints

 }

void kinectDraw()
{

  // update the cam
  context.update();
  
  // draw depthImageMap
  image(context.depthImage(),0,0);
  image(context.userImage(),0,0);
  
  // draw the skeleton if it's available
  int[] userList = context.getUsers();
  for(int i=0;i<userList.length;i++)
  {
    if(context.isTrackingSkeleton(userList[i]))
    {
      stroke(userClr[ (userList[i] - 1) % userClr.length ] );
      drawSkeleton(userList[i]);
      loadPositions(userList[i]);
    }      
      
    // draw the center of mass
    if(context.getCoM(userList[i],com))
    {
      context.convertRealWorldToProjective(com,com2d);
      stroke(100,255,0);
      strokeWeight(1);
      beginShape(LINES);
        vertex(com2d.x,com2d.y - 5);
        vertex(com2d.x,com2d.y + 5);

        vertex(com2d.x - 5,com2d.y);
        vertex(com2d.x + 5,com2d.y);
      endShape();
      
      fill(0,255,100);
      text(Integer.toString(userList[i]),com2d.x,com2d.y);
    }
  }    
  // draw the kinect cam
  context.drawCamFrustum();
}

// draw the skeleton with the selected joints
void drawSkeleton(int userId)
{
  strokeWeight(3);

  // to get the 3d joint data
  drawLimb(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);

  drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER);
  drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW);
  drawLimb(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);

  drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
  drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
  drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);

  drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
  drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO);

  drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP);
  drawLimb(userId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE);
  drawLimb(userId, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT);

  drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP);
  drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE);
  drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT);  

  // draw body direction
  getBodyDirection(userId,bodyCenter,bodyDir);
  
  bodyDir.mult(200);  // 200mm length
  bodyDir.add(bodyCenter);
  
  stroke(255,200,200);
  line(bodyCenter.x,bodyCenter.y,bodyCenter.z,
       bodyDir.x ,bodyDir.y,bodyDir.z);

  strokeWeight(1);
}

void drawLimb(int userId,int jointType1,int jointType2)
{
  PVector jointPos1 = new PVector();
  PVector jointPos2 = new PVector();
  float  confidence;
  
  // draw the joint position
  confidence = context.getJointPositionSkeleton(userId,jointType1,jointPos1);
  confidence = context.getJointPositionSkeleton(userId,jointType2,jointPos2);

  stroke(255,0,0,confidence * 200 + 55);
  line(jointPos1.x,jointPos1.y,jointPos1.z,
       jointPos2.x,jointPos2.y,jointPos2.z);
  
  drawJointOrientation(userId,jointType1,jointPos1,50);
}

void drawJointOrientation(int userId,int jointType,PVector pos,float length)
{
  // draw the joint orientation  
  PMatrix3D  orientation = new PMatrix3D();
  float confidence = context.getJointOrientationSkeleton(userId,jointType,orientation);
  if(confidence < 0.001f) 
    // nothing to draw, orientation data is useless
    return;
    
  pushMatrix();
    translate(pos.x,pos.y,pos.z);
    
    // set the local coordsys
    applyMatrix(orientation);
    
    // coordsys lines are 100mm long
    // x - r
    stroke(255,0,0,confidence * 200 + 55);
    line(0,0,0,
         length,0,0);
    // y - g
    stroke(0,255,0,confidence * 200 + 55);
    line(0,0,0,
         0,length,0);
    // z - b    
    stroke(0,0,255,confidence * 200 + 55);
    line(0,0,0,
         0,0,length);
  popMatrix();
}

// -----------------------------------------------------------------
// SimpleOpenNI user events

void onNewUser(SimpleOpenNI curContext,int userId)
{
  println("onNewUser - userId: " + userId);
  println("\tstart tracking skeleton");
  
  context.startTrackingSkeleton(userId);
}

void onLostUser(SimpleOpenNI curContext,int userId)
{
  println("onLostUser - userId: " + userId);
  resetPos(userId);
}

void onVisibleUser(SimpleOpenNI curContext,int userId)
{
  println("onVisibleUser - userId: " + userId);
}


// -----------------------------------------------------------------
// Keyboard events

void keyPressed()
{
  switch(key)
  {
  case ' ':
    context.setMirror(!context.mirror());
    break;
  }
    
  switch(keyCode)
  {
    case LEFT:
      rotY += 0.1f;
      break;
    case RIGHT:
      // zoom out
      rotY -= 0.1f;
      break;
    case UP:
      if(keyEvent.isShiftDown())
        zoomF += 0.01f;
      else
        rotX += 0.1f;
      break;
    case DOWN:
      if(keyEvent.isShiftDown())
      {
        zoomF -= 0.01f;
        if(zoomF < 0.01)
          zoomF = 0.01;
      }
      else
        rotX -= 0.1f;
      break;
  }
}

void getBodyDirection(int userId,PVector centerPoint,PVector dir)
{
  PVector jointL = new PVector();
  PVector jointH = new PVector();
  PVector jointR = new PVector();
  float  confidence;
  
  // draw the joint position
  confidence = context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_SHOULDER,jointL);
  confidence = context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_HEAD,jointH);
  confidence = context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_SHOULDER,jointR);
  
  // take the neck as the center point
  confidence = context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_NECK,centerPoint);
  
  /*  // manually calc the centerPoint
  PVector shoulderDist = PVector.sub(jointL,jointR);
  centerPoint.set(PVector.mult(shoulderDist,.5));
  centerPoint.add(jointR);
  */
  
  PVector up = PVector.sub(jointH,centerPoint);
  PVector left = PVector.sub(jointR,centerPoint);
    
  dir.set(up.cross(left));
  dir.normalize();
}

void loadPositions(int userId){
    context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_HEAD,head[userId]);
    context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_NECK,neck[userId]);
    context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_TORSO,torso[userId]);
    context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_HIP,Lhip[userId]);
    context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_KNEE,Lknee[userId]);
    context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_FOOT,Lfoot[userId]);
    context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_HIP,Rhip[userId]);
    context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_KNEE,Rknee[userId]);
    context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_FOOT,Rfoot[userId]);
    context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_SHOULDER,Lshoulder[userId]);
    context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_ELBOW,Lelbow[userId]);
    context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_HAND,Lhand[userId]);
    context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_SHOULDER,Rshoulder[userId]);
    context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_ELBOW,Relbow[userId]);
    context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_HAND,Rhand[userId]);
    
    head[userId].x=map(head[userId].x, -640, 640, 0, width);
    head[userId].y=map(head[userId].y, -480, 480, height, 0);
    
    neck[userId].x=map(neck[userId].x, -640, 640, 0, width);
    neck[userId].y=map(neck[userId].y, -480, 480, height, 0);
    
    torso[userId].x=map(torso[userId].x, -640, 640, 0, width);
    torso[userId].y=map(torso[userId].y, -480, 480, height, 0);
    
    Lhip[userId].x=map(Lhip[userId].x, -640, 640, 0, width);
    Lhip[userId].y=map(Lhip[userId].y, -480, 480, height, 0);
    
    Lknee[userId].x=map(Lknee[userId].x, -640, 640, 0, width);
    Lknee[userId].y=map(Lknee[userId].y, -480, 480, height, 0);
    
    Lfoot[userId].x=map(Lfoot[userId].x, -640, 640, 0, width);
    Lfoot[userId].y=map(Lfoot[userId].y, -480, 480, height, 0);

    Rhip[userId].x=map(Rhip[userId].x, -640, 640, 0, width);
    Rhip[userId].y=map(Rhip[userId].y, -480, 480, height, 0);

    Rknee[userId].x=map(Rknee[userId].x, -640, 640, 0, width);
    Rknee[userId].y=map(Rknee[userId].y, -480, 480, height, 0);

    Rfoot[userId].x=map(Rfoot[userId].x, -640, 640, 0, width);
    Rfoot[userId].y=map(Rfoot[userId].y, -480, 480, height, 0);

    Lshoulder[userId].x=map(Lshoulder[userId].x, -640, 640, 0, width);
    Lshoulder[userId].y=map(Lshoulder[userId].y, -480, 480, height, 0);

    Lelbow[userId].x=map(Lelbow[userId].x, -640, 640, 0, width);
    Lelbow[userId].y=map(Lelbow[userId].y, -480, 480, height, 0);

    Lhand[userId].x=map(Lhand[userId].x, -640, 640, 0, width);
    Lhand[userId].y=map(Lhand[userId].y, -480, 480, height, 0);
    
    Rshoulder[userId].x=map(Rshoulder[userId].x, -640, 640, 0, width);
    Rshoulder[userId].y=map(Rshoulder[userId].y, -480, 480, height, 0);
    
    Relbow[userId].x=map(Relbow[userId].x, -640, 640, 0, width);
    Relbow[userId].y=map(Relbow[userId].y, -480, 480, height, 0);
        
    Rhand[userId].x=map(Rhand[userId].x, -640, 640, 0, width);
    Rhand[userId].y=map(Rhand[userId].y, -480, 480, height, 0);
    
    
}

void checkPos(int[] userList){
  for(int i=0;i<userList.length;i++){
    if(Rhand[userList[i]]==null) resetPos(userList[i]);
  }  
}

void resetPos(int userID){
  head[userID] = new PVector(-5000,-5000);
  neck[userID] = new PVector(-5000,-5000);
  torso[userID] = new PVector(-5000,-5000);
  Lhip[userID] = new PVector(-5000,-5000);
  Lknee[userID] = new PVector(-5000,-5000);
  Lfoot[userID] = new PVector(-5000,-5000);
  Rhip[userID] = new PVector(-5000,-5000);
  Rknee[userID] = new PVector(-5000,-5000);
  Rfoot[userID] = new PVector(-5000,-5000);
  Lshoulder[userID] = new PVector(-5000,-5000);
  Lelbow[userID] = new PVector(-5000,-5000);
  Lhand[userID] = new PVector(-5000,-5000);
  Rshoulder[userID] = new PVector(-5000,-5000);
  Relbow[userID] = new PVector(-5000,-5000);
  Rhand[userID] = new PVector(-5000,-5000);
}
