
int puertoOSC_inSensor = 12344;//12345

int puertoOSC_Color = 7000;//8000
int idOSC_Color = 2;//1

int puertoOSC_Estado = 8999; //9000
String direccionOSC_Estado = "127.0.0.1";
String identidadOSC_Estado = "centro";

int puertoOSC_InPing = 9999;//10000

String direccionOSC_OutPong = "127.0.0.1";
int puertoOSC_OutPong = 7500;


void iniciarPuertosOSC(){
  
  XML xml = loadXML("puertosOSC.xml");

  XML[] hijo = xml.getChildren("inColorOSC");
  if ( hijo.length>0 ) {
    idOSC_Color = hijo[0].getInt("idLuz");
    puertoOSC_Color = hijo[0].getInt("puerto");
    Xprint( "->Dato cargado: idOSC_Color = "+ idOSC_Color);
    Xprint( "->Dato cargado: puertoOSC_Color = "+ puertoOSC_Color);
  }
 
  hijo = xml.getChildren("inSensorOSC");
  if ( hijo.length>0 ) {    
    puertoOSC_inSensor = hijo[0].getInt("puerto");
    Xprint( "->Dato cargado: puertoOSC_inSensor = "+ puertoOSC_inSensor);
  }
  
  hijo = xml.getChildren("outPongOSC");
  if ( hijo.length>0 ) {
    direccionOSC_OutPong = hijo[0].getString("direccion");
    puertoOSC_OutPong = hijo[0].getInt("puerto");
    Xprint( "->Dato cargado: direccionOSC_OutPong = "+ direccionOSC_OutPong);
    Xprint( "->Dato cargado: puertoOSC_OutPong = "+ puertoOSC_OutPong);
  }
  
  hijo = xml.getChildren("inPingOSC");
  if ( hijo.length>0 ) {    
    puertoOSC_InPing = hijo[0].getInt("puerto");
    Xprint( "->Dato cargado: puertoOSCInPing = "+ puertoOSC_InPing);
  }
  
  hijo = xml.getChildren("outEstadoOSC");
  if ( hijo.length>0 ) {
    direccionOSC_Estado = hijo[0].getString("direccion");
    puertoOSC_Estado = hijo[0].getInt("puerto");
    identidadOSC_Estado = hijo[0].getString("identidad");
    Xprint( "->Dato cargado: direccionOSC_Estado = "+ direccionOSC_Estado);
    Xprint( "->Dato cargado: puertoOSC_Estado = "+ puertoOSC_Estado);
    Xprint( "->Dato cargado: identidadOSC_Estado = "+ identidadOSC_Estado);
  }
}
