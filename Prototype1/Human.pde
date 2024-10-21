int Male = 0, Female = 1;
float Avoid = 1., Approach = 0.2;
class Figure {
  float h, s, b;
  Figure(int sex) {
    h = random(360);
    s = random(50,100);
    b = (sex == Male)? 70 : 100;
  }
  color colour() {
    return color(h, s, b);
  }
  float howLike(float fh) {
    float d = abs(h - fh);
    float H = ((d < 180)? d : 360 - d) / 180., S = (s - 50) / 50.;
    return S * (1. - 2. * H);
  }
}
class Human {
  int ID, sex;
  float x, z, th, faceTh;
  float vx, vz, fx, fz;
  float favHue;
  Figure myFig;
  Human partner, candidate;
  float partnerF;
  float activeness = 0.9, tolerance = 0.5, fickleness = 0.3;
  
  private float candidateF;
  ArrayList<Human> pickers;

  Human(int id) {
    ID = id;
    sex = id % 2;
    x = random(-200,200);
    z = random(-200,200);
    th = random(-PI,PI);
    myFig = new Figure(sex);
    favHue = random(360);
  }
  void resetForStep() {
    fx = fz = 0;
    float avoid = nearDist * 5;
    if (x - worldSize/2 < nearDist) fx = -avoid / pow(x - worldSize/2, 2);
    else if (x + worldSize/2 < nearDist) fx = avoid / pow(x + worldSize/2, 2);
    if (z - worldSize/2 < nearDist) fz = -avoid / pow(z - worldSize/2, 2);
    else if (z + worldSize/2 < nearDist) fz = avoid / pow(z + worldSize/2, 2);
    candidateF = (partner != null)? partnerF * (1. - fickleness) : 1. - activeness;
    candidate = null;
    pickers = null;
  }
  float distance(Human a) {
    return dist(x, z, a.x, a.z);
  }
  void affected(Human a, float d) {
    float like = a.myFig.howLike(favHue);
    float dx = (a.x - x) / d, dz = (a.z - z) / d;
    float avoid = - nearDist / (d * d);
    float f = Avoid * avoid + Approach * like;
    fx += f * dx;
    fz += f * dz;
    if (candidateF < like) { candidateF = like; candidate = a; }
  }
  void drawMe() {
    push();
    translate(x, 0, z);
    if (candidate != null) {
      push();
      faceTh = atan2(-candidate.z + z, candidate.x - x);
      rotateY(faceTh);
      translate(agentSize*2,-agentSize,0);
      rotateZ(-PI/2);
      fill(candidate.myFig.colour());
      cone(agentSize*3/5, agentSize*2);
      pop();
    } else faceTh = (partner != null)?
      atan2(-partner.z + z, partner.x - x) : th;
    rotateY(faceTh);
    push();
    translate(0,-agentSize,0);
    scale(agentSize,-agentSize,agentSize);
    push();
    if (sex == Male) {
      scale(5);
      rotateY(PI/2);
      body.setFill(myFig.colour());
      shape(body);
      //cylinder(agentSize,agentSize*2);
    } else {
      //scale(agentSize,-agentSize,agentSize);//sphere(5);
      head.setFill(myFig.colour());
      shape(head);
    }
    pop();
    fill((partner != null)? color(0,100,100) : color(0,0,50));
    box(3,0.1,3);
    pop();
    fill(color(favHue,100,100));
    translate(0, agentSize/2, 0);
    box(agentSize*2, agentSize, agentSize*2);
    pop();
  }
  boolean acceptable(Human a) {
    float f = a.myFig.howLike(favHue);
    return f > ((partner != null)? partnerF * fickleness : tolerance);
  }
  void gatherPickers() {
    if (candidate != null) {
      if (candidate.pickers == null) candidate.pickers = new ArrayList();
      candidate.pickers.add(this);
    }
  }
  void doAction() {
    if (candidate != null && candidate.partner == null) {
      if (candidate.acceptable(this)) {
        partner = candidate;
        partnerF = candidateF;
        candidate.partner = this;
        candidate.partnerF = myFig.howLike(candidate.favHue);
        candidate.candidate = null;
      }
    }
    vx = (vx + fx) * 0.99;
    vz = (vz + fz) * 0.99;
    float v = sqrt(vx*vx + vz*vz);
    if (abs(v) > 1e-8) th = atan2(-vz, vx);
    float maxV = 2;
    if (v > maxV) { vx *= maxV / v; vz *= maxV / v; }
    x += vx * agentSize/5; z += vz * agentSize/5;
    if (x < -worldSize/2) { vx = -vx; x = -worldSize - x; }
    else if (x > worldSize/2) { vx = - vx; x = worldSize - x; }
    if (z < -worldSize/2) { vz = -vz; z = -worldSize - z; }
    else if (z > worldSize/2) { vz = - vz; z = worldSize - z; }
    //x = min(200,max(-200,x+vx));
    //z = min(200,max(-200,z+vz));
    //th = atan2(vz, vx);
  }
}
