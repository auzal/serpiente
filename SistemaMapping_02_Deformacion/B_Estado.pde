
int TIEMPO_RAMPA_SUBIR_NIVEL = 2000;
float NIVEL_MINIMO_ACTIVACION = 0.05;

String estado;
float nivelActivacionMapping = 0;

RampaMilis rampaNivel;
EntradaInt umbralAltoActivacion; 
EntradaInt umbralBajoDesactivacion; 
String modoMenuEstado;

OscP5 oscEstado;
NetAddress direccionDeEnvioEstado; 
//--------------------------------------------------------

void iniciarEstado() {
  rampaNivel = new RampaMilis( NIVEL_MINIMO_ACTIVACION );
  estado = "espera";
  modoMenuEstado = "normal";
  umbralAltoActivacion = new EntradaInt( 5 );
  umbralBajoDesactivacion = new EntradaInt( 2 );
  levantarVariablesConfiguracion();

  oscEstado = new OscP5(this, puertoOSC_Estado+1);
  direccionDeEnvioEstado = new NetAddress( direccionOSC_Estado, puertoOSC_Estado );
  Xprint("->puerto OSC Estado iniciado en "+puertoOSC_Estado );
  Xprint("->puerto OSC Estado direccion remota "+direccionOSC_Estado );
}
//--------------------------------------------------------

void mostrarAyudaEstado() {
  Xprint("======================");
  Xprint("Ayuda de Modo Texturas");
  Xprint("H - Ayuda ");
  Xprint("1 - edita Umbral Alto");
  Xprint("2 - edita Umbral Bajo");
}
//--------------------------------------------------------

void ejecutarTeclasEstado() {

  if ( modoMenuEstado.equals( "normal" ) ) {
    if ( key=='1' ) {
      umbralAltoActivacion.editar();
      modoMenuEstado = "umbralAlto";
    } else if ( key=='2' ) {
      umbralBajoDesactivacion.editar();
      modoMenuEstado = "umbralBajo";
    } else if ( key=='g' ) {
      guardarVariablesConfiguracion();
      Xprint("->Configuración guardada");
    }
  } else if ( modoMenuEstado.equals( "umbralAlto" ) ) {
    umbralAltoActivacion.ejecutarTecla();
    if ( umbralAltoActivacion.estaEnEspera() ) {
      modoMenuEstado = "normal";
    }
  } else if ( modoMenuEstado.equals( "umbralBajo" ) ) {
    umbralBajoDesactivacion.ejecutarTecla();
    if ( umbralBajoDesactivacion.estaEnEspera() ) {
      modoMenuEstado = "normal";
    }
  }
}
//--------------------------------------------------------

void ejecutarEstados() {

  director.revisarSensores( receptorOSC );

  if ( estado.equals("espera") ) {

    if ( director.revisarTriangulosActivados() >= 
      umbralAltoActivacion.valor ) {

      rampaNivel.irA( 1, TIEMPO_RAMPA_SUBIR_NIVEL );
      estado = "activo";
      enviarEstado();
    }
  } else if ( estado.equals("activo") ) {

    if ( director.revisarTriangulosActivados() < 
      umbralBajoDesactivacion.valor ) {

      rampaNivel.irA( NIVEL_MINIMO_ACTIVACION, TIEMPO_RAMPA_SUBIR_NIVEL );
      estado = "espera";
      enviarEstado();
    }
  }

  nivelActivacionMapping = rampaNivel.devolverValor();
}
//--------------------------------------------------------

void guardarVariablesConfiguracion() {

  PrintWriter output;
  output = createWriter("data/configuracionGeneral.xml");
  output.println("<xml>");
  output.println("<umbral_alto valor='"+umbralAltoActivacion.valor+"'></umbral_alto>");
  output.println("<umbral_bajo valor='"+umbralBajoDesactivacion.valor+"'></umbral_bajo>");
  output.println("</xml>");
  output.flush();
  output.close();
}
//--------------------------------------------------------

void levantarVariablesConfiguracion() {
  XML xml = loadXML("configuracionGeneral.xml");

  XML[] hijo = xml.getChildren("umbral_alto");
  if ( hijo.length>0 ) {
    umbralAltoActivacion.iniciar( hijo[0].getInt("valor") );
  }

  hijo = xml.getChildren("umbral_bajo");
  if ( hijo.length>0 ) {
    umbralBajoDesactivacion.iniciar( hijo[0].getInt("valor") );
  }
}
//--------------------------------------------------------

void enviarEstado(){
  OscMessage mensaje = new OscMessage( "/"+identidadOSC_Estado );
  mensaje.add( estado );
  oscEstado.send( mensaje , direccionDeEnvioEstado );
}
//--------------------------------------------------------
