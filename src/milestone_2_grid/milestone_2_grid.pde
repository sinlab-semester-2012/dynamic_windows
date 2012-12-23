//-------------------------------- Kinect --------------------------------//

import SimpleOpenNI.*;

SimpleOpenNI kinect;
boolean autoCalib=true;

float zoomScale;
int newWidth;
int midWidth;

// head tracking
PVector[] userHeads;
int noHeads = 4;

boolean userFound = false;
boolean drawHeads = false;
int distType = 1;

//------------------------------- Flipxel3D -------------------------------//

boolean perspective = true; 

Flipxel3D[] flipxels;
int noRows = 36;
int noCols = 64;

// all units in pixels

int pixSize = 30;
int pixDelta = 10;

int pixRadius = 300;
int radDelta = 100;

int maxDist = 3000;
int distDelta = 300;

PImage bg1, bg2;
int bgType = 0;

//---------------------------- Main Execution ----------------------------//

void setup() {
  size(displayHeight * 4 / 3, displayHeight, P3D);
  stroke(0);
  if(!perspective) {
	ortho();
  }
  rectMode(CENTER);
  
  // Kinect setup
  
  kinect = new SimpleOpenNI(this);
  kinect.setMirror(true);
  
  if(kinect.enableDepth() && kinect.enableRGB() == false) {
     println("Can't open the depthMap or RGB image"); 
     exit(); return;
  }
  
  // skeleton generation for all joints
  kinect.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL);
  
  // background images
  bg1 = loadImage("bg1_by_ashensorrow_at_deviantart.jpg");
  bg2 = loadImage("bg2_by_ashensorrow_at_deviantart.jpg");
  
  // coordinate mapping to full screen for display
  zoomScale = (float) height / (float)kinect.depthHeight();
  newWidth = round(zoomScale * kinect.depthWidth());
  midWidth = newWidth / 2; // center of the screen
  
  userHeads = new PVector[noHeads];
  for (int i=0; i<userHeads.length; i++) {
    userHeads[i] = new PVector(0,0,maxDist+1); // initiate vector of head pos.
  }
  
  // Flipxel setup
  
  initFlipxels();
}

void draw() {
  // update the cam
  kinect.update();
  background(0);
  
  // draw background
  drawBackground();
  
  // track head position
  trackHeads();
  
  // check keyboard actions
  checkKeyboard();
  
  // update angles
  updateFlipxels();
  
  // draw flipxels
  drawFlipxels();
  
  if(drawHeads) drawHeads();
}

void initFlipxels() {
  noRows = ceil(height / (float)pixSize);
  noCols = ceil(width / (float)pixSize);
  
  flipxels = new Flipxel3D[noRows*noCols];

  for (int i=0; i<flipxels.length; i++) {
    int r = i % noCols;
    int q = (i - r) / noCols;
    flipxels[i] = new Flipxel3D(round(0.5*pixSize) + pixSize*r, round(0.5*pixSize) + pixSize*q, round(0.5*pixSize), pixSize, pixRadius);
  }
}

void trackHeads() {
  int[] userList = kinect.getUsers();
  userFound = false;
  int h=0;
  
  // for each detected user, get head coordinates
  for(int i=0; i < userList.length && h < userHeads.length; i++) {
    if(kinect.isTrackingSkeleton(userList[i])){
      userFound = true;
      findHead(userList[i], h);
      h++;
    }
  }
  
  // make sure to "get rid" of preexisting heads;
  while(h < userHeads.length && h < 30) {
    userHeads[h] = null;
    h++;
  }
}

void findHead(int userId, int headInd) {
   // get 3D position of head
  PVector tmpHead = new PVector();
  PVector tmpNeck = new PVector();
  kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_HEAD,tmpHead);
  kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_NECK,tmpNeck);
  
  PVector tmpEyes = PVector.add(PVector.mult(tmpHead, 0.6),PVector.mult(tmpNeck, 0.4));

  // convert the detected position to "projective" coordinates
  PVector tmpHeadProj = new PVector();
  kinect.convertRealWorldToProjective(tmpEyes, tmpHeadProj);
  
  userHeads[headInd] = new PVector(zoomScale*tmpHeadProj.x, zoomScale*tmpHeadProj.y, tmpHeadProj.z);
}

void drawHeads() {
  fill(255);
  for(int h=0; h < userHeads.length && userHeads[h] != null; h++){
    ellipse(userHeads[h].x,userHeads[h].y,20,20);
  }
}

void drawBackground() {
  switch(bgType){
      case 1:
        image(kinect.rgbImage(),0,0, width, height);
        break;
	  case 2:
		image(bg1,0,0,width,height);
		break;
	  case 3:
		image(bg2,0,0,width,height);
		break;
      default:
      case 0:
        image(kinect.depthImage(),0,0, width, height);
        fill(127,127,127,127);
        rect(width/2, height/2, width, height);
        break;
  }
}

void updateFlipxels(){
  for (int h=0; h< userHeads.length && userHeads[h] != null; h++) {
    for (int i=0; i<flipxels.length; i++) {
      if(flipxels[i].distTest(userHeads[h], distType)){
        flipxels[i].update(userHeads[h], distType);
      }
    }
  }
}

void drawFlipxels(){
  for (int i=0; i<flipxels.length; i++) {
    flipxels[i].display();
  }
}

//---------------------------- User Interaction ----------------------------//

void checkKeyboard() {
  if(!keyPressed) return;
  
  println("key pressed!");
  println(key);
  
  switch(key){
    // perspective switch
    case 'p':
    case 'P':
      perspective();
      break;
    case 'o':
    case 'O':
      ortho();
      break;
      
    // window type
    case '1':
      distType = 1;
      break;
    case '2':
      distType = 2;
      break;
    case '3':
      distType = 3;
      break;
    case '4':
      distType = 4;
      break;
    case '5':
      distType = 5;
      break;
    case '6':
      distType = 6;
      break;
    case '7':
      distType = 7;
      break;
    case '8':
      distType = 8;
      break;
      
    // modifiy flipxels
    case 'w':
    case 'W':
      flipxelSize(1);
      break;
    case 'q':
    case 'Q':
      flipxelSize(-1);
      break;
    case 's':
    case 'S':
      flipxelRadius(1);
      break;
    case 'a':
    case 'A':
      flipxelRadius(-1);
      break;
    case 'x':
    case 'X':
      flipxelDistance(1);
      break;
    case 'y':
    case 'Y':
      flipxelDistance(-1);
      break;
	  
	  // background
    case 'd':
    case 'D':
      bgType = 0;
      break;
    case 'f':
    case 'F':
      bgType = 1;
      break;
   case 'g':
   case 'G':
     bgType = 2;
     break;
   case 'h':
   case 'H':
     bgType = 3;
     break;
  }
}

void flipxelSize(int sign) {
  if(sign > 0){
    pixSize = min(pixSize + pixDelta, height);
    
  } else {
    pixSize = max(pixSize - pixDelta, pixDelta);    
  }
  
  initFlipxels();
}

void flipxelRadius(int sign) {
  if(sign > 0){
    pixRadius = min(pixRadius + radDelta, height);
    
  } else {
    pixRadius = max(pixRadius - radDelta, radDelta);    
  }  
  initFlipxels();
}

void flipxelDistance(int sign) {
  if(sign > 0){
    maxDist = min(maxDist + distDelta, height);
    
  } else {
    maxDist = max(maxDist - distDelta, distDelta);    
  }  
  initFlipxels();
  
}

//-------------------------- SimpleOpenNI events ----------------------------//

void onNewUser(int userId) {
  //println("onNewUser - userId: " + userId);
  //println("  start pose detection");
  
  if(autoCalib) {
	kinect.requestCalibrationSkeleton(userId,true);
  } else {
	kinect.startPoseDetection("Psi",userId);
  }
}

void onLostUser(int userId) { 
	//println("onLostUser - userId: " + userId); 
}

void onExitUser(int userId) { 
        kinect.stopTrackingSkeleton(userId); // immediately lose focus
	//println("onExitUser - userId: " + userId); 
}

void onReEnterUser(int userId) { 
       kinect.startTrackingSkeleton(userId); // immediately regain focus
	//println("onReEnterUser - userId: " + userId);
}

void onStartCalibration(int userId) { 
	//println("onStartCalibration - userId: " + userId); 
}

void onEndCalibration(int userId, boolean successfull) {
  //println("onEndCalibration - userId: " + userId + ", successfull: " + successfull);
  
  if (successfull) { 
    //println("  User calibrated !!!");
    kinect.startTrackingSkeleton(userId);
  } 
  else { 
    println("  Failed to calibrate user !!!");
    println("  Start pose detection");
    kinect.startPoseDetection("Psi",userId);
  }
}

void onStartPose(String pose,int userId) {
  //println("onStartPose - userId: " + userId + ", pose: " + pose);
  //println(" stop pose detection");
  
  kinect.stopPoseDetection(userId);
  kinect.requestCalibrationSkeleton(userId, true);
 
}

void onEndPose(String pose,int userId) {
//println("onEndPose - userId: " + userId + ", pose: " + pose); 
}
