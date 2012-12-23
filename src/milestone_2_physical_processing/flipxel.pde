class Flipxel_Arduino {
  float x, z;	// XZ position in space (in mm)
  int px;       // X position in screen(in pixels)
  int size;	// virtual size (in pixels)
  
  float angle = 0.0;
  boolean updated = false;
  
  color clr = color(0,0,0,200);

  Flipxel_Arduino(float tx, float tz, int tpx, int ts) {
    x = tx;
    z = tz;
    px = tpx;
    size = ts;
  }

  void update(PVector pt) {
    angle = atan2(pt.z - z, x - pt.x);
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
    rect(0,0, size, size);
    popMatrix();
  }
}
