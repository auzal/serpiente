Director director;

void setup() {
  size(800,800);
  pixelDensity(displayDensity());
  director = new Director();
  director.loadPoints();
  director.loadTriangles();
}


void draw() {
  String sketch_name = getClass().getName() + ".pde";
  String title = sketch_name + " " + "RUNNING AT " + int(frameRate) + " fps";
  surface.setTitle(title);
  background(0);
  director.update();
  director.render();
}

void keyPressed() {

  director.keyPressed();
}

void keyReleased() {

  director.keyReleased();
}


void mousePressed(){

  director.mousePressed();
}
