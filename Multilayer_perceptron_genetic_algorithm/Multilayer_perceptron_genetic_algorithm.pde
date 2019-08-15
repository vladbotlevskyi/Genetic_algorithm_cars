import java.awt.event.KeyEvent;

Car[] cars;
final int[] layers = new int[]{4, 10, 5, 2};
final float mutationRate = 0.5;

float startPosX = 100, startPosY = 645;
float startAngle = -1.51;
final int timeToNextCheckpoint = 140, rewardForReachingCheckpoint = 150;
final float maxSpeed = 3.5, maxAngleAcceleration = 0.02, maxAcceleration = 0.04, 
  carVectLength = 100;
final int populationSize = 100;
final float selectionPercent = 0.30;
final int leftFromPrevGen = 25;
final int minMutationNum = 6, maxMutationNum = 12;

void setup() {
  size(800, 800);
  frameRate(60);  
  focused = true;

  restart();
}

void draw() {
  background(0);

  for (Boundary b : boundaries) {    
    strokeWeight(1);
    b.show();
  }

  if (!editModeOn) {
    perforIteration();
  }
  showEditingMode();
}

void perforIteration() {
  for (int i = 0; i < cars.length; i++) {
  driving:
    {
      if (!cars[i].crushed) {
        cars[i].timeToNextCheckpoint--;
        if (cars[i].timeToNextCheckpoint < 0) {
          onCarCrushed(cars[i]);
          break driving;
        }

        strokeWeight(4);
        stroke(255);   
        for (Ray r : cars[i].rays) {
          for (Boundary b : boundaries) {
            PVector intersectionPoint = r.checkOnIntersection(b);
            if (intersectionPoint != null) {
              float distance = r.getDistanceToIntersection(intersectionPoint);
              //====check if crashed============
              if (b instanceof Wall ) {
                point(intersectionPoint.x, intersectionPoint.y);
                if ( distance < 10) {                
                  onCarCrushed(cars[i]);
                  break driving;
                }
              }
              //=====check if checkpoint is reached============
              else if (b instanceof Checkpoint &&
                checkpoints.indexOf(b) == cars[i].nextCheckpoint && distance < 7) {
                cars[i].nextCheckpoint++;
                if (cars[i].nextCheckpoint >= checkpoints.size()) {
                  cars[i].nextCheckpoint = 0;
                }
                cars[i].fitness = cars[i].fitness + rewardForReachingCheckpoint;
                cars[i].timeToNextCheckpoint = timeToNextCheckpoint;
              }
            }
          }
        }
        cars[i].fitness++; 
        perceptronDrive(cars[i]);

        strokeWeight(1);
        cars[i].moveCarOneStep();
        cars[i].show(255, 255);
      } else {
        strokeWeight(1);
        cars[i].show(150, 100);
      }
    }
  }
}

void onCarCrushed(Car car) {
  car.crushed = true;
  car.speed = 0;
  if (checkOnAllCrushed()) {
    createNextGen();
  }
}

void perceptronDrive(Car car) {
  float[] vectInp = new float[car.rays.length];
  for (int i = 0; i < vectInp.length; i++) {
    List<PVector> wallsRayIntersect = new LinkedList<PVector>();
    for (Wall w : walls) {
      PVector intersectionPoint = car.rays[i].checkOnIntersection(w);
      if (intersectionPoint != null) {
        wallsRayIntersect.add(intersectionPoint);
      }
    }
    try {    
      vectInp[i] = car.rays[i].getDistanceToClosestPoint(wallsRayIntersect) /
        carVectLength;
    }
    catch(NullPointerException ex) {
      vectInp[i] = 1f;
    }
  }
  float[] result = car.perceptron.getResult(new float[]{car.speed / maxSpeed, 
    vectInp[0], vectInp[1], vectInp[2]});
  car.speed += maxAcceleration * (result[0] - 0.5);
  car.updateCarAngle(car.angle + (result[1] - 0.5) * maxAngleAcceleration);
  limitCarSpeed(car);
}

boolean checkOnAllCrushed() {
  for (Car c : cars) {
    if (!c.crushed)
      return false;
  }
  return true;
}

void limitCarSpeed(Car car) {
  if (car.speed < 0)
    car.speed = 0;
  if (car.speed > maxSpeed)
    car.speed = maxSpeed;
}

void restart() {  
  cars = new Car[populationSize];
  for (int i = 0; i < cars.length; i++) {
    //input neurons in corresponding order: 1)current speed, 2)left vector(if car looking up), 
    //3)middle vector, 4)right vector.
    //output neurons in corresponding order: 1)acceleration(not speed) coefficient, 
    // 2)neuron responsible for turning left/right,
    cars[i] = new Car(new Perceptron(layers, mutationRate), 
      startPosX, startPosY, startAngle, carVectLength, timeToNextCheckpoint);
  }
  readBoundariesFromFile();
}

void createNextGen() {
  sortCarByFitness(cars);
  Car[] nextGen = new Car[cars.length];
  for (int i = 0; i < leftFromPrevGen; i++) {
    nextGen[i] = new Car(new Perceptron(layers, mutationRate), 
      startPosX, startPosY, startAngle, carVectLength, timeToNextCheckpoint);
    nextGen[i].perceptron = cars[i].perceptron;
  }
  int selectionSize = int(((float)populationSize) * selectionPercent);
  for (int i = leftFromPrevGen; i < nextGen.length; i++) {
    Car c1 = cars[int(random(0, selectionSize))];
    Car c2 = cars[int(random(0, selectionSize))];
    nextGen[i] = crossPerceptronByNPointsRand(c1, c2);
    //adding random mutations
    if (int(random(0f, 2f)) == 1) {
      int mutationNumber = int(random(minMutationNum, maxMutationNum + 1));
      for (int m = 0; m < mutationNumber; m++) {
        nextGen[i].perceptron.makeRandomChanges();
      }
    }
  }
  cars = nextGen;
}

Car crossPerceptronByNPointsRand(Car c1, Car c2) {
  Car crossedCar = new Car(new Perceptron(layers, mutationRate), 
    startPosX, startPosY, startAngle, carVectLength, timeToNextCheckpoint);
  for (int i = 0; i < crossedCar.perceptron.ws.length; i++) {
    for (int i1 = 0; i1 < crossedCar.perceptron.ws[i].length; i1++) {
      for (int i2 = 0; i2 < crossedCar.perceptron.ws[i][i1].length; i2++) {
        crossedCar.perceptron.ws[i][i1][i2] = (int(random(0f, 2f)) == 0) ? c1.perceptron.ws[i][i1][i2] :
          c2.perceptron.ws[i][i1][i2];
      }
    }
  }
  for (int i = 0; i < crossedCar.perceptron.wb.length; i++) {
    for (int i1 = 0; i1 < crossedCar.perceptron.wb[i].length; i1++) {
      crossedCar.perceptron.wb[i][i1] = (int(random(0f, 2f)) == 0) ? c1.perceptron.wb[i][i1] :
        c2.perceptron.wb[i][i1];
    }
  }
  return crossedCar;
}

void sortCarByFitness(Car[] cars) {
  boolean sorted = true;
  for (int i = 1; i < cars.length; i++) {
    if (cars[i].fitness > cars[i - 1].fitness) {
      Car c = cars[i];
      cars[i] = cars[i - 1];
      cars[i - 1] = c;
      sorted = false;
    }
  }
  if (!sorted) {
    sortCarByFitness(cars);
  }
}

void keyPressed() {
  if (keyPressed) {
    int key1 = Character.toLowerCase(key);

    if (keyCode == KeyEvent.VK_SPACE && !editModeOn) {
      createNextGen();
    } else if (key1 == 'r' && !editModeOn) {
      restart();
    } else if (key1 == 'e' && (cutX1 < 0 || cutY1 < 0)) {
      editModeOn = !editModeOn;
      restoreClickPts();
    } else if (key1 == '1' && (cutX1 < 0 || cutY1 < 0)) {
      for (int i = 0; i < typeOfTrakUpdate.length; i++)
        typeOfTrakUpdate[i] = false;
      typeOfTrakUpdate[0] = true;
    } else if (key1 == '2' && (cutX1 < 0 || cutY1 < 0)) {
      for (int i = 0; i < typeOfTrakUpdate.length; i++)
        typeOfTrakUpdate[i] = false;
      typeOfTrakUpdate[1] = true;
    } else if (key1 == '3' && (cutX1 < 0 || cutY1 < 0)) {
      for (int i = 0; i < typeOfTrakUpdate.length; i++)
        typeOfTrakUpdate[i] = false;
      typeOfTrakUpdate[2] = true;
    } else if (editModeOn && key1 == 'c' && (cutX1 < 0 || cutY1 < 0)) {
      cutModeOn = !cutModeOn;
      restoreClickPts();
    }
  }
}
