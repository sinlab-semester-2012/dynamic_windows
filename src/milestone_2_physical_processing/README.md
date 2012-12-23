Interactive Walls: Dynamic Windows
==================================

by Carlos Sanchez Witt.

milestone_2_physical_processing
-------------------------------

Requirements:
- Processing 2.0Xb 32-bit, Serial dll from Processing 1.5.
- Simple-openNI library for Processing.
- milestone_2_physical_arduino must be running.

Setup and run:
- Run sketch in full screen mode (Shift+Ctrl+R).
- 3 virtual tiles will appear, these model the real flipping pixels (Flipxels).
- Stand in front of kinect until recognized (up to 4 users).
- The virtual and physical pixels will align with users line of sight, within 
  a certain distance from the Kinect.

Keyboard controls:
- Y,X = decrease, increase Flipxel active distance (max Z distance to user).
- D,F = toggle between depth image, RGB image.
- P = perspective mode.
- O = orthographic mode.

Works on any resolution, 4:3 aspect ratio.