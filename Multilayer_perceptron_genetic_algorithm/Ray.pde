class Ray {

  PVector pos, dir;
  float pvlength;

  Ray(float x, float y, PVector dir, float pvlength) {
    pos = new PVector(x, y);
    setDir(dir);
    this.pvlength = pvlength;
  }

  void setDir(PVector dir) {
    this.dir = dir;
    dir.normalize();
  }

  void lookAt(float x, float y) {
    dir = new PVector(x - pos.x, y - pos.y);
    dir.normalize();
  }

  void show(int ... stroke) {
    if (stroke.length == 1)
      stroke(stroke[0], 100);
    else if (stroke.length > 1)
      stroke(stroke[0], stroke[1]);
    push();
    translate(pos.x, pos.y);
    line(0, 0, dir.x * pvlength, dir.y * pvlength);
    stroke(190, 0, 0);
    strokeWeight(3);
    point(0, 0);
    pop();
  }

  PVector checkOnIntersection(Boundary bound) {
    float x1 = bound.pv1.x, y1 = bound.pv1.y, 
      x2 = bound.pv2.x, y2 = bound.pv2.y;

    float x3 = pos.x, y3 = pos.y, 
      x4 = pos.x + dir.x * pvlength, y4 = pos.y + dir.y * pvlength;

    float den = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4);
    if (den  == 0)
      return null;

    float t = ((x1 - x3) * (y3 - y4) - (y1 - y3) * (x3 - x4)) / den;
    float u = -((x1 - x2) * (y1 - y3) - (y1 - y2) * (x1 - x3)) / den;

    if (t > 0 && t < 1 && u > 0 && u < 1) {
      PVector intersectionPoint = new PVector();
      intersectionPoint.x = x1 + t * (x2 - x1);
      intersectionPoint.y = y1 + t * (y2 - y1);
      return intersectionPoint;
    } else 
    return null;
  }

  float getDistanceToIntersection(PVector intersectionPoint) {
    return sqrt(pow(intersectionPoint.x - pos.x, 2) + pow(intersectionPoint.y - pos.y, 2));
  }

  float getDistanceToClosestPoint(List<PVector> points) throws NullPointerException {  
    float minDistance = Float.POSITIVE_INFINITY;
    boolean flag = true;
    for (PVector pv : points) {
      float dist = getDistanceToIntersection(pv);
      if (minDistance > dist) {
        minDistance = dist;
        flag = false;
      }
    }
    if (flag) {
      throw new NullPointerException();
    }
    return minDistance;
  }
}
