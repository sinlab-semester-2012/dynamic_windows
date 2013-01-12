Interactive Walls: Dynamic Windows
==================================

by Carlos Sanchez Witt.

milestone_3_final_prototype
---------------------------

Requirements:
- Processing 2.0Xb 32-bit, Serial dll from Processing 1.5.
- Simple-openNI library for Processing.
- This code works with the final prototype, which uses Kinect and Pololu's
  Mini Maestro Servo Controller.

Setup and run:
- Run sketch in full screen mode (Shift+Ctrl+R).
- 6 virtual blinds will appear, these model the physical ones.
- Stand in front of kinect until recognized, the prototype will react to the
  closest person.

Keyboard controls:
- 1, 2, 3 = switch between the three different interaction modes:
			1 = align with user's line of sight,
			2 = face the user,
			3 = chaotic controlled behavior.
- D, F    = switch between depth image, RGB image.
- P, O    = perspective and orthographic mode (display only).

Works on any resolution, 4:3 aspect ratio (to match Kinect's Image format.)