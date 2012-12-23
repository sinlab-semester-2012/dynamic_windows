//-------------------------------- Kinect --------------------------------//

import SimpleOpenNI.*;

SimpleOpenNI kinect;
boolean autoCalib=true;
int bgType = 0;

float zoomScale;
int newWidth;
int midWidth;

// head tracking
PVector[] userHeads;
int noHeads = 4;

boolean userFound = false;
boolean drawHeads = false;

//-------------------------------- Arduino -------------------------------//

import processing.serial.*;

Serial port;

//---------------------------- Flipxel_Arduino ---------------------------//

Flipxel_Arduino l_flipxel, m_flipxel, r_flipxel;

boolean perspective = true; // for display

float mmDelta = 100;	// 0.1 m
float maxDist = 2000;	// 2 m


//---------------------------- Main Execution ----------------------------//

void setup() {
  size(displayHeight * 4 / 3, displayHeight, P3D);
  stroke(0);
  if (!perspective) {
    ortho();
  }
  rectMode(CENTER);

  // Kinect setup

  kinect = new SimpleOpenNI(this);
  kinect.setMirror(true);

  if (kinect.enableDepth() && kinect.enableRGB() == false) {
    println("Can't open the depthMap or RGB image"); 
    exit(); 
    return;
  }

  // skeleton generation for all joints
  kinect.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL);

  // coordinate mapping to full screen for display
  zoomScale = (float) height / (float)kinect.depthHeight();
  newWidth = round(zoomScale * kinect.depthWidth());
  midWidth = newWidth / 2; // center of the screen

  userHeads = new PVector[noHeads];
  for (int i=0; i<userHeads.length; i++) {
    userHeads[i] = new PVector(0, 0, maxDist+1); // initiate vector of head pos.
  }

  // Arduino setup

  println(Serial.list()); // List COM-ports
  //select second com-port from the list (COM3 for my arduino)
  port = new Serial(this, Serial.list()[0], 19200);

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

  if (drawHeads) drawHeads();

  // Arduino
  orientArduinos();
}

void initFlipxels() {

  l_flipxel = new Flipxel_Arduino(-160, 0, newWidth/6, newWidth/3 - 5);
  m_flipxel = new Flipxel_Arduino(0, 0, newWidth/2, newWidth/3 - 5);
  r_flipxel = new Flipxel_Arduino(160, 0, 5*newWidth/6, newWidth/3 - 5);
}

void orientArduinos() {
  int d = 0;

  // L
  d = min(180, max(0, round(degrees(l_flipxel.angle))));
  port.write(d+"L");

  // M
  d = min(180, max(0, round(degrees(m_flipxel.angle))));
  port.write(d+"M");

  // R
  d = min(180, max(0, round(degrees(r_flipxel.angle))));
  port.write(d+"R");
}

void trackHeads() {
  int[] userList = kinect.getUsers();
  userFound = false;
  int h=0;

  // for each detected user, get head coordinates
  for (int i=0; i < userList.length && h < userHeads.length; i++) {
    if (kinect.isTrackingSkeleton(userList[i])) {
      userFound = true;
      findHead(userList[i], h);
      h++;
    }
  }

  // make sure to "get rid" of preexisting heads;
  while (h < userHeads.length && h < 30) {
    userHeads[h] = null;
    h++;
  }
}

void findHead(int userId, int headInd) {
  // get 3D position of head
  PVector tmpHead = new PVector();
  PVector tmpNeck = new PVector();
  kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_HEAD, tmpHead);
  kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_NECK, tmpNeck);

  PVector tmpEyes = PVector.add(PVector.mult(tmpHead, 0.6), PVector.mult(tmpNeck, 0.4));

  userHeads[headInd] = tmpEyes;
}

void drawHeads() {
  fill(255);
  PVector tmpHeadProj = new PVector();
  PVector tmpHeadScrn = new PVector();

  for (int h=0; h < userHeads.length && userHeads[h] != null; h++) {
    kinect.convertRealWorldToProjective(userHeads[h], tmpHeadProj);

    tmpHeadScrn = new PVector(midWidth + zoomScale*tmpHeadProj.x, zoomScale*tmpHeadProj.y, tmpHeadProj.z);

    ellipse(tmpHeadScrn.x, tmpHeadScrn.y, 20, 20);
  }
}

void drawBackground() {
  switch(bgType) {
  case 1:
    image(kinect.rgbImage(), 0, 0, width, height);
    break;
  default:
  case 0:
    image(kinect.depthImage(), 0, 0, width, height);
    fill(127, 127, 127, 127);
    rect(width/2, height/2, width, height);
    break;
  }
}

void updateFlipxels() {
  for (int h=0; h< userHeads.length && userHeads[h] != null; h++) {
    if(l_flipxel.distTest(userHeads[h])){
      l_flipxel.update(userHeads[h]);
    }
    if(m_flipxel.distTest(userHeads[h])){
      m_flipxel.update(userHeads[h]);
    }
    if(r_flipxel.distTest(userHeads[h])){
      r_flipxel.update(userHeads[h]);
    }
  }
}

void drawFlipxels() {
  l_flipxel.display();
  m_flipxel.display();
  r_flipxel.display();
}

//---------------------------- User Interaction ----------------------------//

void checkKeyboard() {
  if (!keyPressed) return;

  println("key pressed!");
  println(key);

  switch(key) {
    // perspective switch
  case 'p':
  case 'P':
    perspective();
    break;
  case 'o':
  case 'O':
    ortho();
    break;

    // modifiy flipxels
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
  }
}

void flipxelDistance(int sign) {
  if (sign > 0) {
    maxDist = min(maxDist + mmDelta, height);
  } 
  else {
    maxDist = max(maxDist - mmDelta, mmDelta);
  }  
  initFlipxels();
}
//-------------------------- SimpleOpenNI events ----------------------------//

void onNewUser(int userId) {
  //println("onNewUser - userId: " + userId);
  //println("  start pose detection");

  if (autoCalib) {
    kinect.requestCalibrationSkeleton(userId, true);
  } 
  else {
    kinect.startPoseDetection("Psi", userId);
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
    kinect.startPoseDetection("Psi", userId);
  }
}

void onStartPose(String pose, int userId) {
  //println("onStartPose - userId: " + userId + ", pose: " + pose);
  //println(" stop pose detection");

  kinect.stopPoseDetection(userId);
  kinect.requestCalibrationSkeleton(userId, true);
}

void onEndPose(String pose, int userId) {
  //println("onEndPose - userId: " + userId + ", pose: " + pose);
}
//---------------------------- User Interaction ----------------------------//

