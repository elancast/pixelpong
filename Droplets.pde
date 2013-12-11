class Droplets extends LXPattern {
  
  private class Drop {
    private final Accelerator a = new Accelerator(-0.02, 0, 0.01);
    private final LinearEnvelope xPos = new LinearEnvelope(0, 0, 9000);
    private final LinearEnvelope yPos = new LinearEnvelope(0, 0, 9000);
    private float hVal;
    private float falloff;

    public Drop() {
      randomize();      
      addModulator(a.trigger()).setValue(random(0,1));
      addModulator(xPos);
      addModulator(yPos);
    }
    
    public void randomize() {
      a.setValue(0);
      a.setSpeed(0, random(0.025, 0.15)).trigger();
      falloff = random(800, 1400);
      xPos.setRange(random(0, 1), random(0, 1)).trigger();
      yPos.setRange(random(0, 1), random(0, 1)).trigger();
      hVal = random(0, 80);
    }
    
    public void go() {
      if (a.getSpeed() > 0.2) {
        a.setSpeed(a.getSpeed(), 0);
      }
      
      float xP = xPos.getValuef();
      float yP = yPos.getValuef();
      for (int i = 0; i < lx.total; ++i) {
        float d = dist(lx.xposf(i) * lx.width, lx.yposf(i) * lx.height, xP * lx.width, yP * lx.height) / lx.width;
        float b = max(0, 100 - falloff*abs(d-a.getValuef()));
        if (b > 0) {
          color c = color((hVal + lx.getBaseHuef()) % 360, 100*(1-a.getValuef()), b);
          addColor(i, c);
        }
      }
      if (a.getValue() > 1.6) {
        randomize();
      }
    }
  }
  
  final Drop[] drops;
  
  public Droplets(HeronLX lx) {
    this(lx, 10);
  }
  
  public Droplets(HeronLX lx, int numDrops) {
    super(lx);
    drops = new Drop[numDrops];
    for (int i = 0; i < drops.length; ++i) {
      drops[i] = new Drop();
    }
    setTransition(new IrisTransition(lx).setDuration(3000));
  }
  
  public void run(int deltaMs) {
    clearColors();
    for (int i = 0; i < drops.length; ++i) {
      drops[i].go();
    }
  }
}

