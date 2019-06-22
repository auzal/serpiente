class Triangle {

  ArrayList <Point> points;


  Triangle(ArrayList <Point> p_) {

    points = new ArrayList();
    points = p_;
  }


  void render() {
    pushStyle();
    fill(255, 0, 98, 40);
    strokeWeight(2);
    stroke(255, 217, 0);
    beginShape();
    for (int i = 0; i < points.size(); i ++) {
      vertex(points.get(i).position.x, points.get(i).position.y);
    }
    endShape(CLOSE);
    popStyle();
  }
}
