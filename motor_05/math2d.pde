// Actualizada al 2/Nov/2014 v10.0 (con proporcion punto linea)
// con urna
//------------------------------------------------------------------------------------------
// MARCA: FUNCIONES MATEMATICAS
//
// by Emiliano Causa 2008
// emiliano.causa@gmail.com
// www.emiliano-causa.com.ar
// www.biopus.com.ar
//====================================================================================
// class Punto
// class Promedio
// class Urna
// class Circulo
//====================================================================================

PVector crearPVectorDeAngulo( float angulo  ) {
  float dx = cos( angulo );
  float dy = sin( angulo );
  PVector v = new PVector( dx, dy );
  return v;
}
//------------------------------------------------------------------------------------------

float anguloPVector( PVector v ) {
  return atan2( v.y, v.x );
}
//------------------------------------------------------------------------------------------

float seno( float x, float x1, float x2, float y1, float y2, float ang1, float ang2 ) {
  float angulo = map( x, x1, x2, ang1, ang2 );
  float valor = sin( angulo );  
  return map( valor, -1, 1, y1, y2 );
}
//------------------------------------------------------------------------------------------

float linea( float x, float x1, float x2, float y1, float y2 ) {
  return (x-x1)/(x2-x1)*(y2-y1)+y1;
}
//---------------------------------------------------------------------------------------------------------------------------

float lineaLim( float x, float x1, float x2, float y1, float y2 ) {
  float valor = (x-x1)/(x2-x1)*(y2-y1)+y1;
  valor = min(valor, y2);
  valor = max(valor, y1);
  return valor;
}
// ------------------------------------------------------------------------------------------
// Funci√î√∏Œ©n que limite valores de √î√∏Œ©ngulos en [0;2*PI)
//
float limitarAnguloRad(float valor) {
  float nuevo = valor;
  for (int i=0; nuevo < 0 && i<100; i++) {
    nuevo += TWO_PI;
  }
  for (int i=0; nuevo >= TWO_PI && i<100; i++) {
    nuevo -= TWO_PI;
  }
  return nuevo;
}

//---------------------------------------------------------------------------------------------------------------------------

float menorDistAngulos( float origen, float destino ) {
  float distancia = destino - origen;
  return anguloRangoPI( distancia );
}
//---------------------------------------------------------------------------------------------------------------------------

float anguloRango2PI( float angulo ) {
  float este = angulo;

  for ( int i=0; i<100; i++ ) {
    if ( este >= TWO_PI ) {
      este -= TWO_PI;
    } 
    else if ( este < 0 ) {
      este += TWO_PI;
    }
    if ( este >= 0 && este <= TWO_PI ) {
      break;
    }
  }
  return este;
}
//---------------------------------------------------------------------------------------------------------------------------

float anguloRangoMenos2PI( float angulo ) {
  float este = angulo;

  for ( int i=0; i<100; i++ ) {
    if ( este > 0 ) {
      este -= TWO_PI;
    } 
    else if ( este <= -TWO_PI ) {
      este += TWO_PI;
    }
    if ( este > - TWO_PI && este <= 0 ) {
      break;
    }
  }
  return este;
}
//---------------------------------------------------------------------------------------------------------------------------

float anguloRangoPI( float angulo ) {
  float este = angulo;
  for ( int i=0; i<100; i++ ) {
    if ( este > PI ) {
      este -= TWO_PI;
    } 
    else if ( este <= -PI ) {
      este += TWO_PI;
    }
    if ( este >= -PI && este <= PI ) {
      break;
    }
  }
  return este;
}
//---------------------------------------------------------------------------------------------------------------------------
// MARCA: PUNTO - PUNTO - PUNTO - PUNTO - PUNTO - PUNTO - PUNTO - PUNTO - PUNTO - PUNTO - PUNTO - PUNTO - PUNTO - PUNTO -
//---------------------------------------------------------------------------------------------------------------------------
class Punto {
  float x, y;
  //--------------------------

  Punto() {
    iniciar( 0, 0 );
  }
  //--------------------------

  Punto( Punto otro ) {
    iniciar( otro.x, otro.y );
  }
  //--------------------------

  Punto( float x_, float y_ ) {
    iniciar( x_, y_ );
  }
  //--------------------------

  void iniciar( float x_, float y_ ) {
    x = x_;
    y = y_;
  }
  //--------------------------

  void copiarDe( Punto otro ) {
    x = otro.x;
    y = otro.y;
  }
  //--------------------------
  void string() {
    println( "(  "+x+"  ;   "+y+"  )");
  }
  //--------------------------

  void dibujarNormalizado( float x1, float y1, float w, float h, float ancho) {
    line( x1+(x*w)-ancho, y1+(y*h), x1+(x*w)+ancho, y1+(y*h) );
    line( x1+(x*w), y1+(y*h)-ancho, x1+(x*w), y1+(y*h)+ancho );
  }
  //--------------------------

  void dibujar() {
    float ancho = 20;
    line( x-ancho, y, x+ancho, y );
    line( x, y-ancho, x, y+ancho );
  }
  //--------------------------

  void dibujarCruz( ) {
    dibujarCruz( color(0, 255, 0), 20 );
  }
  //--------------------------

  void dibujarCirculo( color esteCol, float ancho ) {
    pushStyle();
    stroke( esteCol );
    ellipse( x, y, ancho*2, ancho*2 );
    popStyle();
  }
  //--------------------------

  void dibujarCruz( color esteCol, float ancho ) {
    pushStyle();
    stroke( esteCol );
    line( x-ancho, y, x+ancho, y );
    line( x, y-ancho, x, y+ancho );
    popStyle();
  }
  //--------------------------

  String toString() {
    return "(  "+x+"  ;   "+y+"  )";
  }
  //--------------------------
}
//--------------------------------  
float direccion( Punto a, Punto b ) {
  return atan2( b.y-a.y, b.x-a.x );
}
//--------------------------------  
float distancia( Punto a, Punto b ) {
  return dist( a.x, a.y, b.x, b.y );
}
//--------------------------------  
void dibujaLinea( Punto a, Punto b ) {
  line( a.x, a.y, b.x, b.y );
}
//--------------------------------  
Punto toPunto( float x, float y ) {
  Punto aux = new Punto( x, y );
  return aux;
}
//--------------------------------

Punto obtienePuntoPorProporcionEnLinea( Punto extremo1, Punto extremo2, float proporcion ) {
  Punto aux = new Punto();

  aux.x = map( proporcion, 0, 1, extremo1.x, extremo2.x );
  aux.y = map( proporcion, 0, 1, extremo1.y, extremo2.y );
  
  return aux;
}
//--------------------------------  

float devuelveProporcionPuntoEnLinea( Punto entrada, Punto extremo1, Punto extremo2 ) {

  float aperturaX = abs( extremo2.x - extremo1.x );
  float aperturaY = abs( extremo2.y - extremo1.y );  

  float proporcion = 0;

  if ( aperturaX > aperturaY ) {
    proporcion = map( entrada.x, extremo1.x, extremo2.x, 0, 1 );
  }
  else {
    proporcion = map( entrada.y, extremo1.y, extremo2.y, 0, 1 );
  }

  return proporcion;
}
//--------------------------------  
Punto obtieneCruceDosLineas( Punto p1, Punto p2, Punto p3, Punto p4 ) {
  Punto aux = null; //new Punto();
  boolean existe = false;

  float x = 0;
  float y = 0;

  float a = p2.y - p1.y;
  float b = p2.x - p1.x;
  float c = p4.y - p3.y;
  float d = p4.x - p3.x;

  if ( b != 0 && d != 0 ) {

    float ab = a/b;
    float cd = c/d;

    float e = p3.y - p1.y + p1.x*ab - p3.x*cd;

    float p = ab-cd;

    if ( p != 0) {
      x = e / p;
      y = map( x, p1.x, p2.x, p1.y, p2.y );
      existe = true;
    }
  } 
  else {
    if ( b == 0 && d != 0 ) {
      x = p1.x;
      y = map( x, p3.x, p4.x, p3.y, p4.y );
      existe = true;
    } 
    else if ( b != 0 && d == 0 ) {
      x = p3.x;
      y = map( x, p1.x, p2.x, p1.y, p2.y );
      existe = true;
    }
  }

  if ( existe ) {
    aux = new Punto(x, y);
  }

  return aux;
}
//---------------------------------------------------------------------------------------------------------------------------
// MARCA: PROMEDIO - PROMEDIO - PROMEDIO - PROMEDIO - PROMEDIO - PROMEDIO - PROMEDIO - PROMEDIO - PROMEDIO - PROMEDIO - 
//---------------------------------------------------------------------------------------------------------------------------
// Obtiene promedios en forma din√î√∏Œ©mica
class Promedio {
  float valor, incidencia, ultimo;
  int cont;
  int limite = 10000;
  //--------------------------------------------

  Promedio() {
    cont = 0;
    valor = 0;
    incidencia = 1;
  }
  //--------------------------------------------

  void agregar( float nuevo ) {
    cont++;
    ultimo = nuevo;
    if ( cont == 1 ) {
      valor = nuevo;
    } 
    else if ( cont>limite ) {
      incidencia = 1.0/limite;
      valor = valor * (1-incidencia) + nuevo * incidencia;
    } 
    else {
      incidencia = 1.0/cont;
      valor = valor * (1-incidencia) + nuevo * incidencia;
    }
  }
  //--------------------------------------------

  void reset( float nuevo ) {
    cont = 1;
    valor = nuevo;
  }
  //--------------------------------------------

  void reset( float nuevo, int cont_) {
    cont = cont_;
    valor = nuevo;
  }
  //--------------------------------------------

  void string() {
    println( "Valor = " + valor + "  | Incidencia = " + incidencia  + "  | Ultimo = " + ultimo );
  }
}
//--------------------------------------------------
class Urna {

  int cantidad;
  boolean urn[];
  int sacados;
  int cont;

  //-------------------------------------
  Urna( int cantidad_ ) {

    cantidad = cantidad_;
    urn = new boolean [cantidad];
    reset();
  }

  //-------------------------------------
  int sacar() {
    int resultado = -1;
    if ( ! vacia() ) {

      int tirada = int( random (cantidad));
      incrementar( tirada );    

      if ( !urn[ cont ] ) {

        urn[ cont ] = true;
        sacados ++;
        resultado = cont;
      } 
      else {
        boolean encontro = false;

        for (int i=0; i<cantidad && !encontro; i++) {

          incrementar( 1 );
          if ( !urn[cont] ) {
            urn[cont] = true;
            sacados ++;
            resultado = cont;
            encontro = true;
          }
        }
      }
    }
    return resultado;
  }
  //----------------------------

  boolean vacia() {
    return sacados>=cantidad;
  }
  //----------------------------

  void incrementar( int valor ) {
    cont = (cont+valor) % cantidad;
  }

  //--------------------------------

  void reset() {
    for (int i=0; i < cantidad; i++) {
      urn [i] = false;
    }
    sacados = 0;
    cont = 0;
  }
}
//====================================================================================

class Circulo {
  Punto centro;
  //float radio;
  float d;
  float r;

  float A, B, C;

  Circulo( float x_, float y_, float radio_ ) {
    centro = new Punto( x_, y_ );
    r = radio_;
    d = r*2.0;

    A = -2*x_;
    B = -2*y_;
    C = x_*x_ + y_*y_ - r*r;
  }


  Circulo( Punto p, float radio_ ) {
    centro = new Punto( p );
    r = radio_;
    d = r*2.0;

    A = -2*p.x;
    B = -2*p.y;
    C = p.x*p.x + p.y*p.y - r*r;
  }

  void dibujar() {    
    //println( " d = "+d);
    ellipse( centro.x, centro.y, d, d );
  }
}
//====================================================================================

Punto desdePuntoAngDist( Punto p, float angulo, float distancia ) {

  Punto aux = new Punto( p );

  float dx = distancia * cos( angulo );
  float dy = distancia * sin( angulo );

  aux.x += dx;
  aux.y += dy;

  return aux;
}
//====================================================================================

class InterseccionCirculos {

  Punto p1, p2;
  boolean existe;

  //------------------------------

  InterseccionCirculos( Punto cc1, Punto cc2, float radio1, float radio2 ) {
    Circulo c1 = new Circulo( cc1, radio1 );
    Circulo c2 = new Circulo( cc2, radio2 );
    iniciar( c1, c2 );
  }
  //------------------------------

  InterseccionCirculos( Circulo c1, Circulo c2, float sobreRadio ) {
    Circulo c_1 = new Circulo( c1.centro, c1.r+sobreRadio );
    Circulo c_2 = new Circulo( c2.centro, c2.r+sobreRadio );
    iniciar( c_1, c_2 );
  }
  //------------------------------

  InterseccionCirculos( Circulo c1, Circulo c2 ) {
    iniciar( c1, c2 );
  }
  //------------------------------

  void iniciar( Circulo c1, Circulo c2 ) {

    p1 = null;
    p2 = null;
    existe = false;
    //aca estoy restando las dos ecuaciones de los circulos
    // x2 + y2 + A1x + B1x + C1 = 0 (del circulo 1)
    // -
    // x2 + y2 + A2x + B2x + C2 = 0 (del circulo 2)
    // -------------------------
    //     (A1-A2) x + (B1-B2) y + (C1-C2) = 0
    //
    float A = c1.A - c2.A; 
    float B = c1.B - c2.B;
    float C = c1.C - c2.C;

    // Ax + By + C = 0 recta que pasa por los dos puntos de interseccion
    //println( "A="+A +" B="+B +" C="+C);

    float x1, x2, y1, y2;
    // Ecuacion de la linea recta
    //y = (-AX -C) / B
    //X = (-By -C) / A

    if ( B != 0 ) {

      x1 = 0;
      y1 = (-A*x1-C)/B;
      x2 = width;
      y2 = (-A*x2-C)/B;
      //line( x1, y1, x2, y2 );

      // Ahora pongo la ecuacion de la recta
      // y = (-AX -C) / B
      // en la de un circulo
      // x2 + y2 + Ac x + Bc y + Cc = 0
      // es decir:
      // x2 + [-AX-C)/B ]2 + Ac x + Bc [ (-AX-C)/B ] + Cc = 0
      // luego lleva esta ecuacion a la forma
      // aX2 + bX + c = 0 para aplicar la ecuacion cuadratica
      // x = (-b +- sqrt( b2-4ac ) )/2a
      //

      // ya que y = (-AX -C) / B entonces y2 = Dx2 + Ex + F
      // con los siguientes valores de D,E y F (los valores de A,B y C son de la recta)
      //
      float D = (A*A) / (B*B);
      float E = (2*A*C) / (B*B);
      float F = (C*C) / (B*B);

      // ya que y = (-AX -C) / B entonces y = Gx + H con:
      float G = -A / B;
      float H = -C / B;

      // entonces la ecuacion queda
      // x2 + Dx2 + Ex + F + Ac x + Bc.G x + Bc.H + Cc = 0
      // y por lo tanto, la forma a.x2 + b.x + c = 0 se compone asi:
      float a = 1 + D;
      float b = E + c1.A + G*c1.B;
      float c = F + H*c1.B + c1.C;

      //y aqui va la ecuacion cuadratica
      float delta = (b*b) - 4*a*c;

      if ( delta >= 0 ) { //sino entonces el resultado esta en el dominio de los imaginarios
        float xa = ( -b + sqrt( delta ) ) / (2*a);
        float xb = ( -b - sqrt( delta ) ) / (2*a);

        //line( xa, 0, xa, height );
        //line( xb, 0, xb, height );

        //y = (-AX -C) / B
        float ya = (-A*xa -C )/B;
        float yb = (-A*xb -C )/B;

        //ellipse( xa, ya, 20, 20 );
        //ellipse( xb, yb, 20, 20 );
        p1 = new Punto( xa, ya );
        p2 = new Punto( xb, yb );
        existe = true;
      }
    } 
    else if ( A!= 0 ) {

      y1 = 0;
      x1 = (-B*y1-C)/A;
      y2 = height;
      x2 = (-B*y2-C)/A;
      //line( x1, y1, x2, y2 );

      // Ahora pongo la ecuacion de la recta
      // X = (-By -C) / A
      // en la de un circulo
      // x2 + y2 + Ac x + Bc y + Cc = 0
      // es decir:
      // [ (-By -C) / A ]2 + y2 + Ac [ (-By -C) / A ] + Bc y + Cc = 0
      // luego lleva esta ecuacion a la forma
      // aX2 + bX + c = 0 para aplicar la ecuacion cuadratica
      // x = (-b +- sqrt( b2-4ac ) )/2a
      //

      // ya que x = (-By -C) / A entonces x2 = Dy2 + Ey + F
      // con los siguientes valores de D,E y F (los valores de A,B y C son de la recta)
      //
      float D = (B*B) / (A*A);
      float E = (2*B*C) / (A*A);
      float F = (C*C) / (A*A);

      // ya que x = (-By -C) / B entonces x = Gy + H con:
      float G = -B / A;
      float H = -C / A;

      // entonces la ecuacion queda
      // Dy2 + Ey + F + y2 + Ac[G.y+H] + Bc.y + Cc = 0
      // y por lo tanto, la forma a.x2 + b.x + c = 0 se compone asi:
      float a = 1 + D;
      float b = E + c1.A * G + c1.B;
      float c = F + H*c1.A + c1.C;

      //y aqui va la ecuacion cuadratica
      float delta = (b*b) - 4*a*c;

      if ( delta >= 0 ) { //sino entonces el resultado esta en el dominio de los imaginarios
        float ya = ( -b + sqrt( delta ) ) / (2*a);
        float yb = ( -b - sqrt( delta ) ) / (2*a);

        //line( width, ya, 0, ya );
        //line( width, yb, 0, yb );

        //X = (-By -C) / A
        float xa = (-B*ya -C) / A;
        float xb = (-B*yb -C) / A;

        //ellipse( xa, ya, 20, 20 );
        //ellipse( xb, yb, 20, 20 );
        p1 = new Punto( xa, ya );
        p2 = new Punto( xb, yb );
        existe = true;
      }
    }
  }
}
//====================================================================================
// Linea - Linea - Linea - Linea - Linea - Linea - Linea - Linea - Linea - Linea -
//====================================================================================

class Linea {

  Punto p1, p2;

  //----------------------------------

  Linea( Punto p1_, Punto p2_ ) {
    p1 = p1_;
    p2 = p2_;
  }
  //----------------------------------

  void dibujar() {
    line( p1.x, p1.y, p2.x, p2.y );
  }
  //----------------------------------

  String toString() {
    return p1.toString()+"-"+p2.toString();
  }
  //----------------------------------

  Linea alReves() {
    Linea r = new Linea( p2, p1 );
    return r;
  }
  //----------------------------------
}
//====================================================================================

Punto cruceDosSegmentos( Linea l1, Linea l2 ) {

  Punto aux = null;

  Punto p = obtieneCruceDosLineas( l1.p1, l1.p2, l2.p1, l2.p2 );

  if ( p != null ) {    
    if ( puntoPerteneceASegmento( p, l1 ) && puntoPerteneceASegmento( p, l2 ) ) {
      aux = p;
    }
  }

  return aux;
}
//====================================================================================

boolean puntoPerteneceASegmento( Punto p, Linea l ) {

  boolean pertenece = false;
  float precision = 0.01;

  if ( l.p1.x > l.p2.x ) {
    //print("1-");

    if ( p.x <= l.p1.x && p.x >= l.p2.x ) {
      float y = map( p.x, l.p1.x, l.p2.x, l.p1.y, l.p2.y );
      //print("2-");
      if ( y >= p.y-precision && y <= p.y+precision ) {
        //print("3-");
        pertenece = true;
      }
    }
  } 
  else if ( l.p1.x < l.p2.x ) {
    //print("4-");
    if ( p.x <= l.p2.x && p.x >= l.p1.x ) {
      float y = map( p.x, l.p1.x, l.p2.x, l.p1.y, l.p2.y );
      //print("5-");
      if ( y >= p.y-precision && y <= p.y+precision ) {
        //print("6-");
        pertenece = true;
      }
    }
  } 
  else {
    //print("7-");
    if ( p.x >= l.p1.x-0.00001 && p.x <= l.p2.x+0.00001 ) {
      //print("8-");
      if ( p.y >= l.p2.y && p.y <= l.p1.y ) {
        //print("9-");
        pertenece = true;
      } 
      else if ( p.y >= l.p1.y && p.y <= l.p2.y ) {
        //print("10-");
        pertenece = true;
      }
    }
  }
  //println(".");
  return pertenece;
}
//====================================================================================
// MARCA: Secuencia Segmentos - Secuencia Segmentos - Secuencia Segmentos - 
//====================================================================================

class SecuenciaSegmentos {

  ArrayList <Linea> s;

  Punto anterior = null;  
  //----------------------------------

  SecuenciaSegmentos() {
    s = new ArrayList<Linea>();
  }
  //----------------------------------

  void agregar( Punto p ) {

    if ( anterior != null ) {
      Linea l = new Linea( anterior, p );
      s.add( l );
    }
    anterior = p;
  }
  //----------------------------------

  void agregar( Linea l ) {
    s.add( l );
  }
  //----------------------------------

  void dibujar() {
    for ( int i=0; i<s.size (); i++ ) {
      Linea l = s.get(i);
      l.dibujar();
    }
  }
  //----------------------------------

  int getCantidad() {
    return s.size();
  }
  //----------------------------------

  Linea getLinea( int orden ) {
    return s.get( orden );
  }
  //----------------------------------
}
//====================================================================================
// MARCA: CruceDeFormas - CruceDeFormas - CruceDeFormas - CruceDeFormas - 
//====================================================================================

class CruceDeFormas {

  ArrayList <PuntoDeCruce> puntos;

  //----------------------------------

  CruceDeFormas( SecuenciaSegmentos formaA, SecuenciaSegmentos formaB ) {

    puntos = new ArrayList <PuntoDeCruce> ();

    for ( int i=0; i<formaA.getCantidad (); i++ ) {

      Linea lineaA = formaA.getLinea( i );
      //println( lineaA );

      for ( int j=0; j<formaB.getCantidad (); j++ ) {

        Linea lineaB = formaB.getLinea( j );

        Punto p = cruceDosSegmentos( lineaA, lineaB );

        if ( p != null ) {
          //p.dibujarCruz();
          //println( p );
          PuntoDeCruce pdc = new PuntoDeCruce( i, j, p );
          puntos.add( pdc );
        }
      }
    }
  }
  //----------------------------------

  int getCantidad() {
    return puntos.size();
  }
  //----------------------------------

  PuntoDeCruce getPuntoDeCruce( int orden ) {
    return puntos.get( orden );
  }
  //----------------------------------

  void imprimir() {
    for ( int i=0; i<getCantidad (); i++ ) {
      println( getPuntoDeCruce(i) );
    }
  }
  //----------------------------------

  PuntoDeCruce buscarCruceEnA( int indice ) {

    PuntoDeCruce aux = null;

    for ( int i=0; i<getCantidad (); i++ ) {
      PuntoDeCruce esteCruce = getPuntoDeCruce( i );
      if ( esteCruce.indiceEnA == indice ) {
        aux = esteCruce;
      }
    }

    return aux;
  }
  //----------------------------------

  PuntoDeCruce buscarCruceEnB( int indice ) {

    PuntoDeCruce aux = null;

    for ( int i=0; i<getCantidad (); i++ ) {
      PuntoDeCruce esteCruce = getPuntoDeCruce( i );
      if ( esteCruce.indiceEnB == indice ) {
        aux = esteCruce;
      }
    }

    return aux;
  }
  //----------------------------------
}
//====================================================================================
// MARCA: CruceDeFormas - Punto de Cruce
//====================================================================================
class PuntoDeCruce {

  int indiceEnA, indiceEnB;
  Punto punto;
  //----------------------------------

  PuntoDeCruce( int indiceEnA_, int indiceEnB_, Punto punto_ ) {
    indiceEnA = indiceEnA_;
    indiceEnB = indiceEnB_;
    punto = punto_;
  }  
  //----------------------------------

  String toString() {
    return "A["+indiceEnA+"] B["+indiceEnB+"] punto"+punto.toString();
  }
  //----------------------------------
}
//====================================================================================

SecuenciaSegmentos obtieneFormaPorCruce( SecuenciaSegmentos uno, SecuenciaSegmentos dos, 
int indiceUno, boolean unoHorario, boolean dosHorario ) {

  SecuenciaSegmentos nueva = new SecuenciaSegmentos();

  CruceDeFormas cruce = new CruceDeFormas( uno, dos );

  if ( cruceConBuenaForma( cruce ) ) {


    //
    //if( monitor ) println( "puntos de cruce = "+cruce.getCantidad() );

    int limiteUno = uno.getCantidad();
    int limiteDos = dos.getCantidad();

    //if( monitor ) println( "puntos de cruce = "+cruce.getCantidad() );
    //if ( monitor ) cruce.imprimir();

    String estado = "uno";
    boolean finalizo = false;
    boolean inicio = true;

    indiceUno = indiceUno % limiteUno;

    int indiceEnUno = indiceUno;
    int indiceEnDos = 0;

    //if ( monitor ) println( "inicio = "+indiceEnUno );

    for ( int i=0; i<10000 && !finalizo; i++ ) {

      if ( i>1000 ) {
        println("=====================================");
        println("=====================================");
        println("ERROR: cantidad excesiva de segmentos" );
        println("=====================================");
        println("=====================================");
        break;
      }

      if ( estado.equals( "uno" ) ) {
        //===============================
        // UNO HORARIO
        //===============================
        if ( unoHorario ) { //uno sentido horario

            indiceEnUno ++;
          if ( indiceEnUno >= limiteUno ) {
            indiceEnUno = 0;
          }

          PuntoDeCruce p = cruce.buscarCruceEnA( indiceEnUno );

          if ( p!=null ) { //este punto esta en el cruce

            //finalizo = true;
            estado = "dos";
            indiceEnDos = p.indiceEnB;

            //if ( monitor ) println("1H->DOS uno = "+indiceEnUno+"     | dos = "+indiceEnDos);

            Linea esta = uno.getLinea( indiceEnUno );
            Linea otra = new Linea( esta.p1, p.punto );
            nueva.agregar( otra );


            esta = dos.getLinea( indiceEnDos );
            if ( dosHorario ) {
              otra = new Linea( p.punto, esta.p2 );
            } 
            else {
              otra = new Linea( p.punto, esta.p1 );
            }

            nueva.agregar( otra );
          } 
          else { //este punto NO esta en el cruce

              if ( indiceEnUno == indiceUno ) {
              finalizo = true;
              Linea esta = uno.getLinea( indiceEnUno );
              nueva.agregar( esta );
            } 
            else {
              Linea esta = uno.getLinea( indiceEnUno );
              nueva.agregar( esta );
            }
          }
        } 
        else {  //uno sentido ANTI-horario

          //===============================
          // UNO ANTI-HORARIO
          //===============================
          //print(">-"+indiceEnUno);
          indiceEnUno --;
          if ( indiceEnUno < 0 ) {
            indiceEnUno = limiteUno-1;
          }

          PuntoDeCruce p = cruce.buscarCruceEnA( indiceEnUno );


          if ( p!=null ) { //este punto esta en el cruce

            //finalizo = true;
            estado = "dos";
            indiceEnDos = p.indiceEnB;

            //if ( monitor ) println("1A->DOS uno = "+indiceEnUno+"     | dos = "+indiceEnDos);

            Linea esta = uno.getLinea( indiceEnUno );

            Linea otra = new Linea( esta.p2, p.punto );
            nueva.agregar( otra );


            esta = dos.getLinea( indiceEnDos );
            //Linea inversa = esta.alReves();
            if ( dosHorario ) {
              otra = new Linea( p.punto, esta.p2 );
            } 
            else {
              otra = new Linea( p.punto, esta.p1 );
            }

            nueva.agregar( otra );
          } 
          else { //este punto NO esta en el cruce

              if ( indiceEnUno == indiceUno ) {              
              finalizo = true;
              Linea esta = uno.getLinea( indiceEnUno );
              Linea inversa = esta.alReves();
              nueva.agregar( inversa );
              //nueva.agregar( esta );
            } 
            else {
              //print("2"+indiceEnUno);
              Linea esta = uno.getLinea( indiceEnUno );
              Linea inversa = esta.alReves();
              nueva.agregar( inversa );
              //nueva.agregar( esta );
            }
          }
        }
      } 
      else if ( estado.equals( "dos" ) ) {
        //===============================
        // DOS HORARIO
        //===============================

        if ( dosHorario ) { //dos sentido horario

            indiceEnDos ++;
          if ( indiceEnDos >= limiteDos ) {
            indiceEnDos = 0;
          }

          PuntoDeCruce p = cruce.buscarCruceEnB( indiceEnDos );

          if ( p!=null ) { //este punto esta en el cruce

            //finalizo = true;
            estado = "uno";
            indiceEnUno = p.indiceEnA;

            //if ( monitor ) println("2H->UNO uno = "+indiceEnUno+"     | dos = "+indiceEnDos);

            Linea esta = dos.getLinea( indiceEnDos );
            Linea otra = new Linea( esta.p1, p.punto );
            nueva.agregar( otra );

            // agregado
            if ( indiceEnUno == indiceUno ) {
              finalizo = true;
            }
            //FIN agregado

            esta = uno.getLinea( indiceEnUno );
            if ( unoHorario ) {
              otra = new Linea( p.punto, esta.p2 );
            } 
            else {
              otra = new Linea( p.punto, esta.p1 );
            }
            nueva.agregar( otra );
          } 
          else { //este punto NO esta en el cruce

              Linea esta = dos.getLinea( indiceEnDos );
            nueva.agregar( esta );
          }
        } 
        else {  //dos sentido ANTI-horario
          //===============================
          // DOS ANTI-HORARIO
          //===============================

          indiceEnDos --;
          if ( indiceEnDos < 0 ) {
            indiceEnDos = limiteDos-1;
          }

          PuntoDeCruce p = cruce.buscarCruceEnB( indiceEnDos );

          if ( p!=null ) { //este punto esta en el cruce

            //finalizo = true;
            estado = "uno";
            indiceEnUno = p.indiceEnA;

            //if ( monitor ) println("2A->UNO uno = "+indiceEnUno+"     | dos = "+indiceEnDos);

            Linea esta = dos.getLinea( indiceEnDos );
            Linea otra = new Linea( esta.p2, p.punto );
            nueva.agregar( otra );

            esta = uno.getLinea( indiceEnUno );

            // agregado
            if ( indiceEnUno == indiceUno ) {
              finalizo = true;
            }
            //FIN agregado

            if ( unoHorario ) {
              otra = new Linea( p.punto, esta.p2 );
            } 
            else {
              otra = new Linea( p.punto, esta.p1 );
            }
            nueva.agregar( otra );
          } 
          else { //este punto NO esta en el cruce

              Linea esta = dos.getLinea( indiceEnDos );
            Linea inversa = esta.alReves();
            nueva.agregar( inversa );
          }
        }
      }
    }
  } 
  else {

    println("=========================================");
    println("ERROR: el cruce no cumple con buena forma");
    println("=========================================");
  }

  return nueva;
}
//------------------------------------------------

boolean cruceConBuenaForma( CruceDeFormas cruce ) {
  boolean buenaForma = true;

  if ( cruce.getCantidad() % 2 != 0 ) {
    buenaForma = false;
    println("=========================================");
    println("ERROR: cruce con cantidad de punto IMPAR ");
    println("=========================================");
  } 
  else {

    boolean hayRepeticion = false;    

    for ( int i=0; i<cruce.getCantidad ()-1; i++ ) {
      PuntoDeCruce este = cruce.getPuntoDeCruce( i );
      for ( int j=i+1; j<cruce.getCantidad (); j++ ) {
        PuntoDeCruce otro = cruce.getPuntoDeCruce( j );

        if ( este.indiceEnA == otro.indiceEnA || este.indiceEnB == otro.indiceEnB ) {
          hayRepeticion = true;
          break;
        }
      }
    }
    if ( hayRepeticion ) {
      buenaForma = false;
      println("=========================================");
      println("ERROR: cruce con PUNTOS REPETIDOS ");
      println("=========================================");
    }
  }  

  return buenaForma;
}