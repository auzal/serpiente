
OscP5 oscColor;

color colorFondo;
int rojoRecibido;
int verdeRecibido;
int azulRecibido;

void iniciarRecepcionColor() {

  rojoRecibido = 100;
  verdeRecibido = 100;
  azulRecibido = 255;

  //levantarPuertosColor();
  Xprint( "->puerto OSC de color iniciado en "+puertoOSC_Color+"  idLuz="+idOSC_Color );

  oscColor = new OscP5( this, puertoOSC_Color );
}
//=============================================
/*
void levantarPuertosColor() {

  XML xml = loadXML("colorOSC.xml");

  XML[] hijo = xml.getChildren("colorOSC");
  if ( hijo.length>0 ) {
    idColor = hijo[0].getInt("idLuz");
    puertoColor = hijo[0].getInt("puerto");
  }
}*/
//=============================================
void oscEvent(OscMessage theOscMessage) {

  String patron = theOscMessage.addrPattern();
  if ( patron.equals( "/"+idOSC_Color+"/r") ) {
    rojoRecibido = theOscMessage.get(0).intValue();
  } else if ( patron.equals( "/"+idOSC_Color+"/g") ) {
    verdeRecibido = theOscMessage.get(0).intValue();
  } else if ( patron.equals( "/"+idOSC_Color+"/b") ) {
    azulRecibido = theOscMessage.get(0).intValue();
  }
}
