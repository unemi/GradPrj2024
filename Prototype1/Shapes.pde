void cone(float r, float h) {
  beginShape(TRIANGLE_FAN);
  vertex(0, -h / 2, 0);
  for (int i = 0; i <= 32; i ++) {
    float th = i * TWO_PI / 32.;
    vertex(r * cos(th), h / 2, r * sin(th));
  }
  endShape();
}
void cylinder(float r, float h) {
  beginShape(TRIANGLE_FAN);
  vertex(0, -h / 2, 0);
  for (int i = 0; i <= 32; i ++) {
    float th = i * TWO_PI / 32.;
    vertex(r * cos(th), -h / 2, r * sin(th));
  }
  endShape();
  beginShape(TRIANGLE_STRIP);
  for (int i = 0; i <= 32; i ++) {
    float th = i * TWO_PI / 32.;
    vertex(r * cos(th), -h / 2, r * sin(th));
    vertex(r * cos(th), h / 2, r * sin(th));
  }
  endShape();
}
void pentaPrism(float s, float h) {
  beginShape(TRIANGLE_STRIP);
  vertex(-s/2, -h, -s/2);
  vertex(-s/2, -h, s/2);
  vertex(s/4, -h, -s/2);
  vertex(s/4, -h, s/2);
  vertex(s*3/4, -h, 0);
  endShape();
  beginShape(TRIANGLE_STRIP);
  vertex(-s/2, 0, -s/2);
  vertex(-s/2, -h, -s/2);
  vertex(-s/2, 0, s/2);
  vertex(-s/2, -h, s/2);
  vertex(s/4, 0, s/2);
  vertex(s/4, -h, s/2);
  vertex(s*3/4, 0, 0);
  vertex(s*3/4, -h, 0);
  vertex(s/4, 0, -s/2);
  vertex(s/4, -h, -s/2);
  vertex(-s/2, 0, -s/2);
  vertex(-s/2, -h, -s/2);
  endShape();
}
