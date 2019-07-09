
float MIN_VEL_SEGMENTOS = 1.0/( 60.0 * 4 ); //4  seg 
float MAX_VEL_SEGMENTOS = 1.0/( 60.0 * 2 ); //2 seg

class Segmento {

  Point a;
  Point b;

  float posicion;
  float velocidad;
  boolean direccion = true;
  //---------------------------------------------------

  Segmento( Point uno_, Point dos_ ) {

    if ( uno_.id > dos_.id ) {
      a = dos_;
      b = uno_;
    } else {
      a = uno_;
      b = dos_;
    }

    posicion = random(1);
    velocidad = random( MIN_VEL_SEGMENTOS, MAX_VEL_SEGMENTOS );
  }
  //---------------------------------------------------

  void dibujarSegmento( float factorVelocidad, float tamanio ) {

    posicion += (velocidad * factorVelocidad);
    if ( posicion>1 || posicion <-tamanio ) {
      posicion = -tamanio;
      direccion = random(100)<50;
    }


    float x1 =  lerp( a.position.x, b.position.x, max(posicion, 0) );
    float y1 =  lerp( a.position.y, b.position.y, max(posicion, 0) );

    float x2 =  lerp( a.position.x, b.position.x, min(posicion+tamanio, 1) );
    float y2 =  lerp( a.position.y, b.position.y, min(posicion+tamanio, 1) );

    if ( direccion ) {
      x1 =  lerp( b.position.x, a.position.x, max(posicion, 0) );
      y1 =  lerp( b.position.y, a.position.y, max(posicion, 0) );

      x2 =  lerp( b.position.x, a.position.x, min(posicion+tamanio, 1) );
      y2 =  lerp( b.position.y, a.position.y, min(posicion+tamanio, 1) );
    }
    line( x1, y1, x2, y2 );
  }
  //---------------------------------------------------

  void dibujar() {
    line( a.position.x, a.position.y, b.position.x, b.position.y );
  }
  //---------------------------------------------------

  boolean esIgual( Point uno_, Point dos_ ) {
    boolean resultado = false;
    if ( uno_.id > dos_.id ) {
      if ( a.id == dos_.id && b.id == uno_.id ) {
        resultado = true;
      }
    } else {
      if ( a.id == uno_.id && b.id == dos_.id ) {
        resultado = true;
      }
    }
    return resultado;
  }
  //---------------------------------------------------
}
