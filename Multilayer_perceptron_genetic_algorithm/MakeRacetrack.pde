import java.util.List;
import java.util.ArrayList;
import java.util.LinkedList;

List<Boundary> boundaries;
List<Wall> walls;
List<Checkpoint> checkpoints;
final String wallsFileName = "walls.txt", 
  checkpointsFileName = "checkpoints.txt", 
  boundariesFileName = "boundaries.txt";
final String splitter = ",", characterForWall = "w", characterForCheckp = "c";

void makeRacetrack1() {
  boundaries = new ArrayList<Boundary>();
  walls = new ArrayList<Wall>();
  checkpoints = new ArrayList<Checkpoint>();
  //===out wall=====
  walls.add(new Wall(70, 700, 80, 620));
  walls.add(new Wall(80, 620, 60, 530));
  walls.add(new Wall(60, 530, 160, 430));
  walls.add(new Wall(160, 430, 290, 480));
  walls.add(new Wall(290, 480, 310, 570));
  walls.add(new Wall(310, 570, 280, 670));
  walls.add(new Wall(280, 670, 240, 720));
  walls.add(new Wall(240, 720, 70, 700));
  //=====in wall=====
  walls.add(new Wall(130, 660, 130, 530));
  walls.add(new Wall(130, 530, 191, 500));
  walls.add(new Wall(191, 500, 251, 559));  
  walls.add(new Wall(251, 559, 218, 663));
  walls.add(new Wall(218, 663, 130, 660));

  //====checkpoints=======
  checkpoints.add(new Checkpoint(81, 622, 130, 620));
  checkpoints.add(new Checkpoint(72, 588, 128, 589));
  checkpoints.add(new Checkpoint(65, 551, 130, 555));
  checkpoints.add(new Checkpoint(77, 514, 129, 529));  
  checkpoints.add(new Checkpoint(105, 484, 152, 519));
  checkpoints.add(new Checkpoint(132, 459, 180, 505));
  checkpoints.add(new Checkpoint(191, 499, 179, 438));  
  checkpoints.add(new Checkpoint(201, 510, 222, 454));  
  checkpoints.add(new Checkpoint(222, 530, 255, 462));
  checkpoints.add(new Checkpoint(241, 547, 290, 481));
  checkpoints.add(new Checkpoint(250, 559, 300, 528));
  checkpoints.add(new Checkpoint(246, 572, 310, 569));  
  checkpoints.add(new Checkpoint(241, 591, 300, 600)); 
  checkpoints.add(new Checkpoint(234, 612, 292, 631)); 
  checkpoints.add(new Checkpoint(224, 637, 283, 658)); 
  checkpoints.add(new Checkpoint(217, 662, 258, 697));
  checkpoints.add(new Checkpoint(198, 664, 215, 717));
  checkpoints.add(new Checkpoint(173, 663, 179, 713));
  checkpoints.add(new Checkpoint(146, 661, 141, 709));
  checkpoints.add(new Checkpoint(131, 660, 100, 702));  
  checkpoints.add(new Checkpoint(129, 647, 74, 666));

  boundaries.addAll(walls);
  boundaries.addAll(checkpoints);
}


void writeBoundariesToFile() {
  PrintWriter outpBoundaries = createWriter(boundariesFileName);

  for (Wall w : walls) {
    outpBoundaries.println(characterForWall + splitter + w.pv1.x + splitter +
      w.pv1.y + splitter+ w.pv2.x + splitter + w.pv2.y);
  }
  for (Checkpoint c : checkpoints) {
    outpBoundaries.println(characterForCheckp + splitter + c.pv1.x + splitter +
      c.pv1.y + splitter+ c.pv2.x + splitter + c.pv2.y);
  }

  outpBoundaries.flush();
  outpBoundaries.close();
}

void readBoundariesFromFile() {
  boundaries = new ArrayList<Boundary>();
  walls = new ArrayList<Wall>();
  checkpoints = new ArrayList<Checkpoint>();

  BufferedReader prReadBound = createReader(boundariesFileName);
  String line = null;
  try {
    while ((line = prReadBound.readLine()) != null) {
      String[] pieces = split(line, splitter);
      if (pieces[0].equals(characterForWall))
        walls.add(new Wall(Float.parseFloat(pieces[1]), Float.parseFloat(pieces[2]), 
          Float.parseFloat(pieces[3]), Float.parseFloat(pieces[4])));
      else if (pieces[0].equals(characterForCheckp))
        checkpoints.add(new Checkpoint(Float.parseFloat(pieces[1]), Float.parseFloat(pieces[2]), 
          Float.parseFloat(pieces[3]), Float.parseFloat(pieces[4])));
    }
    prReadBound.close();
  } 
  catch (IOException e) {
    e.printStackTrace();
  } 
  catch (NullPointerException e) {
    e.printStackTrace();
  }
  catch(NumberFormatException e) {
    e.printStackTrace();
  }

  boundaries.addAll(walls);
  boundaries.addAll(checkpoints);
}
