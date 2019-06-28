class Point {

  PVector position;
  boolean selected;
  boolean shift;
  int id;

  //••••••••••••••••••••••••••••••••••••••••••

  Point(float x, float y, int id_) {
    position = new PVector(x, y);
    shift = false;
    selected = false;
    id = id_;
  }

  //••••••••••••••••••••••••••••••••••••••••••

  void render() {
    pushStyle();
    rectMode(CENTER);
    pushMatrix();
    translate(position.x, position.y);
    noFill();
    strokeWeight(1);
    stroke(255);
    point(0, 0);
    rect(0, 0, 15, 15);
    pushMatrix();
    for (int i = 0; i < 4; i++) {
      rotate(i*HALF_PI);
      line
        (5, 0, 15, 0);
    }
    popMatrix();
    pushMatrix();
    translate( 20, -20);
    float w = textWidth(str(id).toUpperCase()) + 5;
    float h = textAscent() + textDescent() + 5;
    textAlign(CENTER, CENTER);
    fill(128, 90);
    noStroke();
    rect( w/2, h/2, w, h);
    fill(255);
    text(str(id), w/2, h/2-2);
    popMatrix();
    popMatrix();
    popStyle();
  }

  //••••••••••••••••••••••••••••••••••••••••••

  void select() {
    selected = true;
  }

  //••••••••••••••••••••••••••••••••••••••••••

  void deselect() {
    selected = false;
  }

  //••••••••••••••••••••••••••••••••••••••••••

  void renderMarker() {
    pushStyle();
    pushMatrix();
    translate(position.x, position.y);
    fill(255, 0, 128);
    noStroke();
    rotate(radians(frameCount*2));
    for (int i = 0; i < 4; i++) {
      rotate(i*HALF_PI);
      triangle(20, 0, 30, 3, 30, -3);
    }
    popMatrix();
    popStyle();
  }

  //••••••••••••••••••••••••••••••••••••••••••

  void keyPressed() {
    if (keyCode == SHIFT) {
      shift = true;
    } else if (keyCode == LEFT) {
      if (shift)
        position.x -=10;
      else
        position.x --;
    } else if (keyCode == RIGHT) {
      if (shift)
        position.x +=10;
      else
        position.x ++;
    } else if (keyCode == UP) {
      if (shift)
        position.y -=10;
      else
        position.y --;
    } else if (keyCode == DOWN) {
      if (shift)
        position.y +=10;
      else
        position.y ++;
    }
  }

  //••••••••••••••••••••••••••••••••••••••••••

  void keyReleased() {
    if (keyCode == SHIFT) {
      shift = false;
    }
  }

  //••••••••••••••••••••••••••••••••••••••••••

  void setPosition(PVector p) {
    position = p;
  }

  //••••••••••••••••••••••••••••••••••••••••••

  PVector getPVector() {

    return position;
  }

  //••••••••••••••••••••••••••••••••••••••••••
}
