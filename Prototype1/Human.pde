int Male = 0, Female = 1;
float Avoid = 1., Approach = 0.2;

float inheritedHue(float m, float d) {
  float h = ((random(1.0) < 0.5)? m : d) + random(-5,5);
  if (h > 360) h -= 360; else if (h < 0) h += 360;
  return h;
}
class Figure {
  float h, s, b;
  Figure(int sex) {
    h = random(360);
    s = random(50,100);
    b = (sex == Male)? 70 : 100;
  }
  Figure(int sex, Figure m, Figure d) {
    h = inheritedHue(m.h, d.h);
    s = min(100, max(50, ((random(1.0) < 0.5)? m.s : d.s) + random(-3,3)));
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
int IDCount = 0;
class Human {
  int ID, sex, age, pregn;
  float x, z, th, faceTh;
  float vx, vz, fx, fz;
  float favHue;
  Figure myFig;
  Human partner, candidate, fetusDad;
  float partnerF;
  float activeness = 0.9, tolerance = 0.5, fickleness = 0.3;
  float ageScl;
  
  private float candidateF;
  ArrayList<Human> pickers;

  Human() {
    ID = IDCount ++;
    sex = (random(1.0) < 0.5)? Male : Female;
    x = random(-200,200);
    z = random(-200,200);
    th = random(-PI,PI);
    myFig = new Figure(sex);
    favHue = random(360);
    age = int(random(90*12));
  }
  Human(Human mom, Human dad) {
    ID = IDCount ++;
    sex = (random(1.0) < 0.5)? Male : Female;
    age = 0;
    float d = random(10,15), th = random(TWO_PI);
    x = mom.x + d * cos(th);
    z = mom.z + d * sin(th);
    th = random(-PI,PI);
    myFig = new Figure(sex, mom.myFig, dad.myFig);
    favHue = inheritedHue(mom.favHue, dad.favHue);
  }
  void resetForStep() {
    fx = fz = 0;
    age ++;
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
    ageScl = ((age > 17*12)? 1. :
      1. - (17*12 - age) / (17.*12) * 0.7) * agentSize;
    
    if (candidate != null) {
      push();
      faceTh = atan2(-candidate.z + z, candidate.x - x);
      rotateY(faceTh);
      translate(ageScl*2,-ageScl,0);
      rotateZ(-PI/2);
      fill(candidate.myFig.colour());
      cone(ageScl*3/5, ageScl*2);
      pop();
    } else faceTh = (partner != null)?
      atan2(-partner.z + z, partner.x - x) : th;
    rotateY(faceTh);
    push();
    translate(0,-ageScl,0);
    scale(ageScl,-ageScl,ageScl);
    push();
    if (sex == Male) {
      scale(5);
      rotateY(PI/2);
      body.setFill(myFig.colour());
      shape(body);
      //cylinder(ageScl,ageScl*2);
    } else {
      //scale(ageScl,-ageScl,ageScl);//sphere(5);
      head.setFill(myFig.colour());
      shape(head);
    }
    pop();
    fill((partner != null)? color(0,100,100) : color(0,0,50));
    box(3,0.1,3);
    pop();
    fill(color(favHue,100,100));
    translate(0, ageScl/2, 0);
    box(ageScl*2, ageScl, ageScl*2);
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
  float pregProb() {  // proberbility of fertilization
    // M: (0,0)-(13,0)-(15,1.0)-(30,1.0)-(50,0.6)-(90,0.0)
    // F: (0,0)-(14,0)-(16,1.0)-(30,1.0)-(50,0.0)
    float f = age / 12.0, m = partner.age / 12.0;
    return ((f < 14)? 0.0 :
      (f < 16)? (f - 14) / (16 - 14) :
      (f < 30)? 1.0 :
      (f < 50)? 1.0 - (f - 30) / (50 - 30) : 0.0) *
      ((m < 13)? 0.0 :
      (m < 15)? (m - 13) / (15 - 13) :
      (m < 30)? 1.0 :
      (m < 50)? 1.0 - (m - 30) / (50 - 30) * (1.0 - 0.6) :
      (m < 90)? 0.6 - (m - 50) / (90 - 50) : 0.0);
  }
  void doAction() {
    if (sex == Female) {
      if (pregn > 9) {
        newBornBB.add(new Human(this, fetusDad));
        pregn = 0; fetusDad = null;
        //println("got pregnant.");
      } else if (pregn > 0) { pregn ++;
      } else if (partner != null && partner.partner == this
        && pregProb() > random(1.0)) {
          pregn = 1;
          fetusDad = partner;
      }
    }
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
    x += vx * ageScl/5; z += vz * ageScl/5;
    if (x < -worldSize/2) { vx = -vx; x = -worldSize - x; }
    else if (x > worldSize/2) { vx = - vx; x = worldSize - x; }
    if (z < -worldSize/2) { vz = -vz; z = -worldSize - z; }
    else if (z > worldSize/2) { vz = - vz; z = worldSize - z; }
    //x = min(200,max(-200,x+vx));
    //z = min(200,max(-200,z+vz));
    //th = atan2(vz, vx);
  }
}
