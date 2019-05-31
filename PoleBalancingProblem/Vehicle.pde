class Vehicle extends Behavior {

  /* Angle, angular velocity and angular acceleration. */
  private float a;       // [radians]
  private float adot;    // [radians/s]
  private float adotdot; // [radians/s^2]

  /* Position (relative offset from center), velocity and acceleration
   * of the cart. */
  private float x;       // [m]
  private float xdot;    // [m/s]
  private float xdotdot; // [m/s^2]

  /* Gravitational acceleration. */
  private static final float g = 9.81; // [m/s^2]

  /* Mass of the carc and pole. */
  private static final float mc = 1.0; // [kg]
  private static final float mp = 0.1; // [kg]

  /* Pole length. */
  private static final float l = 1; // [m]

  /* Force applied on the center of the cart. */
  private float F; // [N];

  /* Track limit (from center). */
  private static final float h = 2.4; // [m]

  /* Pole failure angle. */
  private static final float r = 0.209; // [radians]

  /* Time (simulation time, not real time) this vehicle lived. Used for the fitness. */
  private float t;

  /* Time step. */
  private static final float ts = 0.02; // [s]

  /* Vehicle width. */
  private static final float w = 1; // [m]

  /* Dies when the limit is touched or the pole falls. */
  private boolean alive;


  private Vehicle () {
    Random r = new Random();

    // Start with a very small angle.
    a = (float) r.nextGaussian()*.001f;
    adot = 0;
    adotdot = 0;

    x = 2.4;
    xdot = 0;
    xdotdot = 0;

    t = 0;
    alive = true;
  }


  public float[] updateSensors () {
    return new float[] {a, adot, x, xdot};
  }


  public void move (float[][] controls) {
    F = controls[0][0] > .5 ? 10 : -10;

    float m = mc + mp;
    float c1 = -F - mp * l * (adot*adot) * sin(a);
    float num = g*sin(a) + cos(a) * (c1/m);
    float den = l * ( (4/3) - (mp*cos(a)*cos(a)/m) );
    adotdot = num / den;

    num = F + mp * l * (adot*adot*sin(a) - adotdot*cos(a));
    xdotdot = num / m;

    adot += adotdot * ts;
    a += adot * ts;

    xdot += xdotdot * ts;
    x += xdot * ts;

    t += ts;

    if (x < -h*100 || x > h*100 || a < -r || a > r) {
      alive = false;
    }

    render();
  }


  private void render () {
    pushMatrix();
    translate(width/2, height - 100);

    // Car
    fill(0, 150, 150);
    rectMode(CENTER);
    rect(x, 0, w*100, 50);
    rectMode(CORNER);
    fill(0);
    ellipse(x-w*50+12, 28, 24, 24);
    ellipse(x+w*50-12, 28, 24, 24);

    // Pole
    stroke(0);
    strokeWeight(10);
    line(x, -25, x+l*100*cos(PI/2-a), -25-l*100*sin(PI/2-a));
    noStroke();

    popMatrix();
  }


  public float fitnessFunction () {
    return t;
  }


  public Vehicle copy () {
    return new Vehicle();
  }


  public boolean isAlive () {
    return alive;
  }
  
  
  public boolean printAndExit () {
    return false;
  }
  

  float getTrackWidth () {
    return h*2 + w;
  }
}
