// EMILIANO: en esta solapa están todos los cambios que hice para la deformacion de triangulos, tanto en la clase texturizador como textri

Texturizador texturizador;
Animacion animacionPrueba;
boolean ejecutarAnimacionTextura;
//===========================================================

void iniciarTexturizador() {

  texturizador = new Texturizador();
  texturizador.cargarImagen( loadImage("grilla.jpg") );
  //texturizador.agregar(100, 200, 300, 100, 200, 500);
  //( String etiqueta_, String nombre_, int desde_, int hasta_, int decimales_, 
  //String formato_ )
  animacionPrueba = new Animacion( "prueba", "animatexto/foto", 1, 880, 5, 
    ".jpg" );
  ejecutarAnimacionTextura = false;
}
//===========================================================

void mostrarAyudaTexturas() {
  //bitacora.clear();
  Xprint("======================");
  Xprint("Ayuda de Modo Texturas");
  Xprint("H - Ayuda");
  Xprint("T - texturiza triangulos");
  Xprint("A - ejecuta animación");
  Xprint("S - imagen grilla");
}
//===========================================================

void ejecutarTeclasTexturas() {
  if ( key == 'h' ) {
    mostrarAyudaTexturas();
  } else if ( key == 't' ) {
    director.cargarTriangulosEnMapping( texturizador );
    Xprint( "-> triangulos cargados en texturas" );
  } else if ( key == 'a' ) {  
    ejecutarAnimacionTextura = true;
  } else if ( key == 's' ) {  
    ejecutarAnimacionTextura = false;
    texturizador.cargarImagen( loadImage("grilla.jpg") );
  }

  texturizador.teclas();
}
//===========================================================

class Texturizador {

  float ancho;
  float alto;
  PImage imagen;

  ArrayList <Textri> triangulos;

  int select_index;
  int point_select;

  //-----------------------------------

  Texturizador() {
    reset();
    point_select = 1;
    select_index = 0;
  }
  //-----------------------------------

  void cargarImagen( PImage imagen_ ) {
    imagen = imagen_;
    ancho = imagen.width;
    alto = imagen.height;
  }
  //-----------------------------------

  void dibujar( float left, float top ) {
    image( imagen, left, top );
  }
  //-----------------------------------

  void reset() {
    triangulos = new ArrayList();
  }
  //-----------------------------------

  Textri agregar( float x1, float y1, float x2, float y2, float x3, float y3, 
    int idTriangulo ) {

    Textri nuevo = null;

    float minX = min( x1, min( x2, x3 ));
    float maxX = max( x1, max( x2, x3 ));
    float minY = min( y1, min( y2, y3 ));
    float maxY = max( y1, max( y2, y3 ));

    float cx = (x1+x2+x3)/3.0;
    float cy = (y1+y2+y3)/3.0;

    float anchoT = maxX-minX;
    float altoT = maxY-minY;

    if ( anchoT < ancho && altoT < alto ) {
      float x = random( ancho-anchoT );
      float y = random( alto-altoT );

      float xd1 = map(x + x1 - minX, 0, ancho, 0, 1 );
      float yd1 = map(y + y1 - minY, 0, alto, 0, 1 );
      float xd2 = map(x + x2 - minX, 0, ancho, 0, 1 );
      float yd2 = map(y + y2 - minY, 0, alto, 0, 1 );
      float xd3 = map(x + x3 - minX, 0, ancho, 0, 1 );
      float yd3 = map(y + y3 - minY, 0, alto, 0, 1 );

      nuevo = new Textri( this, x1, y1, x2, y2, x3, y3, 
        xd1, yd1, xd2, yd2, xd3, yd3, idTriangulo );
    }
    if ( nuevo != null ) {
      triangulos.add( nuevo );
    }

    return nuevo;
  }
  //-----------------------------------

  void dibujarTriangulosEnMapa( float left, float top ) {
    for ( Textri t : triangulos ) {
      t.dibujarEnMapaTextura( left, top, ancho, alto );
    }
  }
  //-----------------------------------

  void dibujarTriangulosEnPantalla( boolean distinguir ) {
    for ( Textri t : triangulos ) {
      if ( distinguir ) {
        tint( t.distinguidor );
      }
      t.texturizar();
    }
    if (triangulos.size() >0) {
      triangulos.get(select_index).dibujarSelector();
      fill(0, 255, 255, 50);
      stroke(0, 255, 255);
      triangulos.get(select_index).dibujarEnMapaTextura(0, 0, ancho, alto);
      triangulos.get(select_index).dibujarSelectorVertice(0, 0, ancho, alto, point_select);
    }
  }
  //-----------------------------------

  void teclas() {
    if (triangulos.size() > 0) {

      if (key == TAB) {

        select_index ++;
        select_index = select_index % triangulos.size();
      }

      if (key == '1') {
        point_select = 1;
      } else if (key == '2') {
        point_select = 2;
      } else if (key == '3') {
        point_select = 3;
      }

      if (key == CODED) {
        PVector delta = new PVector(0, 0);
        int offset = 2;
        if (keyCode == LEFT) {
          delta = new PVector(-offset, 0);
        } else if (keyCode == RIGHT) {
          delta = new PVector(offset, 0);
        } else if (keyCode == UP) {
          delta = new PVector(0, -offset);
        } else if (keyCode == DOWN) {
          delta = new PVector(0, offset);
        }
        delta.x = delta.x/ancho;
        delta.y = delta.y/alto;

        if (point_select == 1) {
          triangulos.get(select_index).xt1 += delta.x;
          triangulos.get(select_index).yt1 += delta.y;
        } else if (point_select == 2) {
          triangulos.get(select_index).xt2 += delta.x;
          triangulos.get(select_index).yt2 += delta.y;
        } else if (point_select == 3) {
          triangulos.get(select_index).xt3 += delta.x;
          triangulos.get(select_index).yt3 += delta.y;
        }
      }
    }
  }

  //-----------------------------------

  void mouseDragged() {
    PVector delta = new PVector(mouseX - pmouseX, mouseY - pmouseY);

    delta.x = delta.x/ancho;
    delta.y = delta.y/alto;

    if (point_select == 1) {
      triangulos.get(select_index).xt1 += delta.x;
      triangulos.get(select_index).yt1 += delta.y;
    } else if (point_select == 2) {
      triangulos.get(select_index).xt2 += delta.x;
      triangulos.get(select_index).yt2 += delta.y;
    } else if (point_select == 3) {
      triangulos.get(select_index).xt3 += delta.x;
      triangulos.get(select_index).yt3 += delta.y;
    }
  }
}
//==============================================================

class Textri {

  float x1, y1, x2, y2, x3, y3;
  float xt1, yt1, xt2, yt2, xt3, yt3;
  Texturizador texturizador;
  color distinguidor;

  int idTriangulo;
  //-----------------------------------

  Textri( Texturizador texturizador_, 
    float x1_, float y1_, float x2_, float y2_, float x3_, float y3_, 
    float xt1_, float yt1_, float xt2_, float yt2_, float xt3_, float yt3_, 
    int idTriangulo_ ) {

    idTriangulo = idTriangulo_;

    texturizador = texturizador_;
    x1 = x1_;
    x2 = x2_;
    x3 = x3_;
    y1 = y1_;
    y2 = y2_;
    y3 = y3_;

    xt1 = xt1_;
    xt2 = xt2_;
    xt3 = xt3_;
    yt1 = yt1_;
    yt2 = yt2_;
    yt3 = yt3_;

    float piso = 200;

    distinguidor = color( random( piso, 255 ), random( piso, 255 ), 
      random( piso, 255 ) );
  }
  //-----------------------------------

  void dibujarEnMapaTextura( float left, float top, float ancho, float alto ) {
    triangle( 
      left+xt1*ancho, 
      top+yt1*alto, 
      left+xt2*ancho, 
      top+yt2*alto, 
      left+xt3*ancho, 
      top+yt3*alto
      );
  }
  //-----------------------------------

  void texturizar() {
    pushStyle();
    stroke(255);
    textureMode( NORMAL );
    beginShape();
    texture( texturizador.imagen );
    vertex( x1, y1, xt1, yt1 );
    vertex( x2, y2, xt2, yt2 );
    vertex( x3, y3, xt3, yt3 );  
    endShape();
    popStyle();
  }
  //-----------------------------------

  void dibujarSelector() {
    pushStyle();
    strokeWeight(4);
    stroke(255, 0, 0);
    fill(255, 0, 0, 40);

    beginShape();

    vertex( x1, y1 );
    vertex( x2, y2 );
    vertex( x3, y3);  
    endShape(CLOSE);
    popStyle();
  }

  //-----------------------------------

  void dibujarSelectorVertice( float left, float top, float ancho, float alto, int select ) {
    pushStyle();
    noFill();
    strokeWeight(2);
    stroke(255, 255, 0);  
    PVector pos = new PVector(0, 0);
    if (select == 1) {
      pos = new PVector(xt1, yt1);
    } else if (select == 2) {
      pos = new PVector(xt2, yt2);
    } else if (select == 3) {
      pos = new PVector(xt3, yt3);
    }

    ellipse(pos.x*ancho, pos.y*alto, 20, 20);

    popStyle();
  }
}
