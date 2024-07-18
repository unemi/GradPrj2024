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
