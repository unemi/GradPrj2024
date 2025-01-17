float hueDist(float h1, float h2) {
  float d = abs(h1 - h2);
  return (d < 180)? d : 360 - d;
}
float geneDist(Human a, Human b) {
  float d = hueDist(a.favHueM, b.favHueM);
  d += hueDist(a.myFigM.h, b.myFigM.h);
  if (SexLinkage) {
    d += hueDist(a.favHueF, b.favHueF);
    d += hueDist(a.myFigF.h, b.myFigF.h);
  }
  return d;
}
float nearDist(Human x) {
  float minDist = 1e10;
  for (Human h : pop) if (h != x) {
    float d = geneDist(x, h);
    if (minDist > d) minDist = d;
  }
  return minDist;
}
float hopkins() {
  int n = pop.size(), m = n / 10;
  int[] idx = new int[n];
  for (int i = 0; i < n; i ++) idx[i] = i;
  for (int i = 0; i < m; i ++) {
    int j = int(random(n - i - 1)) + i + 1;
    int k = idx[j]; idx[j] = idx[i]; idx[i] = k;
  }
  float u = 0., w = 0.;
  for (int i = 0; i < m; i ++) {
    u += nearDist(pop.get(idx[i]));
    w += nearDist(new Human());
  }
  return u / (u + w);
}
PVector sexualDimorphism() {
  float sumS = 0., sumC = 0.;
  for (Human h : pop) {
    float d = abs(h.favHueM - h.favHueF);
    if (d <= 180.) d = 360. - d;
    sumS += sin(d * PI / 180.);
    sumC += cos(d * PI / 180.);
  }
  float m = atan2(sumS, sumC) * 180. / PI;
  float r = sqrt(sumS * sumS + sumC * sumC) / pop.size();
  float s = sqrt(-2. * log(r));
  return new PVector(m, s);
}
