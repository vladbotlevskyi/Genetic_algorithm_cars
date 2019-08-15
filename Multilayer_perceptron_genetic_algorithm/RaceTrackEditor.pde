boolean editModeOn, cutModeOn;
boolean[] typeOfTrakUpdate;

int cutX1, cutY1;
{
  editModeOn = false;
  cutModeOn = false;
  typeOfTrakUpdate = new boolean[]{true, false, false};
  restoreClickPts();
}

void restoreClickPts() {
  cutX1 = -1;
  cutY1 = -1;
}

void showEditingMode() {
  if (editModeOn) {    

    textSize(20);
    if (cutModeOn) {  
      fill(200, 0, 0);
      text("CUT", 0, 20);
    } else {
      fill(0, 200, 0);
      text("ADD", 0, 20);
    }

    if (mousePressed) {
      if (typeOfTrakUpdate[1]) {
        stroke(checkpointColor);        
        strokeWeight(1);
        line(cutX1, cutY1, mouseX, mouseY);
      } else if (typeOfTrakUpdate[0]) {
        stroke(wallColor);
        strokeWeight(1);
        line(cutX1, cutY1, mouseX, mouseY);
      } else if (typeOfTrakUpdate[2]) {
        Ray ray = new Ray(cutX1, cutY1, new PVector(0, 0), carVectLength);
        ray.lookAt(mouseX, mouseY);
        //ray.getDistanceToIntersection(new PVector(mouseX, mouseY));
        ray.show(255, 255);
      }
    }

    if (typeOfTrakUpdate[1]) {
      fill(255);
      textSize(15);
      for (Checkpoint c : checkpoints) {
        text(checkpoints.indexOf(c), c.pv1.x, c.pv1.y);
        text(checkpoints.indexOf(c), c.pv2.x, c.pv2.y);
      }
    }
  }
}

void addWalls(int x1, int y1, int x2, int y2) {
  walls.add(new Wall(x1, y1, x2, y2));
  writeBoundariesToFile();
  readBoundariesFromFile();
}

void addCheckpoints(int x1, int y1, int x2, int y2) {
  checkpoints.add(new Checkpoint(x1, y1, x2, y2));
  writeBoundariesToFile();
  readBoundariesFromFile();
}

void removeWalls(int x1, int y1, int x2, int y2) {
  Ray r = new Ray(x1, y1, new PVector(0, 0), 0);
  r.lookAt(x2, y2);
  r.pvlength = r.getDistanceToIntersection(new PVector(x2, y2));
  List<Wall> toRemove = new LinkedList<Wall>();
  for (Wall w : walls) {
    PVector intersectionPoint = r.checkOnIntersection(w);
    if (intersectionPoint != null) {
      toRemove.add(w);
    }
  }
  for (Wall w : toRemove) {
    walls.remove(w);
    boundaries.remove(w);
  }
  writeBoundariesToFile();
  readBoundariesFromFile();
}

void removeCheckpoints(int x1, int y1, int x2, int y2) {
  Ray r = new Ray(x1, y1, new PVector(0, 0), 0);
  r.lookAt(x2, y2);
  r.pvlength = r.getDistanceToIntersection(new PVector(x2, y2));
  List<Checkpoint> toRemove = new LinkedList<Checkpoint>();
  for (Checkpoint c : checkpoints) {
    PVector intersectionPoint = r.checkOnIntersection(c);
    if (intersectionPoint != null) {
      toRemove.add(c);
    }
  }
  for (Checkpoint c : toRemove) {
    checkpoints.remove(c);
    boundaries.remove(c);
  }
  writeBoundariesToFile();
  readBoundariesFromFile();
}

void updateCarStartPos(int x1, int y1, int x2, int y2) {
  startPosX = cutX1;
  startPosY = cutY1;
  PVector pv = new PVector(x2 - x1, y2 - y1);
  startAngle = pv.heading();
}

void mousePressed() {
  if (editModeOn && cutX1 < 0 && cutY1 < 0) {
    cutX1 = mouseX;
    cutY1 = mouseY;
  }
}

void mouseReleased() {
  if (editModeOn && cutX1 > 0 && cutY1 > 0) {
    if (typeOfTrakUpdate[2]) {
      updateCarStartPos(cutX1, cutY1, mouseX, mouseY);
    } else if (cutModeOn) {    
      if (typeOfTrakUpdate[1])
        removeCheckpoints(cutX1, cutY1, mouseX, mouseY);
      else if (typeOfTrakUpdate[0])
        removeWalls(cutX1, cutY1, mouseX, mouseY);
    } else {
      if (typeOfTrakUpdate[1])
        addCheckpoints(cutX1, cutY1, mouseX, mouseY);
      else if (typeOfTrakUpdate[0])
        addWalls(cutX1, cutY1, mouseX, mouseY);
    }
    restoreClickPts();
  }
}
