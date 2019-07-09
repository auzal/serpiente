/* BITACORA *****************************************************
 22 / 02 / 2015
 ******************************************************/
boolean monitorBitacora = true;
boolean bitacoraEfimera = true;
long marca;
int tiempoBitacora = 4000;

color colorBitacora;
int offsetOpcionalLeft = 200;
int leftBitacota = 50;
int topBitacora = 50;
int tamanioFuenteBitacora = 20;
int cantidadLineasBitacora = 15;

String nombreFuenteBitacora = "Verdana-20.vlw";
CajaTexto bitacora;

boolean shiftPressed = false;
//--------------------------------------------
/*

 en el setup()
 iniciarFuenteBitacora();
 
 en keyPressed()
 ejecutarTeclasBitacora();
 
 en draw()
 imprimirBitacora();
 
 */
//--------------------------------------------

void iniciarFuenteBitacora() {

  bitacora = new CajaTexto( nombreFuenteBitacora, tamanioFuenteBitacora, 
    cantidadLineasBitacora*10, cantidadLineasBitacora );
  colorBitacora = color(255);
}
//--------------------------------------------

void Xprint( ) {
  Xprint( "" );  
}//--------------------------------------------

void Xprint( float num ) {
  Xprint( num+"" );  
}
//--------------------------------------------

void Xprint( String linea ) {

  if ( monitorBitacora ) {
    bitacora.agregar( linea );
    marca = millis();
  } else {
    println( linea );
  }  
}

//--------------------------------------------

void XSprint( String linea ) {

  if ( monitorBitacora ) {
    bitacora.sobreEscribir( linea );
    marca = millis();
  } else {
    println( linea );
  }
}
//--------------------------------------------

void XprintArchivo( String nombreArchivo ) {
  String lines[] = loadStrings( nombreArchivo );
  for (int i = 0; i < lines.length; i++) {
    Xprint(lines[i]);
  }
}
//--------------------------------------------

void soltarTeclaBitacora() {
  if (keyCode == SHIFT ) {
    shiftPressed = false;
  }
}
//--------------------------------------------

void ejecutarTeclasBitacora() {

  if (key == CODED) {
    if (keyCode == SHIFT ) {
      shiftPressed = true;
    } else if (keyCode == UP && shiftPressed ) {
      bitacora.arriba();
    } else if (keyCode == DOWN && shiftPressed ) {
      bitacora.abajo();
    } else if (keyCode == 33 ) {//pageUp
      bitacora.paginaArriba();
    } else if (keyCode == 34 ) {//pageDown
      bitacora.paginaAbajo();
    }
    //Xprint( "kc->"+int( keyCode ) );
  } else {
    if ( key == 8  && shiftPressed ) { //BACKSPACE
      bitacora.clear();
    }
    //Xprint( int( key ) );
  }
}
//--------------------------------------------

void imprimirBitacora() {

  if ( monitorBitacora ) {
    if ( millis() < marca +  tiempoBitacora || !bitacoraEfimera ) {
      pushStyle();
      fill( colorBitacora );
      bitacora.imprimir( leftBitacota, topBitacora );
      popStyle();
    }
  }
}
//--------------------------------------------

void imprimirBitacora( float x, float y ) {

  if ( monitorBitacora ) {
    if ( millis() < marca +  tiempoBitacora || !bitacoraEfimera ) {
      pushStyle();
      fill( colorBitacora );
      bitacora.imprimir( x, y );
      popStyle();
    }
  }
}

//---------------------------------------------
// version 1.00 actualizada al 29/Oct/2012
// Emiliano Causa @2012
// emiliano.causa@gmail.com
//---------------------------------------------

class CajaTexto {

  int total;
  String lineas[];
  PFont fuente;
  int cantidad;

  int tamanioFuente;
  int lineasVisibles;
  int ultimo;
  int offset;
  int paginar;

  //----------------------------------

  CajaTexto( String nombreFuente, int tamanioFuente_, int cantidadLineas, int lineasVisibles_ ) {

    total = cantidadLineas;
    lineas = new String[ total ];
    for ( int i=0; i<total; i++) lineas[i]="";
    cantidad = 0;
    ultimo = 0;
    lineasVisibles = lineasVisibles_;
    fuente = loadFont( nombreFuente );
    tamanioFuente = tamanioFuente_;
    offset = 0;
    paginar = lineasVisibles-1;
  }
  //----------------------------------

  void sobreEscribir( String linea ) {

    if ( cantidad>0 ) {
      int donde = ( ultimo==0 ? total-1 : ultimo-1 );
      lineas[ donde ] = linea;
    }
  }
  //----------------------------------

  void agregar( String linea ) {

    lineas[ ultimo ] = linea;   
    if ( cantidad < total ) {
      cantidad++;
    }
    ultimo = (ultimo+1) % total;
  }
  //----------------------------------

  int corrige( int posi ) {
    if ( posi<0 ) {
      return posi+total;
    } else {
      return posi;
    }
  }

  //----------------------------------

  void imprimir( float left, float top ) {

    pushStyle();
    textFont( fuente, tamanioFuente );

    int cuantos = 0;    
    int desde = 0;

    if ( cantidad <= lineasVisibles ) {
      cuantos = cantidad;
      desde = 0;
    } else {
      cuantos = lineasVisibles;
      desde = ultimo-cuantos-offset;
    }

    for ( int i=0; i<cuantos; i++ ) {
      float y = top + (i+1)*tamanioFuente*1.5;
      text( lineas[ corrige(desde+i) ], left, y );
    }
    popStyle();
  }
  //----------------------------------

  void abajo() {
    if ( offset > 0 ) offset--;
  }
  //----------------------------------

  void arriba() {
    int movilidad = min( total, cantidad )-lineasVisibles;
    if ( offset < movilidad ) offset++;
  }
  //----------------------------------

  void clear() {
    cantidad = 0;
    ultimo = 0;
    offset = 0;
  }  
  //----------------------------------

  void reset() {
    offset = 0;
  }  
  //----------------------------------

  void paginaAbajo() {

    if ( offset > paginar ) {
      offset -= paginar;
    } else {
      offset = 0;
    }
  }
  //----------------------------------

  void paginaArriba() {

    int movilidad = min( total, cantidad )-lineasVisibles;
    if ( offset < movilidad-paginar ) {
      offset += paginar;
    } else {
      offset = movilidad;
    }
  }
  //----------------------------------

  void guardar( String nombreArchivo ) {

    String ordenados[];
    ordenados = new String[ cantidad+1 ];

    ordenados[0] = ( cantidad < total ? "<INICIO>" : ("...<incompleto>") );

    for ( int i=0; i<cantidad; i++ ) {
      ordenados[i+1] = lineas[ corrige( ultimo-cantidad+i ) ];
    }

    saveStrings( nombreArchivo, ordenados );
  }
}
