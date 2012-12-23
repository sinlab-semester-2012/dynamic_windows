Interactive Walls: Dynamic Windows
==================================

by Carlos Sanchez Witt.

milestone_2_grid
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
  the depth mal image the Kinect sees.

Keyboard controls:
- Number keys = toggle occlusion modes (see Flipxel class for details).
- Q,W = decrease, increase Flipxel size.
- A,S = decrease, increase Flipxel active radius (max radial distance to user).
- Y,X = decrease, increase Flipxel active distance (max Z distance to user).
- D,F,G,H = toggle between depth image, RGB image, and 2 image backgrounds.
- P = perspective mode.
- O = orthographic mode.

Works on any resolution, 4:3 aspect ratio.