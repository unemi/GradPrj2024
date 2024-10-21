Human[] pop = new Human[100];
float nearDist = 20, worldSize = 400, agentSize = 2;
PShape head, body, env;
int camMode = 2;
int step = 0;
Human viewer;
void setup() {
  size(1280,720,P3D);
  for (int i = 0; i < pop.length; i ++)
    pop[i] = new Human(i);
  noStroke();
  colorMode(HSB, 360, 100, 100);
  head = loadShape("monkeyHead.obj");
  body = loadShape("LowPoly-Characters.obj");
  env = setupEnv("SokaUnivCampus.jpg");
  viewer = pop[1];
  float fov = PI/3., cZ = height/2.0 / tan(fov/2.);
  perspective(fov, float(width)/height, cZ/100.0, cZ*10.0);
 // frameRate(10);
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
      if (d > nearDist) continue;
      a.affected(b, d);
      b.affected(a, d);
    }
  }
  for (Human h : pop) h.doAction();
  int cnt = 0;
  for (Human h : pop) if (h.partner != null) cnt ++;
  //println(step++ + "," + cnt);
}
void mousePressed() {
  camMode = (camMode + 1) % 3;
}
