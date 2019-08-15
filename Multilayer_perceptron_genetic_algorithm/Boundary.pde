color checkpointColor = color(190, 0, 190), 
  wallColor = color(255);

abstract class Boundary {  

  PVector pv1, pv2;

  Boundary(float x1, float y1, float x2, float y2) {
    this.pv1 = new PVector(x1, y1);
    this.pv2 = new PVector(x2, y2);
  }

  abstract void show();
}

class Wall extends Boundary {

  Wall(float x1, float y1, float x2, float y2) {
    super(x1, y1, x2, y2);
  }

  void show() {
    stroke(wallColor);
    line(pv1.x, pv1.y, pv2.x, pv2.y);
  }
}

class Checkpoint extends Boundary {

  Checkpoint(float x1, float y1, float x2, float y2) {
    super(x1, y1, x2, y2);
  }

  void show() {
    stroke(checkpointColor);
    line(pv1.x, pv1.y, pv2.x, pv2.y);
  }
}
