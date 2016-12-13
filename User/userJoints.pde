PVector[][] bodies = new PVector[8][15];

void loadPositions(int userId){
    PVector trans = new PVector();;
    context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_HEAD,trans);
    context.convertRealWorldToProjective(trans,bodies[userId][0]);        
    
    context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_NECK,trans);
    context.convertRealWorldToProjective(trans,bodies[userId][1]);    
    
    context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_TORSO,trans);
    context.convertRealWorldToProjective(trans,bodies[userId][2]);    
    
    context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_HIP,trans);
    context.convertRealWorldToProjective(trans,bodies[userId][3]);    
    
    context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_KNEE,trans);
    context.convertRealWorldToProjective(trans,bodies[userId][4]);    
    
    context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_FOOT,trans);
    context.convertRealWorldToProjective(trans,bodies[userId][5]);    
    
    context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_HIP,trans);
    context.convertRealWorldToProjective(trans,bodies[userId][6]);    
    
    context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_KNEE,trans);
    context.convertRealWorldToProjective(trans,bodies[userId][7]);    
    
    context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_FOOT,trans);
    context.convertRealWorldToProjective(trans,bodies[userId][8]);    
    
    context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_SHOULDER,trans);
    context.convertRealWorldToProjective(trans,bodies[userId][9]);    
    
    context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_ELBOW,trans);
    context.convertRealWorldToProjective(trans,bodies[userId][10]);    
    
    context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_HAND,trans);
    context.convertRealWorldToProjective(trans,bodies[userId][11]);    
    
    context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_SHOULDER,trans);
    context.convertRealWorldToProjective(trans,bodies[userId][12]);    
    
    context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_ELBOW,trans);
    context.convertRealWorldToProjective(trans,bodies[userId][13]);    
    
    context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_HAND,trans);
    context.convertRealWorldToProjective(trans,bodies[userId][14]);    
    
    if(fullScreen) for(int i=0;i<15;i++){
      bodies[userId][i].x=map(bodies[userId][i].x,0,640,0,displayWidth);
      bodies[userId][i].y=map(bodies[userId][i].y,0,480,0,displayHeight);
    }
}

void checkPos(int[] userList){
  for(int i=0;i<userList.length;i++){
    if(bodies[userList[i]][0]==null) resetPos(userList[i]);
  }
}

void resetPos(int userID){
  for(int i=0;i<15;i++)
    bodies[userID][i]= new PVector(-5000,-5000);
}
