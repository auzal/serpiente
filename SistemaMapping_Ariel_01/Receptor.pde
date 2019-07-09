
import oscP5.*;
import netP5.*;

ReceptorOSC receptorOSC;
int CANTIDAD_DE_IDS = 100;
//-----------------------------------------
void iniciarReceptor() {
  receptorOSC = new ReceptorOSC();
}
//-----------------------------------------

class ReceptorOSC {
  OscP5 oscP5;

  boolean activado[];
  color figura[];
  color fondo[];
  //-------------------------------------------------

  ReceptorOSC() {
    oscP5 = new OscP5(this, 12345);
    oscP5.plug(this, "entra", "/zona/entra");
    oscP5.plug(this, "sale", "/zona/sale");

    activado = new boolean[ CANTIDAD_DE_IDS ];
    figura = new color[ CANTIDAD_DE_IDS ];
    fondo = new color[ CANTIDAD_DE_IDS ];

    for ( int i=0; i<CANTIDAD_DE_IDS; i++ ) {
      activado[i] = false;
    }
  }
  //-------------------------------------------------
  /*void dibujar() {
   if (entroMensaje) {
   fill(c);
   rect(0, 0, 200, 200);
   }
   }*/

  void dibujar( float left, float top ) {
    pushMatrix();    
    translate( left, top );
    for ( int i=0; i<CANTIDAD_DE_IDS; i++ ) {
      if ( activado[i] ) {
        pushStyle();
        float ancho = textWidth( ""+i ) * 1.2;
        float tamanio = textAscent()*1.2;
        fill( 0 ); //fondo[i] ); 
        rect( 0, 0, ancho, tamanio );
        fill( 255 ); //figura[i] );
        text( i+"", ancho*0.1, tamanio*0.8);
        translate( ancho+textWidth(" "), 0 );
        popStyle();
      }
    }
    popMatrix();
  }
  //-------------------------------------------------

  public void entra(int zona) {
    //println("llego");
    if ( zona>=0 && zona<CANTIDAD_DE_IDS ) {
      activado[ zona ] = true;
      /* OJO: NO VOLVER A HACER ESTO NUUUUUNNNNCA MAS
      pushStyle();
      colorMode( HSB );
      figura[zona] = color( random(255), 255, 255 );
      fondo[zona] = color( (hue(figura[zona])+127)%256, 155, 55 );
      popStyle();
      */
    }
  }
  //-------------------------------------------------

  public void sale(int zona) {
    if ( zona>=0 && zona<CANTIDAD_DE_IDS ) {
      activado[zona] = false;
    }
  }
  //-------------------------------------------------
  
  boolean estaActivado( int idSensor ){
    boolean resultado = false;
    if( idSensor>=0 && idSensor < CANTIDAD_DE_IDS ){
      resultado = activado[ idSensor ];
    }
    return resultado;
  }
  //-------------------------------------------------
}
//=============================================
