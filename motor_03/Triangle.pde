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
  boolean text_has_entered = false;
  boolean text_written = false;
  int char_count = 0;
  PVector center;
  int id;

  //••••••••••••••••••••••••••••••••••••••••••

  Triangle(ArrayList <Point> p_, int id_) {

    points = new ArrayList();
    points = p_;
    spiral_points = new ArrayList();
    spiral_points = calculateSpiralPoints(points.get(0).getPVector(), points.get(1).getPVector(), points.get(2).getPVector(), 4);
    id = id_;
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
    fill(255,128,0);
    text(str(id), w/2, h/2-2);
    popMatrix();
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
    println(w);

    return w;
  }
  //••••••••••••••••••••••••••••••••••••••••••
}
