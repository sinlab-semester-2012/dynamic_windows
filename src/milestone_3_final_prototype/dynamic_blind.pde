// class that simulates a motorized window blind on the prototype

class dynamic_blind {
  float x, z;  // XZ position in space (in mm)
  int px;      // X position in screen(in pixels)
  int pxsize;  // virtual size (in pixels)
  int port;    // index of blind, from 0 to 6
  int rnd;     // random number set at initialization, used for "chaotic" occlusion mode.
  
  float angle = 0.0;
  boolean updated = false;
  
  color clr = color(0,0,0,200);

  dynamic_blind(float tx, float tz, int tpx, int ts, int tp) {
    x = tx;
    z = tz;
    px = tpx;
    pxsize = ts;
    port = tp;
    rnd = round(random(3, 19));
  }

  void update(PVector pt, int occ_type) {
    //  case occ_type == 1: // align with user's line of sight
    float tmp_angle = atan2(pt.z - z, x - pt.x);
    
    if(occ_type ==2){ // face the user
        tmp_angle = (tmp_angle + 0.5*PI) % PI;
    } else if(occ_type == 3) { // chaotic controlled behavior
        tmp_angle = (tmp_angle * rnd + rnd * (port+1)) % PI;
    }
    
    angle = tmp_angle;    
    updated = true;
  }
  
  boolean distTest(PVector pt){
    return pt.z < maxDist;
  }

  void display() {
    pushMatrix();
    translate(px, height / 2, 0);
    
    if(!updated) {
      angle = 0.0;
    } else {
      updated = false;
    }
    
    rotateY(angle);

    fill(clr);
    rect(0,0, pxsize, 4*pxsize);
    popMatrix();
  }
}
