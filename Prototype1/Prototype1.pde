ArrayList<Human> pop, newBornBB;
int initPopSize = 800;
float nearDist = 60, worldSize = 400, agentSize = 2;
int AgeMax = 85;
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
int accTm = 0;
float std(float s, float s2, int n) {
   return sqrt((s2 - s*s/n)/n);
}
void draw() {
  step ++;
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
  
  int startTm = millis();
  for (Human h : pop) h.drawMe();
  int elapsedTm = millis() - startTm;
  accTm += elapsedTm;
  if ((step % 100) == 0) {
    int N = 10, cnt[] = new int[N];
    float sumR = 0, sumI = 0, sumR2 = 0, sumI2 = 0;
    for (Human h : pop) {
      cnt[int(h.favHueM * N / 360)] ++;
      float R = cos(h.favHueM * PI / 180), I = sin(h.favHueM * PI / 180);
      sumR += R; sumI += I;
      sumR2 += R*R; sumI2 += I*I;
    }
    // Standard Deviation
    print(step + "," +
      atan2(std(sumI, sumI2, popSize), std(sumR, sumR2, popSize))*180/PI);
    for (int i = 0; i < N; i ++) print(cnt[i] + ",");
    println(accTm * 1000. / 100.0 / popSize);
    accTm = 0;
  }

  for (Human h : pop) h.resetForStep();
  boolean didViewerDie = false;
  // Kill aged guys
  for (int i = popSize - 1; i >= 0; i --) {
    Human h = pop.get(i);
    if (h.age > AgeMax*12) {
      pop.remove(i); nDeath ++;
      if (h == viewer) didViewerDie = true;
    }
  }
  if ((popSize = pop.size()) <= 0) { noLoop(); return; }
  if (didViewerDie) viewer = pop.get(0);
  // Interaction
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
  //int cnt = 0;
  //for (Human h : pop) if (h.partner != null) cnt ++;
  //println(step + ": partners=" + cnt + ", dead=" + nDeath +
  //  ", newBornBB=" + newBornBB.size() + ", popSize=" + pop.size());
}
void mousePressed() {
  camMode = (camMode + 1) % 3;
}
void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  if ((camDist += e) <= 0) camDist = 20;
  println(e);
}
