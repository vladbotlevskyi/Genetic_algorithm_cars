class Car {

  Perceptron perceptron;

  float angle;
  PVector pos, dir;
  float speed;
  float vlength;
  Ray[] rays;

  int nextCheckpoint;
  int fitness;
  boolean crushed;
  int timeToNextCheckpoint;

  Car(Perceptron perceptron, float xPos, float yPos, float angle, float vlength, int timeToNextCheckpoint) {
    this.perceptron = perceptron;
    this.angle = angle;
    this.pos = new PVector(xPos, yPos);
    this.dir = PVector.fromAngle(angle);
    this.vlength = vlength;
    rays = new Ray[3];
    setRays();
    this.speed = 0;
    this.nextCheckpoint = 0;
    this.fitness = 0;
    this.crushed = false;
    this.timeToNextCheckpoint = timeToNextCheckpoint;
  }

  void setRays() {  
    rays[0] = new Ray(pos.x, pos.y, PVector.fromAngle(-0.8 + angle), vlength);
    rays[1] = new Ray(pos.x, pos.y, PVector.fromAngle(angle), vlength);
    rays[2] = new Ray(pos.x, pos.y, PVector.fromAngle(0.8 + angle), vlength);  
    dir.normalize();
  }

  void updateCarAngle(float angle) {
    this.angle = angle;
    dir = PVector.fromAngle(angle);
    setRays();
  }

  void show(int stroke, int transparencyCar) {
    for (Ray r : rays) {
      r.show(stroke);
    }
    stroke(stroke, transparencyCar);
    noFill();
    strokeWeight(2);
    push();
    translate(pos.x, pos.y);
    PVector pt1 = PVector.fromAngle(-2.1 + angle);
    PVector pt2 = PVector.fromAngle(2.1 + angle);
    triangle(10f * pt1.x, 10f * pt1.y, 10f * pt2.x, 10f * pt2.y, 
      dir.x * 13f, 13f * dir.y);
    pop();
  }

  void moveCarOneStep() {
    pos.set(pos.x + dir.x * speed, pos.y + dir.y * speed);
    setRays();
  }
}
