Interactive Walls: Dynamic Windows
==================================

by Carlos Sanchez Witt.

milestone_2_physical_arduino
----------------------------

Requirements:
- Arduino software, tested on an Arduino 2009 board.
- milestone_2_physical_processing must be running.

Physical setup:
- Servos are meant to be spaced by 16cm (width of physical tiles they control),
  at roughly the same position the Kinect sensor is.
- The 3 servos are controlled through ports 7, 8, and 9.
- Wiring is very similar to this setup (this tutorial was used to get started)
  http://www.instructables.com/id/Overview/

Setup and run:
- Load Arduino sketch to the board. Run Processing sketch to begin.
- Stand in front of kinect until recognized (up to 4 users).
- The virtual and physical pixels will align with users line of sight, within 
  a certain distance from the Kinect.