// actualizada 8/Jul/2019
//--------------------------------------------------------------------
// RitmoSeno
//
//  Emiliano Causa 2008
//  emiliano.causa@gmail.com
//  www.emiliano-causa.com.ar
//  www.biopus.com.ar
//
//--------------------------------------------------------------------

class RampaMilis {

  float valor;
  boolean enTransicion;
  float origen;
  float destino;
  long marcaInicio;
  int tiempo;
  //---------------------------------------

  RampaMilis( float valor_ ) {
    valor = valor_;
    enTransicion = false;
  }
  //---------------------------------------

  void irA( float nuevoValor, int tiempo_ ) {
    tiempo = tiempo_;
    marcaInicio = millis();
    origen = valor;
    destino = nuevoValor;
    enTransicion = true;
  }
  //---------------------------------------

  void asignar( float nuevoValor ) {
    valor = nuevoValor;
    enTransicion = false;
  }
  //---------------------------------------

  float devolverValor() {    
    if ( enTransicion ) {
      if( millis() > marcaInicio+tiempo ){
        valor = destino;
        enTransicion = false;
      }else{
        valor = map( millis() , marcaInicio , marcaInicio+tiempo,
        origen, destino );
      }
    }
    return valor;
  }
  //---------------------------------------
}
//--------------------------------------------------------------------
class RitmoSeno {

  float angulo;

  int cantidad;
  float ang1;
  float ang2;
  float minimo;
  float maximo;
  float paso;
  //-------------------------

  RitmoSeno( int cantidad_, float ang1_, float ang2_, float minimo_, float maximo_, float paso_ ) {
    cantidad = cantidad_;
    ang1 = ang1_;
    ang2 = ang2_;
    minimo = minimo_;
    maximo = maximo_;
    paso = paso_;
    iniciarEn( random(TWO_PI));
  }
  //-------------------------

  void iniciarEn( float angulo_ ) {
    angulo = angulo_;
  }
  //-------------------------

  void actualizar() {
    angulo += paso;
    angulo = ( angulo < 0 ? angulo+TWO_PI : angulo );
    angulo = ( angulo > TWO_PI ? angulo-TWO_PI : angulo );
  }
  //-------------------------

  float valor( int orden ) {
    return seno( orden, 0, cantidad, minimo, maximo, angulo+ang1, angulo+ang2 ); //esta en math2d
  }
}
// ------------------------------------------------------------------------------------------------
// MARCA: IMPULSO RANDOM - IMPULSO RANDOM - IMPULSO RANDOM - IMPULSO RANDOM - IMPULSO RANDOM -
// ------------------------------------------------------------------------------------------------
class ImpulsoRandom {

  float ciclo;
  float minimo;
  float maximo;
  float amplitud;
  float ultimoValor;
  float cont;

  //-------------------------

  ImpulsoRandom(float minimo_, float maximo_, float amplitud_) {
    iniciar( minimo_, maximo_, amplitud_ );
  }
  //-------------------------

  ImpulsoRandom(float minimo_, float maximo_ ) {
    iniciar( minimo_, maximo_, 1 );
  }
  //-------------------------

  void iniciar(float minimo_, float maximo_, float amplitud_) {
    minimo = minimo_;
    maximo = maximo_;
    ciclo = random( minimo, maximo );
    amplitud = amplitud_;
    cont = 0;
  }
  //-------------------------

  void cambiarLimites(float minimo_, float maximo_ ) {
    minimo = minimo_;
    maximo = maximo_;
    if (ciclo < minimo || ciclo > maximo) {
      ciclo = random( minimo, maximo );
    }
  }
  //-------------------------

  float valor() {
    cont++;
    if ( cont >= ciclo  ) {
      ultimoValor = amplitud;
      ciclo = random( minimo, maximo );
      cont = 0;
    } else {
      ultimoValor = 0;
    }
    return ultimoValor;
  }
  //-------------------------

  void string() {
    println(ultimoValor);
  }
}
// -------------------------------------------------------------------------------------------------------
//  MARCA: RAMPA - RAMPA - RAMPA - RAMPA - RAMPA - RAMPA - RAMPA - RAMPA - RAMPA - RAMPA - RAMPA - RAMPA -
// -------------------------------------------------------------------------------------------------------
class Rampa {

  float valor;
  int cont;
  float paso;

  //-------------------------

  Rampa() {
    cont = 0;
  }
  //-------------------------

  void irA(float valor_) {
    valor = valor_;
    cont = 0;
  }
  //-------------------------

  void irA( float nuevoValor, int cuantosFotogramas ) {
    cont = cuantosFotogramas;
    paso = (float)( nuevoValor - valor ) / cuantosFotogramas;
  }
  //-------------------------

  boolean finRampa() {
    return cont == 0;
  }
  //-------------------------

  float actualizar() {
    if (cont > 0) {
      cont--;
      valor += paso;
    }
    return valor;
  }
  //-------------------------

  void string() {
    println( valor );
  }
}
