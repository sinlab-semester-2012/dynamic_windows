Interactive Walls: Dynamic Windows
==================================

by Carlos Sanchez Witt.

milestone_1_grid
----------------

Requirements:
- Processing 2.0Xb
- Simple-openNI library for processing

Tested on Windows with both 32 and 64-bit installations of the software.

Setup and run:
- Run sketch in full screen mode (Shift+Ctrl+R).
- A grid will appear, these are the flipping pixels (Flipxels).
- Stand in front of kinect until recognized (up to 4 users).
- A window will open in front of your head (default occlusion mode), revealing 
  a mirror image of what the Kinect sees (full color image).

Keyboard controls:
- Number keys = toggle occlusion modes (see Flipxel class for details).
- Q,W = decrease, increase Flipxel size.
- A,S = decrease, increase Flipxel active radius (max radial distance to user).
- Y,X = decrease, increase Flipxel active distance (max Z distance to user).
- P = perspective mode.
- O = orthographic mode.

Works on any resolution, 4:3 aspect ratio.