Director director;

//-------------------------------------------------
void setup() {
  size(1280, 800, P3D);
  //fullScreen();
  //pixelDensity(displayDensity());

  iniciarFuenteBitacora();
  iniciarPuertosOSC();
  iniciarEstado();
  iniciarReceptor();
  iniciarCartel();  
  iniciarDirector();
  iniciarTexturizador();
  iniciarRecepcionColor();
}
//-------------------------------------------------
void draw() {


  String sketch_name = getClass().getName() + ".pde";
  String title = sketch_name + " " + "RUNNING AT " + int(frameRate) + " fps";
  surface.setTitle(title);


  miDraw();  
  mostrarCartel();
}
//-------------------------------------------------
void keyPressed() {
  ejecutarTeclaCambioMenu();

  if ( modo != MODO_TRIANGULOS ) {
    ejecutarTeclasBitacora();
  }

  if ( key==' ' ) {
    receptorOSC.activado[66] = true;
  }

  if ( modo == MODO_NORMAL ) {
  } else if ( modo == MODO_TRIANGULOS ) {
    director.keyPressed();
    ejecutarTeclasModoTriangulos();
  } else if ( modo == MODO_ID_SENSORES ) {
    if ( key=='h' ) {
      mostrarAyudaIdSensores();
    } else if ( key=='g' ) {
      director.saveTriangles();
      Xprint("->Triangulos guardados");
    }
    director.ejecutarTeclasID();
  } else if ( modo == MODO_ESTADO ) {
    if ( key=='h' ) {
      mostrarAyudaEstado();
    }
    ejecutarTeclasEstado();
  }
}
//-------------------------------------------------
void keyReleased() {
  soltarTeclaBitacora();

  if ( key==' ' ) {
    receptorOSC.activado[66] = false;
  }

  if ( modo == MODO_NORMAL ) {
  } else if ( modo == MODO_TRIANGULOS ) {
    director.keyReleased();
  } else if ( modo == MODO_TEXTURIZADOR || modo == MODO_TEXTURAS ) {
    ejecutarTeclasTexturas();
  } else if ( modo == MODO_ID_SENSORES ) {
    director.soltarTeclasID();
  }
}
//-------------------------------------------------
void mousePressed() {

  if ( modo == MODO_TRIANGULOS ) {
    director.mousePressed();
    ejecutarTeclasBitacora();
  }

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
    float speed = 17;

    // la función fireAnimation(int index, String txt, float speed) le pasa el String txt al triángulo de posición index, y dispara su animación espiral a velocidad igual a speed
    director.fireAnimation(index, txt, speed);
  }
}
//-------------------------------------------------

// EMILIANO: esta es nueva, permite arrastar con el mouse los vertices de deformacion para que no sea tan lento todo.

void mouseDragged() {
   if ( modo == MODO_TEXTURIZADOR || modo == MODO_TEXTURAS ) {
    texturizador.mouseDragged();
  }
}
