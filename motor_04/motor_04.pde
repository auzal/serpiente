Director director;

void setup() {
  size(800, 800);
  //fullScreen();
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


void mousePressed() {

  // ACÁ ALGUNOS EJEMPLOS DE USO

  // la función getRandomTriangleIndex() devuelve una posición al azar del ArrayList de triángulos
  //int index = director.getRandomTriangleIndex();
  
  // la función findClosestTriangle(float x, float y) devuelve la posición del ArrayList de triángulos del triángulo más cercano al punto que le pases
  // int index = director.findClosestTriangle(mouseX, mouseY);
  
   // la función findTriangleById(int id) devuelve la posición del ArrayList de triángulos del triángulo que coincida con el ID que le pases
   int index = director.findTriangleById(3);

  if (index>=0) { // cualquiera de las funciones de arriba devuelve -1 si no hay triángulos o si el que pediste no existe
    color fill = color(random(255), random(255), random(255));
    color text = color(random(255));
    
    // la función setTriangleColors(int index, color fill, color text) fija los colores de relleno y texto del triángulo de posición index
    director.setTriangleColors(index, fill, text);
    String txt = "We’re not interested in futures, as in technical futures or scientific futures or technological futures, but more in alternative nows.";
    float speed = 7;
    
    // la función fireAnimation(int index, String txt, float speed) le pasa el String txt al triángulo de posición index, y dispara su animación espiral a velocidad igual a speed
    director.fireAnimation(index, txt, speed);
  }

  director.mousePressed();
}