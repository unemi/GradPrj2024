ArrayList<Human> pop, newBornBB;
int initPopSize = 800;
float nearDist = 60, worldSize = 400, agentSize = 2;
PShape head, body, env;
int camMode = 2;
int step = 0;
float camX, camY, camZ, tgtX, tgtY, tgtZ;
Human viewer;
void setup() {
  size(1280,720,P3D);
  pop = new ArrayList(initPopSize);
  for (int i = 0; i < initPopSize; i ++)
    pop.add(new Human());
  noStroke();
  colorMode(HSB, 360, 100, 100);
  //head = loadShape("monkeyHead.obj");
  //body = loadShape("LowPoly-Characters.obj");
  env = setupEnv("SokaUnivCampus.jpg");
  viewer = pop.get(1);
  float fov = PI/3., cZ = height/2.0 / tan(fov/2.);
  perspective(fov, float(width)/height, cZ/100.0, cZ*10.0);
  //frameRate(2);
}
float camAngle = 0., camDist = 100.;
void draw() {
  background(220);
  ambientLight(0,0,70);
  directionalLight(0,0,80, 0,1,-1);
  float d = worldSize*camDist/100.;
  switch (camMode) {
    case 0:
    camX = d*sin(camAngle); camY = -d/2; camZ = d*cos(camAngle);
    tgtX = tgtY = tgtZ = 0; break;
    case 1:
    camX = 0; camY = -d/4; camZ = d/4;
    tgtX = tgtY = tgtZ = 0; break;
    case 2:
    camX = viewer.x-cos(viewer.faceTh)*agentSize*d/40;
    camY = -agentSize*4;
    camZ = viewer.z+sin(viewer.faceTh)*agentSize*d/40;
    tgtX = viewer.x; tgtY = -agentSize*2; tgtZ = viewer.z;
  }
  camera(camX, camY, camZ, tgtX, tgtY, tgtZ, 0, 1, 0);
  if ((camAngle += PI / 720) > TWO_PI) camAngle -= TWO_PI;
  push();
  translate(0,agentSize*1.1,0);
  shape(env);
  fill(45,50,90);
  box(worldSize+agentSize*2, 1, worldSize+agentSize*2);
  pop();
//
  int popSize = pop.size(), nDeath = 0;
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
  boolean didViewerDie = false;
  for (int i = popSize - 1; i >= 0; i --) {
    Human h = pop.get(i);
    if (h.age > 85*12) {
      pop.remove(i); nDeath ++;
      if (h == viewer) didViewerDie = true;
    }
  }
  if ((popSize = pop.size()) <= 0) { noLoop(); return; }
  if (didViewerDie) viewer = pop.get(0);
  for (int i = 1; i < popSize; i ++) {
    Human a = pop.get(i);
    for (int j = 0; j < i; j ++) {
      Human b = pop.get(j);
      d = a.distance(b);
      if (d > nearDist) continue;
      a.affected(b, d);
      b.affected(a, d);
    }
  }
  for (Human h : pop) h.doAction();
  pop.addAll(newBornBB);
  int cnt = 0;
  for (Human h : pop) if (h.partner != null) cnt ++;
  println(step++ + ": partners=" + cnt + ", dead=" + nDeath +
    ", newBornBB=" + newBornBB.size() + ", popSize=" + pop.size());
}
void mousePressed() {
  camMode = (camMode + 1) % 3;
}
void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  if ((camDist += e) <= 0) camDist = 20;
  println(e);
}
