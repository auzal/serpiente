
//---------------------------------------------------

void ejecutarModoNormal() {

  director.revisarSensores( receptorOSC );
  director.handleAnimator();
  if ( ejecutarAnimacionTextura ) {
    animacionPrueba.avanzar();
    //Acá ariel cargar el PImage en el texturizador

    //texturizador.cargarImagen( animacionPrueba.devolver() );
    texturizador.cargarImagen( director.animator.getImage());
  }
  float valor = constrain( map( mouseX, 200, width-200, 0, 1 ), 0.025, 1 );

  color colorFondo = color(100, 100, 255 );
  background(0);
  pushStyle();
  stroke(0);

  director.dibujarInteractivo( colorFondo, valor, 1+valor*2 );

  strokeWeight(2+valor*2);
  stroke( lerpColor( colorFondo, color(0), valor ) );
  director.dibujarLineas();
  stroke( lerpColor( colorFondo, color(255), valor ) );  
  director.dibujarSegmentos( 1+valor*10, 0.5+valor*0.5 );
  popStyle();
}
//---------------------------------------------------

void ejecutarModoTriangulos() {
  background(0);
  director.update();
  director.renderState();
  director.render();  
  imprimirBitacora();
}
//---------------------------------------------------

void ejecutarModoColores() {

  float valor = constrain( map( mouseX, 200, width-200, 0, 1 ), 0.025, 1 );

  color colorFondo = color(100, 100, 255 );
  background(0);
  pushStyle();
  stroke(0);
  //director.dibujarTriangulos();
  director.dibujarPlenosDeColor( colorFondo, valor, 1+valor*2 );
  //println( valor );

  strokeWeight(2+valor*2);
  stroke( lerpColor( colorFondo, color(0), valor ) );
  director.dibujarLineas();
  stroke( lerpColor( colorFondo, color(255), valor ) );  
  director.dibujarSegmentos( 1+valor*10, 0.5+valor*0.5 );
  popStyle();
}
//---------------------------------------------------

void ejecutarModoReceptor() {
  background( 100 );
  receptorOSC.dibujar( 100, 200 );
}
//---------------------------------------------------

void ejecutarModoTexturizador() {
  background(50);
  texturizador.dibujar(0, 0);
  noFill();
  stroke( 0, 255, 0 );
  texturizador.dibujarTriangulosEnMapa(0, 0);

  //texturizador.triangulos.get(0).texturizar();
  imprimirBitacora();
}
//---------------------------------------------------

void ejecutarModoTexturas() {
  background(0);
  pushStyle();
  strokeWeight(3);
  stroke(255);  
  if ( ejecutarAnimacionTextura ) {
    animacionPrueba.avanzar();
    texturizador.cargarImagen( animacionPrueba.devolver() );
    //Xprint("aca estoy");
  }
  texturizador.dibujarTriangulosEnPantalla( true );
  popStyle();
  imprimirBitacora();
}
//---------------------------------------------------

void ejecutarModoIdSensores() {

  director.revisarSensores( receptorOSC );

  background( 50 );
  pushStyle();
  stroke(255);
  fill(100);
  director.dibujarTriangulos();
  fill(0);
  director.dibujarTrianguloEnFocoID();
  fill(255, 255, 0, 100);
  noStroke();
  director.mostrarActivados();
  imprimirBitacora();

  popStyle();
}
//---------------------------------------------------
//Acá Ariel podés tener poner una vista de la animación sin texturizar (el PGraphics)

void ejecutarModoAnimacion() {
  director.handleAnimator();
  pushStyle();
  background( 0, 255, 0 );
  image(director.animator.getImage(), 0, 0);
  popStyle();
}
//---------------------------------------------------
