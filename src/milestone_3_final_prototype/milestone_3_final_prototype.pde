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

//-------------------------------- Serial -------------------------------//

import processing.serial.*;
Serial port;

//---------------------------- Dynamic Window ---------------------------//

dynamic_blind[] blinds;

boolean perspective = true; // for display
int occlusion_type = 1;

float mmDelta = 100;  // 0.1 m
float maxDist = 2200;  // 2 m


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

  // Serial setup

  println(Serial.list());
  //COM4 = serial port of maestro servo controller
  port = new Serial(this, "COM4", 9600);

  // Blinds setup
  initBlinds();
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

  // update blinds
  updateBlinds();
  drawBlinds();
  orientBlinds();
}

//---------------------------- Blinds operations ----------------------------//

void initBlinds() {
  blinds = new dynamic_blind[6];
  
  // initialize virtual blinds, real space positions are measured on the physical prototype 
  blinds[0] = new dynamic_blind( 82.5 + 163 + 163, -25, newWidth/12               , newWidth/6,  0);
  blinds[1] = new dynamic_blind( 82.5 + 163      , -25, newWidth/12 +   newWidth/6, newWidth/6,  2);
  blinds[2] = new dynamic_blind( 82.5            , -25, newWidth/12 +   newWidth/3, newWidth/6,  4);
  blinds[3] = new dynamic_blind(-82.5            , -25, newWidth/12 +   newWidth/2, newWidth/6,  6);
  blinds[4] = new dynamic_blind(-82.5 - 165      , -25, newWidth/12 + 2*newWidth/3, newWidth/6,  8);
  blinds[5] = new dynamic_blind(-82.5 - 165 - 163, -25, newWidth/12 + 5*newWidth/6, newWidth/6, 10);
}

void orientBlinds() {
  int angle=0;
  for(int i=0; i<blinds.length; i++){
    angle = angle_to_8bit(blinds[i].angle);
    
    // Mini SSC Protocol:
    //  The Mini SSC protocol is to transmit 0xFF (255 in decimal) as the first (command) byte,
    //  followed by a servo number byte, and then the 8-bit servo target byte.
    byte[] cmd = { byte(0xFF), byte(blinds[i].port), byte(angle) };
    port.write(cmd);
  }
  
  // debug 
  //println("blind0: 8-bit angle = "+angle);
}

int angle_to_8bit(float angle){
  // angle between 0 and PI
  // 8bit value between 0 and 255
  // convert to degrees, clamp in 0:180 range, map to 0:255 range:
  return round(min(180, max(0, round( degrees(angle) ))) * 255 / 180);
}


void updateBlinds() {
  // indentify closest tracked person
  int closest_head = -1;
  float closest_dist = Float.MAX_VALUE;
  for (int h=0; h< userHeads.length && userHeads[h] != null; h++) {
    if(userHeads[h].z < closest_dist){
        closest_dist = userHeads[h].z;
        closest_head = h;
    }
  }
  
  if(closest_head == -1) return;
  
  for(int i=0; i<blinds.length; i++){
    if(blinds[i].distTest(userHeads[closest_head])){
      blinds[i].update(userHeads[closest_head], occlusion_type);
    }
  }
  
  // debug 
  // println("blind0: float angle = "+blinds[0].angle);
}

void drawBlinds() {
  for(int i=0; i<blinds.length; i++){
    blinds[i].display();
  }
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

//void drawHeads() {
//  fill(255);
//  PVector tmpHeadProj = new PVector();
//  PVector tmpHeadScrn = new PVector();
//
//  for (int h=0; h < userHeads.length && userHeads[h] != null; h++) {
//    kinect.convertRealWorldToProjective(userHeads[h], tmpHeadProj);
//
//    tmpHeadScrn = new PVector(midWidth + zoomScale*tmpHeadProj.x, zoomScale*tmpHeadProj.y, tmpHeadProj.z);
//
//    ellipse(tmpHeadScrn.x, tmpHeadScrn.y, 20, 20);
//  }
//}

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

//---------------------------- User Interaction ----------------------------//

void checkKeyboard() {
  if (!keyPressed) return;

  println("key pressed!");
  println(key);

  switch(key) {
    // occlusion type
  case '1':
      occlusion_type = 1;
    break;
  case '2':
      occlusion_type = 2;
    break;
  case '3':
      occlusion_type = 3;
    break;
    
    // perspective switch
  case 'p':
  case 'P':
    perspective();
    break;
  case 'o':
  case 'O':
    ortho();
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
