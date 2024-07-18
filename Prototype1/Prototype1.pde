Human[] pop = new Human[100];
int step = 0;
void setup() {
  size(1280,720,P3D);
  for (int i = 0; i < pop.length; i ++)
    pop[i] = new Human(i);
  noStroke();
  colorMode(HSB, 360, 100, 100);
 // frameRate(10);
}
float camAngle = 0.;
void draw() {
  background(220);
  ambientLight(0,0,70);
  directionalLight(0,0,80, 0,1,-1);
  camera(400*sin(camAngle),-200,400*cos(camAngle), 0,0,0, 0,1,0);
  if ((camAngle += PI / 720) > TWO_PI) camAngle -= TWO_PI;
  push();
  translate(0,5.5,0);
  fill(45,50,90);
  box(410, 1, 410);
  pop();
  for (int i = 1; i < pop.length; i ++) {
    int j = int(random(pop.length - i)) + i;
    Human h = pop[i - 1];
    pop[i - 1] = pop[j];
    pop[j] = h;
  }
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
  int cnt = 0;
  for (Human h : pop) if (h.partner != null) cnt ++;
  println(step++ + "," + cnt);
}
