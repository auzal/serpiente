
class Sinusoide {

  float angulo;
  float vel;
  float amplitud;
  //----------------------------------------
  //VEL ES EN GRADOS (NO RADIANES)
  Sinusoide( float vel_, float amplitud_) {
    angulo = random(360);
    vel = vel_;
    amplitud = amplitud_;
  }
  //----------------------------------------

  void actualizar() {
    angulo += vel;
  }  
  //----------------------------------------

  void actualizar( float interpola ) {
    angulo += (vel * interpola);
  }  
  //----------------------------------------

  float valor( float centro, float limMin, float limMax ) {

    if ( centro+amplitud>limMax && centro-amplitud<limMin ) {
      centro = (limMin+limMax)/2.0;
    } else if ( centro+amplitud>limMax ) {
      centro = limMax-amplitud;
    } else if ( centro-amplitud<limMin ) {
      centro = limMin+amplitud;
    }

    return centro + amplitud * sin( radians( angulo ) );
  }
  //----------------------------------------

  float valor( float centro, float limMin, float limMax , float interpola ) {

    if ( centro+amplitud*interpola > limMax && 
    centro-amplitud*interpola < limMin ) {
      centro = (limMin+limMax)/2.0;
    } else if ( centro+amplitud*interpola > limMax ) {
      centro = limMax-amplitud*interpola;
    } else if ( centro-amplitud*interpola < limMin ) {
      centro = limMin+amplitud*interpola;
    }

    return centro + amplitud * interpola * sin( radians( angulo ) );
  }  
  //----------------------------------------
}
