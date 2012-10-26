class Flipxel3D {
  int x, y, z;
  int rDist;
  int size;
  float angle = 0.0;
  boolean updated = false;
  

  Flipxel3D(int tx, int ty, int tz, int ts, int trd) {
    x = tx;
    y = ty;
    z = tz;
    size = ts;
    rDist = trd;
  }

  void update(PVector pt, int type) {
    angle = atan2(round(pt.z) - z, x - round(pt.x));
    updated = true;
  }
  
  boolean distTest(PVector pt, int t){
    int mx, my, mz;
    mx = round(pt.x);
    my = round(pt.y);
    mz = round(pt.z);
    int d = round( (float)((maxDist-mz) * rDist) / (float)(maxDist));
    
    boolean open;
    switch(t){
      case 1:
        // inside square
        open = abs(mx-x) < d && abs(my-y) < d;
        break;
      case 2:
        // inside circle
        open = (mx-x)*(mx-x) + (my-y)*(my-y) < d*d;
        break;
      case 3:
        // outside square
        open = abs(mx-x) > d || abs(my-y) > d;
        break;
      case 4:
        // outside circle
        open = (mx-x)*(mx-x) + (my-y)*(my-y) > d*d;
        break;
      case 5:
        // inside column
        open = abs(mx-x) < d;
        break;
      case 6:
        // inside line
        open = abs(my-y) < d;
        break;
      case 7:
        // outside column
        open = abs(mx-x) > d;
        break;
      case 8:
        // outside line
        open = abs(my-y) > d;
        break;
      default:
        open =true;
    }
    return open;
  }

  void display() {
    pushMatrix();
    translate(x, y, z);
    
    if(!updated) {
      angle = 0.0;
    } else {
      updated = false;
    }
    
    rotateY(angle);

    fill(100,50,50);
    rect(0,0, size, size);
    popMatrix();
  }
}
