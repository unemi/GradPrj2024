ArrayList<Human> pop, newBornBB;
int initPopSize = 100;
float nearDist = 20, worldSize = 400, agentSize = 2;
PShape head, body, env;
int camMode = 2;
int step = 0;
Human viewer;
void setup() {
  size(1280,720,P3D);
  pop = new ArrayList(initPopSize);
  for (int i = 0; i < initPopSize; i ++)
    pop.add(new Human());
  noStroke();
  colorMode(HSB, 360, 100, 100);
  head = loadShape("monkeyHead.obj");
  body = loadShape("LowPoly-Characters.obj");
  env = setupEnv("SokaUnivCampus.jpg");
  viewer = pop.get(1);
  float fov = PI/3., cZ = height/2.0 / tan(fov/2.);
  perspective(fov, float(width)/height, cZ/100.0, cZ*10.0);
  //frameRate(2);
}
float camAngle = 0.;
void draw() {
  background(220);
  ambientLight(0,0,70);
  directionalLight(0,0,80, 0,1,-1);
  switch (camMode) {
    case 0:
    camera(worldSize*sin(camAngle),-worldSize/2,worldSize*cos(camAngle), 0,0,0, 0,1,0);
    break;
    case 1:
    camera(0,-worldSize/4,worldSize/4, 0,0,0, 0,1,0); break;
    case 2:
    camera(viewer.x-cos(viewer.faceTh)*agentSize*6,
      -agentSize*4,
      viewer.z+sin(viewer.faceTh)*agentSize*6,
      viewer.x,-agentSize*2,viewer.z,
      0,1,0);
  }
  if ((camAngle += PI / 720) > TWO_PI) camAngle -= TWO_PI;
  push();
  translate(0,agentSize*1.1,0);
  shape(env);
  fill(45,50,90);
  box(worldSize+agentSize*2, 1, worldSize+agentSize*2);
  pop();
//
  int popSize = pop.size();
  ArrayList<Human> newPop = new ArrayList(popSize);
  while (pop.size() > 0) {
    int i = int(random(pop.size()));
    newPop.add(pop.get(i));
    pop.remove(i);
  }
  pop = newPop;
  newBornBB = new ArrayList();
  for (Human h : pop) h.drawMe();
  for (Human h : pop) h.resetForStep();
  for (int i = popSize - 1; i >= 0; i --) {
    if (pop.get(i).age > 85*12) { pop.remove(i); }
  }
  pop.addAll(newBornBB);
  if ((popSize = pop.size()) <= 0) { noLoop(); return; }
  for (int i = 1; i < popSize; i ++) {
    Human a = pop.get(i);
    for (int j = 0; j < i; j ++) {
      Human b = pop.get(j);
      float d = a.distance(b);
      if (d > nearDist) continue;
      a.affected(b, d);
      b.affected(a, d);
    }
  }
  for (Human h : pop) h.doAction();
  int cnt = 0;
  for (Human h : pop) if (h.partner != null) cnt ++;
  println(step++ + ": partners=" + cnt +
    ", newBornBB=" + newBornBB.size() + ", popSize=" + popSize);
}
void mousePressed() {
  camMode = (camMode + 1) % 3;
}
