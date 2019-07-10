float MIN_VEL_SINSAT = 1;
float MAX_VEL_SINSAT = 3;
float MIN_AMP_SINSAT = 0;
float MAX_AMP_SINSAT = 120;

float MIN_VEL_SINBRILLO = 1;
float MAX_VEL_SINBRILLO = 3;
float MIN_AMP_SINBRILLO = 0;
float MAX_AMP_SINBRILLO = 120;


class Triangle {

  ArrayList <Point> points;
  ArrayList <PVector> spiral_points;
  int spiral_steps = 4;
  String txt ="";
  int text_tracking = 0;
  float text_offset = 0;
  int new_line_spacing = 20;
  PFont font;
  float animation_speed = 0;
  boolean animating;
  boolean selected;
  boolean text_has_entered = false;
  boolean text_written = false;
  int char_count = 0;
  PVector center;
  int id;
  color triangle_color;
  color text_color;
  float internal_offset;

  Sinusoide sinSatura;
  Sinusoide sinBrillo;

  Textri textura;
  IntList listaID;
  boolean conSensoresActivados = false;
  color colorVariado;
  //••••••••••••••••••••••••••••••••••••••••••

  Triangle(ArrayList <Point> p_, int id_) {

    points = new ArrayList();
    points = p_;
    spiral_points = new ArrayList();
    spiral_points = calculateSpiralPoints(points.get(0).getPVector(), points.get(1).getPVector(), points.get(2).getPVector(), 4);
    id = id_;
    triangle_color = color(0);
    text_color = color(255);

    sinSatura = new Sinusoide( random(MIN_VEL_SINSAT, MAX_VEL_SINSAT), 
      random(MIN_AMP_SINSAT, MAX_AMP_SINSAT) );

    sinBrillo = new Sinusoide( random(MIN_VEL_SINBRILLO, MAX_VEL_SINBRILLO), 
      random(MIN_AMP_SINBRILLO, MAX_AMP_SINBRILLO) );

    textura = null;
    listaID = new IntList();
  }

  //••••••••••••••••••••••••••••••••••••••••••

  void update() {
    spiral_points = calculateSpiralPoints(points.get(0).getPVector(), points.get(1).getPVector(), points.get(2).getPVector(), 4);
    if (animating) {
      step();
    }
  }

  //••••••••••••••••••••••••••••••••••••••••••

  void step() {
    if (text_written) {
      text_offset += animation_speed;
    } else {
      if (char_count < txt.length()) {

        char_count ++;
      } else {
        char_count = txt.length();
        text_written = true;
      }
    }
    //   println(text_offset);
  }

  //••••••••••••••••••••••••••••••••••••••••••

  void render() {

    pushStyle();

    fill(triangle_color);
    noStroke();

    beginShape();
    for (int i = 0; i < points.size(); i ++) {
      vertex(points.get(i).position.x, points.get(i).position.y);
    }
    endShape(CLOSE);

    if (animating) {
      textAlign(LEFT, BOTTOM);

      int point_index = 0;
      float distance_acum = 0;

      textFont(font);

      boolean text_inside = true;

      float text_offset_aux = text_offset;

      // calculo si aun hay texto adentro del espiral, y en que segmento tengo que arrancar

      for (int i = 0; i < spiral_points.size(); i++) {
        PVector start;
        PVector end;
        if (i < spiral_points.size()-1) {
          start = spiral_points.get(i);
          end = spiral_points.get(i+1);
        } else {
          text_inside = false;
          break;
        }
        float segment_length = dist(start.x, start.y, end.x, end.y);
        if (text_offset_aux >= segment_length) {
          text_offset_aux -= segment_length;
        } else {
          point_index = i;
          distance_acum = text_offset_aux + new_line_spacing;
          // println("--> " + distance_acum + "  " + point_index);
          break;
        }
      }


      if (!text_inside) {
        animating = false;
      }


      if (animating) {

        // ESTE BLOQUE DIBUJA EL TEXTO PROPIAMENTE DICHO

        for (int i = 0; i < char_count; i++) {

          PVector start = spiral_points.get(point_index);
          PVector end = spiral_points.get(point_index+1);
          float text_ang = atan2(end.y - start.y, end.x - start.x);
          float segment_length = dist(start.x, start.y, end.x, end.y);

          float char_w = textWidth(txt.charAt(i)); 

          if (distance_acum + (char_w) + 5 > segment_length) {
            if (point_index < spiral_points.size() - 2 ) {
              point_index++;
              distance_acum = max(((distance_acum  - segment_length)+new_line_spacing), 0 );
              start = spiral_points.get(point_index);
              end = spiral_points.get(point_index+1);
              text_ang = atan2(end.y - start.y, end.x - start.x);
              segment_length = dist(start.x, start.y, end.x, end.y);
            } else {
              break;
            }
          }


          pushMatrix();
          translate(start.x, start.y);
          //  println(distance_acum);
          rotate(text_ang);
          translate(distance_acum, 0);

          distance_acum +=char_w + text_tracking;
          fill(text_color);
          text(txt.charAt(i), 0, 0);
          // ellipse(0, 0, 5, 5);
          popMatrix();
        }
      }
      // HASTA ACA
    }
    popStyle();
  }


  //••••••••••••••••••••••••••••••••••••••••••

  void renderContour() {
    pushStyle();
    fill(255, 0, 98, 20);
    strokeWeight(1);
    stroke(255, 217, 0);
    beginShape();
    for (int i = 0; i < points.size(); i ++) {
      vertex(points.get(i).position.x, points.get(i).position.y);
    }
    endShape(CLOSE);
    pushMatrix();
    translate(center.x, center.y);
    translate( 20, -20);
    float w = textWidth(str(id).toUpperCase()) + 5;
    float h = textAscent() + textDescent() + 5;
    textAlign(CENTER, CENTER);
    rectMode(CENTER);
    fill(128, 90);
    noStroke();
    rect( w/2, h/2, w, h);
    fill(255, 128, 0);
    text(str(id), w/2, h/2-2);
    popMatrix();

    if (selected) {
      strokeWeight(5);
      stroke(255, 255, 0);
      for (int i = 0; i < points.size(); i ++) {
        PVector start = points.get(i).position;
        PVector end = points.get((i+1) % (points.size())).position;
        dashedLine(start.x, start.y, end.x, end.y, 10);
      }
      fill(255, 255, 0, 40);
      noStroke();
      beginShape();
      for (int i = 0; i < points.size(); i ++) {
        vertex(points.get(i).position.x, points.get(i).position.y);
      }
      endShape(CLOSE);
    }

    popStyle();
  }

  //••••••••••••••••••••••••••••••••••••••••••

  void renderSpiral() {

    pushStyle();
    stroke(250, 35, 118);
    strokeWeight(1);
    for (int i = 0; i < spiral_points.size()-1; i ++) {
      PVector start = spiral_points.get(i);
      PVector end = spiral_points.get(i+1);
      line(start.x, start.y, end.x, end.y);
      PVector mid = new PVector(lerp(start.x, end.x, 0.5), lerp(start.y, end.y, 0.5));
      float ang = atan2(end.y - start.y, end.x - start.x);
      pushMatrix();
      translate(mid.x, mid.y);
      rotate(ang-HALF_PI);
      line(0, 0, 10, 0);
      popMatrix();
    }

    popStyle();
  }

  //••••••••••••••••••••••••••••••••••••••••••

  ArrayList <PVector> calculateSpiralPoints(PVector a, PVector b, PVector c, int steps) {

    center = findCentroid(a, b, c);

    ArrayList <PVector> calculated_points;
    ArrayList <PVector> initial_points;
    calculated_points = new ArrayList();
    initial_points = new ArrayList();

    PVector [] triangle_buffer = new PVector[3];

    triangle_buffer[0]=a;
    triangle_buffer[1]=b;
    triangle_buffer[2]=c;


    float ang_1 = atan2(triangle_buffer[0].y - center.y, triangle_buffer[0].x - center.x); 
    float ang_2 = atan2(triangle_buffer[1].y - center.y, triangle_buffer[1].x - center.x); 

    if (menorDistAngulos(ang_1, ang_2) > 0) {
      PVector aux = triangle_buffer[1];
      triangle_buffer[1] = triangle_buffer[2];
      triangle_buffer[2] = aux;
    }

    triangle_buffer = getOffsetPath(triangle_buffer, internal_offset);


    for (int i = 0; i < steps; i ++) {
      for (int j = 0; j < triangle_buffer.length; j++) {
        float x = lerp(triangle_buffer[j].x, center.x, map(i, 0, steps, 0, 1));
        float y = lerp(triangle_buffer[j].y, center.y, map(i, 0, steps, 0, 1));
        PVector aux = new PVector (x, y);
        initial_points.add(aux);
      }
    }

    PVector aux = new PVector(initial_points.get(0).x, initial_points.get(0).y);
    calculated_points.add(aux);

    for (int i = 1; i < initial_points.size(); i++) {
      if (i%3==0) {
        PVector p = initial_points.get(i);
        Punto a_start = new Punto(p.x, p.y);
        Punto a_end = new Punto(initial_points.get(i+1).x, initial_points.get(i+1).y);
        Punto b_start = new Punto(initial_points.get(i-3).x, initial_points.get(i-3).y);
        Punto b_end = new Punto(initial_points.get(i-1).x, initial_points.get(i-1).y);
        Punto f = obtieneCruceDosLineas( a_start, a_end, b_start, b_end );
        aux = new PVector(f.x, f.y);
        calculated_points.add(aux);
      } else {
        aux = new PVector(initial_points.get(i).x, initial_points.get(i).y);
        calculated_points.add(aux);
      }
    }

    return calculated_points;
  }

  //••••••••••••••••••••••••••••••••••••••••••

  PVector findCentroid(PVector a, PVector b, PVector c) {
    PVector result = null;
    float x = (a.x + b.x + c.x)/3.0;
    float y = (a.y + b.y + c.y)/3.0; 
    result = new PVector(x, y);
    return result;
  }

  //••••••••••••••••••••••••••••••••••••••••••

  void fireAnimation(String t, float s) {
    txt = t;
    animation_speed = s;
    animating = true;
    text_has_entered = false;
    text_written = false;
    char_count = 0;
    text_offset = 0;
  }

  //••••••••••••••••••••••••••••••••••••••••••

  void setFont(PFont f) {
    font = f;
  }

  //••••••••••••••••••••••••••••••••••••••••••

  float calculateTextWidth(String t) {
    float w = 0;

    pushStyle();
    textFont(font);
    for (int i = 0; i < t.length(); i++) {
      w += textWidth(t.charAt(i)) + text_tracking;
    }
    popStyle();
    // println(w);

    return w;
  }

  //••••••••••••••••••••••••••••••••••••••••••

  void select() {
    selected = true;
  }

  //••••••••••••••••••••••••••••••••••••••••••

  void deselect() {
    selected = false;
  }

  //••••••••••••••••••••••••••••••••••••••••••

  void setFillColor(color c) {
    triangle_color = c;
  }

  //••••••••••••••••••••••••••••••••••••••••••

  void setTextColor(color c) {
    text_color = c;
  }

  //••••••••••••••••••••••••••••••••••••••••••

  void setInternalOffset(float o) {
    internal_offset = o;
  }

  //••••••••••••••••••••••••••••••••••••••••••

  void dashedLine(float x1, float y1, float x2, float y2, float dash_length ) {
    float steps = dist(x1, y1, x2, y2) / dash_length;
    for (int i = 0; i < steps - 1; i +=2 ) {
      float xa = lerp(x1, x2, i/steps);
      float ya = lerp(y1, y2, i/steps);
      float xb = lerp(x1, x2, (i + 1)/steps);
      float yb = lerp(y1, y2, (i + 1)/steps);
      line(xa, ya, xb, yb);
    }
  }
  //••••••••••••••••••••••••••••••••••••••••••

  PVector [] getOffsetPath(PVector[] triangle, float offset) {

    ArrayList <Linea> new_lines;
    new_lines = new ArrayList();

    for (int i = 0; i < triangle.length; i++) {
      PVector start = triangle[i].copy();
      PVector end = triangle[(i+1)%points.size()].copy();

      float ang = atan2(start.y - end.y, start.x - end.x);
      ang += HALF_PI;

      float dx = cos(ang) * offset;
      float dy = sin(ang) * offset;

      start.x += dx;
      start.y += dy;

      end.x += dx;
      end.y += dy;

      Punto a = new Punto(start.x, start.y);
      Punto b = new Punto(end.x, end.y);

      Linea l = new Linea(a, b);

      new_lines.add(l);
    }

    PVector []  offset_points =  new PVector [3];

    for (int i = 0; i < new_lines.size(); i++) {
      Linea a = new_lines.get(i);
      Linea b = new_lines.get((i+1)%new_lines.size());

      Punto p = obtieneCruceDosLineas(a.p1, a.p2, b.p1, b.p2);
      PVector v = new PVector(p.x, p.y);
      offset_points[i] = v;
    }

    return offset_points;
  }
  //••••••••••••••••••••••••••••••••••••••••••

  void dibujarPleno() {
    beginShape();
    for (int i = 0; i < points.size(); i ++) {
      vertex(points.get(i).position.x, points.get(i).position.y);
    }
    endShape(CLOSE);
  }
  //••••••••••••••••••••••••••••••••••••••••••

  void actualizarSinusoides() {

    sinSatura.actualizar();
    sinBrillo.actualizar();
  }
  //••••••••••••••••••••••••••••••••••••••••••

  void dibujarPlenoAnimado( color colorBase, float interpolaAmplitud, 
    float interpolaVelocidad ) {

    sinSatura.actualizar( interpolaVelocidad );
    sinBrillo.actualizar( interpolaVelocidad );

    pushStyle();
    colorMode( HSB );
    float nuevaSaturacion = sinSatura.valor( saturation(colorBase), 0, 255, 
      interpolaAmplitud );
    float nuevoBrillo = sinBrillo.valor( brightness(colorBase), 0, 255, 
      interpolaAmplitud );
    colorVariado = color( hue(colorBase), nuevaSaturacion, nuevoBrillo );
    fill( colorVariado );
    dibujarPleno();
    popStyle();
  }
  //••••••••••••••••••••••••••••••••••••••••••

  void asignarTextura( Textri laTextura ) {
    textura = laTextura;
  }
  //••••••••••••••••••••••••••••••••••••••••••

  void agregarIDSensor( int idNuevo ) {
    listaID.append( idNuevo );
  }
  //••••••••••••••••••••••••••••••••••••••••••

  void quitarUnIDSensor() {
    if ( listaID.size()>0 ) {
      listaID.remove( listaID.size()-1 );
    }
  }
  //••••••••••••••••••••••••••••••••••••••••••

  void mostrarIDSensores( float left, float top ) {
    String cadena = "";
    for ( int i=0; i<listaID.size(); i++ ) {
      cadena += "<"+listaID.get(i)+">";
    }
    cadena += (conSensoresActivados ? "ACTIVADO" : "");
    if ( listaID.size()<=0 ) {
      cadena = "lista vacia";
    }
    text( cadena, left, top );
  }
  //••••••••••••••••••••••••••••••••••••••••••

  void revisarSensores( ReceptorOSC sensores ) {
    conSensoresActivados = false;
    for ( int i=0; i<listaID.size(); i++ ) {
      if ( sensores.estaActivado( listaID.get(i) )) {
        conSensoresActivados = true;
      }
    }
  }
  //••••••••••••••••••••••••••••••••••••••••••

  void mostrarActivado() {
    if ( conSensoresActivados ) {
      ellipse( center.x, center.y, 50, 50 );
    }
  }
  //••••••••••••••••••••••••••••••••••••••••••

  void dibujarInteractivo( color colorBase, float interpolaAmplitud, 
    float interpolaVelocidad ) {
    pushStyle();
    dibujarPlenoAnimado( colorBase, interpolaAmplitud, interpolaVelocidad );
    if ( conSensoresActivados ) {
      if ( textura!=null ) {
        tint( colorVariado );
        textura.texturizar();
      }
    }
    popStyle();
  }
  //••••••••••••••••••••••••••••••••••••••••••
  
  String escribirXMLsensores(){
    String cadena = "";
    for( int i=0 ; i<listaID.size() ; i++ ){
      cadena+="\n   <sensor id=\""+listaID.get(i)+"\"></sensor>";
    }
    return cadena;
  }
  //••••••••••••••••••••••••••••••••••••••••••
}
