int TAMANIO_FUENTE = 20;

class EntradaInt {

  String estado;
  int valor;

  //-------------------------------------------------

  EntradaInt() {
    iniciar(0);
  }
  //-------------------------------------------------

  EntradaInt( int valor ) {
    iniciar( valor );
  }
  //-------------------------------------------------

  void iniciar( int valor_ ) {
    valor = valor_;
    estado = "espera";
  }
  //-------------------------------------------------

  void dibujar( float x, float y ) {
    pushStyle();
    noFill();
    rectMode( CORNER );
    rect( x, y, TAMANIO_FUENTE * 6, TAMANIO_FUENTE );
    text( valor, x, y+TAMANIO_FUENTE );
    popStyle();
  }
  //-------------------------------------------------

  void editar() {
    estado = "edicion";
  }
  //-------------------------------------------------

  void ejecutarTecla() {
    if ( estado.equals("edicion") ) {
      if ( key>='0' && key<='9' ) {
        valor *= 10;
        valor += int( key-'0' );
      } else if ( key == BACKSPACE ) {
        valor = valor/10;
      } else if ( key == ENTER || key == RETURN ) {
        estado = "espera";
      }
    }
  }
  //-------------------------------------------------
  
  boolean estaEnEspera(){
    return estado.equals("espera");
  }
  //-------------------------------------------------
}
