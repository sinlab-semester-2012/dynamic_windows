Interactive Walls: Dynamic Windows
==================================

by Carlos Sanchez Witt.

Description
===========

Master Semester Project, SINLAB/LDM, EPFL.

The aim of this project is to experiment with the concept of windows and how 
people act in their presence. By having dynamic windows that react to user 
presence, we can create a new type of interaction with architectural structures.
Furthermore, the binary status of walls and windows is no longer the status 
quo.


Contents
--------

- src: application code (1 sketch per subfolder)
- doc: extra documentation (images, pdfs, etc)

Setup and Dependencies
----------------------

* Virtual simulation requires Kinect for Xbox 360.

* Download and setup:
	- Processing 2.0x (http://processing.org/)
	- simple-openNI (https://code.google.com/p/simple-openni/)
	
* Run the Processing sketch.

Both 32 and 64-bit versions work for the virtual simulation. Physical prototypes
are only supported by 32-bit Processing and require using an older dll for the 
serial library as follows:

* copy: "rxtxSerial.dll"
* from: processing-1.5.1\modes\java\libraries\serial\library\windows32
* to:   processing-2.0xx\modes\java\libraries\serial\library\windows32
  
First physical prototype works with an Arduino 2009.
Final prototype runs using Pololu's Mini Maestro USB Servo Controller and 
receives commands directly from Processing.

Running Instructions
====================

See README inside application code folder.

Development Status
------------------

To Do / Issues
===============
- Create "How-to" summaries for each component on the Wiki page.

Development Journal
===================

Week 1:
- First meeting with Alex, discussion of starting point.
- Brainstorming, 10 ideas presented (see /doc/interactive_walls_10_ideas.png)

Week 2:
- Decided on which idea to focus on.
- Environment setup (Processing).
- 2D simulation of top-view situation, 1D flipxels (lines), mouse serves as 
  user position in YZ plane. Useful to get an initial idea and math formulas 
  working.
  
Week 3:
- 2D simulation of frontal view, 2D flipxeps (squares), mouse serves as user 
  position in XY plane. Useful to visualize grid and implement initial 
  occlusion modes.
- Initial simple-openNI experimentation, registering position of users in 2D 
  plane, converting to screen coordinates and drawing a skeleton.
  
Weeks 4-5:
- 3D simulation of frontal view, integration of Kinect user detection (XY user 
  position). Experimenting with Z position influence in occlusion modes, extra 
  occlusion modes.
- Rewriting of application to allow for multiple users.

Week 6:
- Researched Arduino and thought of how to use it to create a physical
  prototype.
- Application refinement, keyboard control, support for multiple resolutions.

Week 7:
- Current version of virtual simulation (milestone_1_grid) fully working.

Week 8:
- Milestone 1 presentation and demo.
- Received new Arduino, tested it with simple "Hello World"-like application
  (led).

Week 9:
- More Arduino research, documentation needed to interface physical prototype 
  with Processing found.

Week 10:
- First Arduino experiments with servomotor.
- Tried to link with Processing unsuccessfully.

Week 11:
- Managed to link Arduino with Processing (copy serial DLL from 1.5X to 2.0Xb)
- Implemented first Arduino application of a single physical pixel.

Week 12:
- Build first physical prototype consisting of 2 servos/pixels, legos and 
  cardboard.
- First demo video for the second presentation.

Week 13:
- Milestone 2 presentation and demo. Discussion with SinLab members about next
  objectives.
- Refocus of the application: the tiles/pixels are not necessary, a simpler
  implementation based of window blinds (track blinds to be precise) is the next
  objective (simple to build, higher impact on the audience than 2 tiles).
  
Week 14:
- Received new hardware: Pololu Mini Maestro 24-Channel USB Servo Controller.
- Research on new servo controller ("Maestro"), basic Windows installation and 
  first wiring tests. In order to power the servos, required an external power
  supply.
- In order to command servos, sent Mini-SSC protocol commands directly from
  Processing through the right serial port.
- Defined schedule for remaining weeks as follows.
  
Week 15: (Christmas)
- Define functions needed to command multiple servos and test them.
- Sketch the final prototype and determine needed components to build it.
- Try to buy as many components as I can.

Week 16: (New Year)
- Buy any extra components needed and start building.

Week 17: (Final presentation)
- Create video presentation and document all progress in the wiki page.
- Final presentation at la Manufacture.

