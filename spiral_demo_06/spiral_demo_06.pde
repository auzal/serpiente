ArrayList <Point> points;
Triangle t;

void setup() {
  size(800, 800);
  points = new ArrayList();
  Point aux = new Point(200, 200, 0);
  points.add(aux);
  aux = new Point(700, 50, 1);
  points.add(aux);
  aux = new Point(450, 600, 2);
  points.add(aux);
  t = new Triangle(points);
  t.setFont(createFont("data/nevis.ttf", 30));
}

void draw() {
  background(0);
  t.update();
  t.render();
  t.renderContour();
  t.renderSpiral();
}

void mousePressed() {
  String text = "Nunca olvides que lo unico que un rico te va a dar es siempre mas pobreza.";
  float animation_speed = 5;
  t.fireAnimation(text, animation_speed);
}



void keyPressed(){
t.step();}
