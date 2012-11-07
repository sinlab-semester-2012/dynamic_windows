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
========

- src: application code (1 Processing sketch per subfolder)
- doc: extra documentation

Setup and Dependencies
======================

* Requires Kinect for Xbox 360.

* Download and setup:
	- Processing (http://processing.org/)
	- simple-openNI (https://code.google.com/p/simple-openni/)
	
* Run the Processing sketch.

Both 32 and 64-bit versions work for the virtual simulation, further 
integration with a physical prototype might only work with 32-bit versions 
(work in progress.)

Instructions
============

milestone_1_grid
----------------

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

Works on any resolution, expects width > height.
4:3 resolution preferred (to match Kinect's capture.)

Development Status
==================

To Do / Issues
--------------
- Physical prototype.
- Refine occlusion methods, look into what happens when overlaps occur.
- Treat case of people leaving the "screen" (or not, should be done within 
  simple-openNI)
- Current demo requires Processing 2+, interfacing with Arduino might require
  downgrading to 1.5.

Development Journal
-------------------

Week 1:
- First meeting with Alex, discussion of starting point.
- Brainstorming, 10 ideas presented:
https://docs.google.com/drawings/d/1Bdf2ic_uqQch1j4MZ-t4-P2q23K1SHFOxOTZ_wEGIK4/edit

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
- Arduino research, documentation needed to interface physical prototype with 
  Processing found.
- Application refinement, keyboard control, support for multiple resolutions.

Week 7:
- Current version of virtual simulation (milestone_1_grid) fully working.
- Received new Arduino, tested it with simple "Hello World"-like applications.

Week 8:
- Milestone 1 presentation and demo.