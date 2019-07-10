

PFont fuenteCarteles;
int CANT_MODOS = 8;

int MODO_NORMAL = 0;
int MODO_ESTADO = 1;
int MODO_TRIANGULOS = 2;
int MODO_RECEPTOR = 3;
int MODO_TEXTURIZADOR = 4;
int MODO_TEXTURAS = 5;
int MODO_ID_SENSORES = 6;
int MODO_ANIMACION = 7;

int MODO_COLORES = -1;

int modo = MODO_NORMAL;

int contCartel;
String textCartel[] = { 
  "NORMAL", "ESTADO", "TRIANGULOS", "RECEPTOR", "TEXTURIZADOR", 
  "TEXTURAS", "ID SENSORES", "ANIMACION", "MÁSCARA"
};

String nombreFuenteCartel = "Verdana-30.vlw"; 

boolean primerFotogramaEnEsteModo = true;

int xCartelPrimario = 50;
int yCartelPrimario = 80;
int xCartelSecundario = 50;
int yCartelSecundario = 110;
//--------------------------------------------

void reiniciarCartel() {
  contCartel = 60;
}
//--------------------------------------------

void iniciarCartel() {
  contCartel = 60;
  fuenteCarteles = loadFont( nombreFuenteCartel );
}
//---------------------------------------------------

void ejecutarTeclaCambioMenu() {
  if ( keyCode == CONTROL ) {
    modo = (modo+1) % CANT_MODOS;
    primerFotogramaEnEsteModo = true;
    iniciarCartel();
  }
}
//---------------------------------------------------

void mostrarCartel() {
  if ( contCartel > 0 ) {
    pushStyle();
    textFont( fuenteCarteles, 30 );
    contCartel--;
    fill( 255, 255, 0 );
    text( textCartel[ modo ], xCartelPrimario, yCartelPrimario );
    popStyle();
  }
}
//--------------------------------------------
void miDraw() {

  if ( modo == MODO_NORMAL ) {
    noCursor();
  } else {
    cursor();
  }

  if ( modo == MODO_NORMAL ) {
    ejecutarModoNormal();
  } else if ( modo == MODO_TRIANGULOS ) {
    ejecutarModoTriangulos();
  } else if ( modo == MODO_COLORES ) {
    ejecutarModoColores();
  } else if ( modo == MODO_RECEPTOR ) {
    ejecutarModoReceptor();
  } else if ( modo == MODO_TEXTURIZADOR ) {
    ejecutarModoTexturizador();
  } else if ( modo == MODO_TEXTURAS ) {
    ejecutarModoTexturas();
  } else if ( modo == MODO_ID_SENSORES ) {
    ejecutarModoIdSensores();
  } else if ( modo == MODO_ANIMACION ) {
    ejecutarModoAnimacion();
  } else if ( modo == MODO_ESTADO ) {
    ejecutarModoEstado();
  }

  primerFotogramaEnEsteModo = false;
}
//--------------------------------------------
