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
  }
  float distance(Human a) {
    return dist(x, z, a.x, a.z);
  }
  void affected(Human a, float d) {
    float f = (favFig.diff(a.myFig) - 0.5) * 0.5 + 20 / (d * d);
    float dx = (x - a.x) / d, dz = (z - a.z) / d;
    fx += f * dx;
    fz += f * dz;
  }
  void drawMe() {
    push();
    translate(x, 0, z);
    fill(myFig.colour());
    sphere(5);
    fill(favFig.colour());
    translate(0, 2.5, 0);
    box(10, 5, 10);
    pop();
  }
  void doAction() {
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
Human[] pop = new Human[100];
void setup() {
  size(1280,720,P3D);
  for (int i = 0; i < pop.length; i ++)
    pop[i] = new Human(i);
  noStroke();
  //frameRate(1);
}
void draw() {
  background(220);
  lights();
  camera(0,-100,400, 0,0,0, 0,1,0);
  for (Human h : pop) h.drawMe();
  for (Human h : pop) h.resetForStep();
  for (int i = 1; i < pop.length; i ++) {
    Human a = pop[i];
    for (int j = 0; j < i; j ++) {
      Human b = pop[j];
      float d = a.distance(b);
      if (d > 20) continue;
      a.affected(b, d);
      b.affected(a, d);
    }
  }
  for (Human h : pop) h.doAction();
}
