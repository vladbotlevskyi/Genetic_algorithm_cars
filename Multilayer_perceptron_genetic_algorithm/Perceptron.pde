class Perceptron {

  float[][] hs;
  float[][][] ws;
  int[] layers;
  float bias;
  float[][] wb;
  float rate;

  Perceptron(int[] _layers, float _rate) {
    layers = _layers;
    createNN();
    bias = 1.0;
    rate = _rate;
  }

  float[] getResult(float[] inp) {
    clearHS();
    for (int i = 0; i < inp.length; i++) {
      hs[0][i] = inp[i];
    }
    calculateNN();

    return hs[hs.length - 1];
  } 

  private void calculateNN() {
    for (int i = 0; i < ws.length - 1; i++) {
      for (int i1 = 0; i1 < ws[i].length; i1++) {
        for (int i2 = 0; i2 < ws[i][i1].length; i2++) {
          hs[i + 1][i1] += hs[i][i2] * ws[i][i1][i2];
        }
        hs[i + 1][i1] += wb[i][i1] * bias;
        hs[i + 1][i1] = func(hs[i + 1][i1]);
      }
    }

    int i = ws.length - 1;
    for (int i1 = 0; i1 < ws[i].length; i1++) {
      for (int i2 = 0; i2 < ws[i][i1].length; i2++) {
        hs[i + 1][i1] += hs[i][i2] * ws[i][i1][i2];
      }
      hs[i + 1][i1] += wb[i][i1] * bias;
      
      // normalize value on output neurons
      hs[i + 1][i1] = (hs[i + 1][i1] > 1f) ? 1f :
        ((hs[i + 1][i1] < 0f) ? 0f : hs[i + 1][i1]);
    }
  }

  private void createNN() {
    hs = new float[layers.length][0];
    for (int i = 0; i < layers.length; i++) {
      hs[i] = new float[layers[i]];
    }
    ws = new float[hs.length - 1][0][0];
    wb = new float[hs.length - 1][0];
    for (int i = 0; i < hs.length - 1; i++) {
      ws[i] = new float[hs[i + 1].length][hs[i].length];
      wb[i] = new float[hs[i + 1].length];
    }

    randomiseWS();
  }

  private void randomiseWS() {
    for (int i = 0; i < ws.length; i++) {
      for (int i1 = 0; i1 < ws[i].length; i1++) {
        for (int i2 = 0; i2 < ws[i][i1].length; i2++) {
          ws[i][i1][i2] = random(-1, 1);
        }
        wb[i][i1] = random(-1, 1);
      }
    }
  }

  private float func(float n) {
    if (n < 0)
      return 0;
    else
      return n;
  }

  private void clearHS() {
    for (int i = 1; i < hs.length; i++) {
      for (int i1 = 0; i1 < hs[i].length; i1++) {
        hs[i][i1] = 0.0;
      }
    }
  }

  //===================================================================

  Perceptron getCopy() {
    int[] layersCopy = new int[layers.length];
    for (int i = 0; i < layers.length; i++) {
      layersCopy[i] = layers[i];
    }
    Perceptron nn = new Perceptron(layersCopy, 1.0);

    nn.hs = makeCopy(hs);
    nn.ws = makeCopy(ws);
    nn.layers = layersCopy;
    nn.bias = bias;
    nn.wb = makeCopy(wb);
    nn.rate = rate;

    return nn;
  }

  //===================================================================


  void makeRandomChanges() {
    int i = int(random(ws.length));
    int j = int(random(ws[i].length));
    if (int(random(2)) == 0) {
      int k = int(random(ws[i][j].length));
      ws[i][j][k] += random(-rate, rate);
    } else {
      wb[i][j] += random(-rate, rate);
    }
  }

  float[][][] makeCopy(float[][][] arr) {
    float[][][] res = new float[arr.length][0][0];
    for (int i = 0; i < arr.length; i++) {
      res[i] = new float[ arr[i].length][0];
      for (int i1 = 0; i1 < arr[i].length; i1++) {
        res[i][i1] = new float[arr[i][i1].length];
        for (int i2 = 0; i2 < arr[i][i1].length; i2++) {
          res[i][i1][i2] = arr[i][i1][i2];
        }
      }
    }
    return res;
  }

  float[][] makeCopy(float[][] arr) {
    float[][] res = new float[arr.length][0];
    for (int i = 0; i < arr.length; i++) {
      res[i] = new float[arr[i].length];
      for (int i1 = 0; i1 < arr[i].length; i1++) {
        res[i][i1] = arr[i][i1];
      }
    }

    return res;
  }
}
