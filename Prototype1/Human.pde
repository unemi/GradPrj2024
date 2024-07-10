class Figure {
  float r, g, b;
  Figure() {
    r = random(255);
    g = random(255);
    b = random(255);
  }
  color colour() {
    return color(r, g, b);
  }
  float diff(Figure f) {
    return sqrt(
      pow(r - f.r, 2)+pow(g - f.g, 2)+pow(b - f.b, 2)) / 255.0;
  }
}
class Human {
  int ID;
  float x, z, th;
  float vx, vz, fx, fz;
  Figure myFig, favFig;
  Human partner;
  float activeness = 0., tolerance = 0.5;
  
  private Human candidate;
  private float candidateF;
  ArrayList<Human> pickers;

  Human(int id) {
    ID = id;
    x = random(-200,200);
    z = random(-200,200);
    th = random(-PI,PI);
    myFig = new Figure();
    favFig = new Figure();
  }
  void resetForStep() {
    fx = fz = 0;
    candidateF = 1. - activeness;
    candidate = null;
    pickers = null;
  }
  float distance(Human a) {
    return dist(x, z, a.x, a.z);
  }
  void affected(Human a, float d) {
    float f = (favFig.diff(a.myFig) - 0.5) * 0.5 + 20 / (d * d);
    float dx = (x - a.x) / d, dz = (z - a.z) / d;
    fx += f * dx;
    fz += f * dz;
    if (candidateF > f) { candidateF = f; candidate = a; }
  }
  void drawMe() {
    push();
    translate(x, 0, z);
    if (candidate != null) {
      push();
      rotateY(atan2(-candidate.z + z, candidate.x - x));
      translate(10,-5,0);
      rotateZ(-PI/2);
      fill(candidate.myFig.colour());
      cone(3, 10);
      pop();
    }
    push();
    fill(myFig.colour());
    translate(0,-5,0);
    sphere(5);
    pop();
    fill(favFig.colour());
    translate(0, 2.5, 0);
    box(10, 5, 10);
    pop();
  }
  boolean acceptable(Human a) {
    return (favFig.diff(a.myFig) < tolerance);
  }
  void gatherPickers() {
    if (candidate != null) {
      if (candidate.pickers == null) candidate.pickers = new ArrayList();
      candidate.pickers.add(this);
    }
  }
  void doAction() {
    if (candidate != null) {
      if (candidate.acceptable(this)) {
        partner = candidate;
        candidate.partner = this;
      }
    }
    vx = (vx + fx) * 0.99;
    vz = (vz + fz) * 0.99;
    float v = sqrt(vx*vx + vz*vz);
    float maxV = 2;
    if (v > maxV) { vx *= maxV / v; vz *= maxV / v; }
    x += vx; z += vz;
    if (x < -200) { vx = -vx; x = -400 - x; }
    else if (x > 200) { vx = - vx; x = 400 - x; }
    if (z < -200) { vz = -vz; z = -400 - z; }
    else if (z > 200) { vz = - vz; z = 400 - z; }
    //x = min(200,max(-200,x+vx));
    //z = min(200,max(-200,z+vz));
    //th = atan2(vz, vx);
  }
}
