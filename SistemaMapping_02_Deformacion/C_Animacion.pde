/*
clase Animacion - v1.1 Emiliano Causa 25/jun/2019
*/
class Animacion {

  String etiqueta;
  String nombre;
  int desde, hasta;
  String formato;
  int decimales;

  float cual = 0;
  boolean fin = false;
  boolean enLoop = true;
  boolean detenido = false;

  long marca;
  float milisXfoto;
  float fps;
  //-------------------------------------------------

  Animacion( String etiqueta_, String nombre_, int desde_, int hasta_, int decimales_, 
    String formato_ ) {
    nombre = nombre_;
    desde = desde_;
    hasta = hasta_;
    decimales = decimales_;
    formato = formato_;
    cual = desde;
    fin = false;
    etiqueta = etiqueta_;
    ajustarFPS( 60 );    
  }
  //-------------------------------------------------
  
  void ajustarFPS( float fps_ ){
    fps = fps_;
    milisXfoto = 1000.0/fps;
  }
  //-------------------------------------------------

  void avanzar() {

    if ( !detenido ) {

      long diferencia = millis()-marca;
      float avance = diferencia/milisXfoto;
      if ( int(avance)>0 ) {
        cual += avance;
        marca = millis();
      }

      fin = !(int(cual)<hasta);

      if ( fin ) {
        if ( enLoop ) {
          cual = desde;
        } else {
          cual = hasta-1;
          detenido = true;
        }
      }

    }
  }
  //-------------------------------------------------

  PImage devolver() {
    String nombreCompleto = nombre+nf(int(cual), decimales)+formato;
    return loadImage( nombreCompleto );
  }  
  //-------------------------------------------------

  void dibujar( float x, float y, float w, float h ) {
    image( devolver(), x, y, w, h );
  }
  //-------------------------------------------------

  void iniciar( boolean enLoop_ ) {
    detenido = false;
    enLoop = enLoop_;
    cual = desde;
    marca = millis();
  }
  //-------------------------------------------------

  void iniciar() {
    iniciar( true);
  }
  //-------------------------------------------------

  void continuar() {
    detenido = true;
  }
  //-------------------------------------------------

  void detener() {
    detenido = true;
  }
  //-------------------------------------------------
}
