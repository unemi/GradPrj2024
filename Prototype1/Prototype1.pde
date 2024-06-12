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
      pow(r - f.r, 2)+pow(g - f.g, 2)+pow(b - f.b, 2));
  }
}
class Human {
  int ID;
  float x, z, th;
  Figure myFig, favFig;
  Human(int id) {
    ID = id;
    x = random(-200,200);
    z = random(-200,200);
    th = random(-PI,PI);
    myFig = new Figure();
  }
  void drawMe() {
    push();
    translate(x, 0, z);
    fill(myFig.colour());
    sphere(5);
    pop();
  }
  void doAction() {
    float d = random(-10,10);
    x += d * cos(th);
    z += d * sin(th);
    //println(ID + " " + x);
  }
}
Human[] pop = new Human[10];
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
  for (Human h : pop) h.doAction();
}
