class Director {

  ArrayList <Point> points;
  ArrayList <Triangle> triangles;
  String state;
  int point_select_index = 0;
  int point_id_count = 0;
  int triangle_id_count = 0;
  boolean building_triangle;
  ArrayList <Point> point_buffer;

  PFont font_med_thin;
  PFont font_med_med;
  PFont font_med_bold;
  PFont font_sma_thin;
  PFont font_sma_med;
  PFont font_sma_bold;
  PFont font_lar_thin;
  PFont font_lar_med;
  PFont font_lar_bold;

  PFont triangle_font;

  Director() {
    points = new ArrayList();
    point_buffer = new ArrayList();
    triangles = new ArrayList();
    createFonts();
    state = "running";
    building_triangle = false;
  }

  void render() {
    pushStyle();
    textFont(font_sma_med);
    for (int i = 0; i < triangles.size(); i ++) {
      triangles.get(i).renderContour();
      triangles.get(i).renderSpiral();
      triangles.get(i).render();
    }

    for (int i = 0; i < points.size(); i ++) {
      points.get(i).render();
      if (points.get(i).selected && state.equals("point calibration")) {
        points.get(i).renderMarker();
      }
    }

    if (state.equals("triangle calibration")) {
      Point aux = findClosestPoint();
      stroke(255, 90);
      if (aux!=null)
        line(mouseX, mouseY, aux.position.x, aux.position.y);
    }

    renderState();
    popStyle();
  }

  void update() {

    for (int i = 0; i < triangles.size(); i ++) {
      for (int j = 0; j < triangles.get(i).points.size(); j ++ ) {
        Point p = getPointById(triangles.get(i).points.get(j).id);
        if (p!=null) {
          triangles.get(i).points.get(j).setPosition(p.position);
        }
      }

      triangles.get(i).update();
    }
  }

  void keyPressed() {
    if (key == 'm' || key == 'M') {
      if (state.equals("running")) {
        state = "point calibration";
      } else if (state.equals("point calibration")) {
        savePoints();
        state = "triangle calibration";
        point_buffer.clear();
      } else if (state.equals("triangle calibration")) {
        saveTriangles();
        state = "running";
      }
    }

    if (state.equals("point calibration")) {
      if (points.size() > 0) {
        points.get(point_select_index).keyPressed();
      }
      if (key == TAB) {
        selectNext();
      } else if (key == RETURN || key == ENTER) {
        addPoint();
      }
    }
  }

  void keyReleased() {
    if (state.equals("point calibration")) {
      if (points.size() > 0) {
        points.get(point_select_index).keyReleased();
      }
    }
  }

  void mousePressed() {
    if (state.equals("point calibration")) {
      addPoint();
    } else if (state.equals("triangle calibration")) {
      if (point_buffer.size() < 3) {
        Point aux = findClosestPoint();
        boolean found = false;
        for (int i = 0; i < point_buffer.size(); i ++) {
          if (aux.id == point_buffer.get(i).id) {
            found = true;
          }
        }
        if (!found) {
          point_buffer.add(aux);
          println("here " + point_buffer.size());
          if (point_buffer.size() == 3) {
            println("completed triangle");
            ArrayList <Point> p = new ArrayList<Point>(point_buffer);
            Triangle t = new Triangle(p, triangle_id_count);
            t.setFont(triangle_font);
            triangles.add(t);
            triangle_id_count ++;
            point_buffer.clear();
            println("point_buffer size " + point_buffer.size());
          }
        }
      }
    } else if (state.equals("running")) {
      if (triangles.size()>0) {
        // int index = int(random(triangles.size()));
        String text = "Nunca olvides que lo unico que un rico te va a dar es siempre mas pobreza.";
        float animation_speed = 7;
        triangles.get(findClosestTriangle(mouseX, mouseY)).fireAnimation(text, animation_speed);
        //       triangles.get(findTriangleById(1)).fireAnimation(text, animation_speed);
      }
    }
  }

  void renderState() {
    pushStyle();
    pushMatrix();
    translate(20, 20);
    textFont(font_sma_thin);
    float w = textWidth(state.toUpperCase()) + 10;
    float h = textAscent() + textDescent() + 10;
    textAlign(CENTER, CENTER);
    rectMode(CENTER);
    noStroke();
    fill(128, 90);
    rect(w/2, h/2, w, h);
    fill(255);
    text(state.toUpperCase(), w/2, h/2);
    popMatrix();
    popStyle();
  }

  void addPoint() {
    Point aux = new Point(mouseX, mouseY, point_id_count);
    point_id_count ++;
    for (int i = 0; i < points.size(); i ++) {
      points.get(i).deselect();
    }
    aux.select();
    points.add(aux);
    point_select_index = points.size()-1;
  }

  void createFonts() {
    int med_font = 20;
    int sma_font = 12;
    int lar_font = 30;
    font_med_thin =  createFont("data/fira/FiraSans-Thin.ttf", med_font);
    font_med_med =  createFont("data/fira/FiraSans-Light.ttf", med_font);
    font_med_bold =  createFont("data/fira/FiraSans-SemiBold.ttf", med_font);
    font_sma_thin =  createFont("data/fira/FiraSans-Thin.ttf", sma_font);
    font_sma_med =  createFont("data/fira/FiraSans-Light.ttf", sma_font);
    font_sma_bold =  createFont("data/fira/FiraSans-SemiBold.ttf", sma_font);
    font_lar_thin =  createFont("data/fira/FiraSans-Thin.ttf", lar_font);
    font_lar_med =  createFont("data/fira/FiraSans-Light.ttf", lar_font);
    font_lar_bold =  createFont("data/fira/FiraSans-SemiBold.ttf", lar_font);
    triangle_font = createFont("data/nevis.ttf", 20);
  }

  void selectNext() {
    for (int i = 0; i < points.size(); i++) {
      if (points.get(i).selected) {
        points.get(i).deselect();
        int index = (i+1)%points.size();
        points.get(index).select();
        point_select_index = index;
        break;
      }
    }
  }

  Point findClosestPoint() {
    Point closest = null;
    if (points.size() > 0) {
      int index = 0;
      for (int i = 0; i < points.size(); i ++) {
        if (dist(mouseX, mouseY, points.get(i).position.x, points.get(i).position.y) <= dist(mouseX, mouseY, points.get(index).position.x, points.get(index).position.y)) {
          index = i;
        }
      }
      closest = points.get(index);
    }
    return closest;
  }


  Point getPointById(int id) {
    Point p = null;
    for (int i = 0; i < points.size(); i ++) {
      if (points.get(i).id == id) {
        p = points.get(i);
        break;
      }
    }
    return p;
  }

  int findClosestTriangle(float x, float y) {
    int index = -1;
    for (int i = 0; i < triangles.size(); i++) {
      if (dist(mouseX, mouseY, triangles.get(i).center.x, triangles.get(i).center.y) < dist(mouseX, mouseY, triangles.get(index).center.x, triangles.get(index).center.y)) {

        index = i;
      }
    }

    return index;
  }

  int findTriangleById(int id) {
    int index = -1;
    for (int i = 0; i < triangles.size(); i++) {
      if (triangles.get(i).id == id) {
        index = i;
        break;
      }
    }

    return index;
  }

  void savePoints() {
    String[] out = new String[0];
    out = append(out, "<XML>");
    for (int i = 0; i < points.size(); i++) {
      Point aux = points.get(i);
      String row = "<point x=\"" + aux.position.x  + "\" y=\"" + aux.position.y + "\" id=\"" + aux.id + "\"></point>";
      out = append(out, row);
    }
    out = append(out, "<id_count>" + point_id_count + "</id_count>");

    out = append(out, "</XML>");
    saveStrings("data/points.xml", out);
  }

  void saveTriangles() {
    String[] out = new String[0];
    out = append(out, "<XML>");
    for (int i = 0; i < triangles.size(); i++) {
      Triangle aux = triangles.get(i);
      String row = "<triangle ";

      for (int j = 0; j < aux.points.size(); j++) {
        row+= "point_" + j +"=\"" +aux.points.get(j).id + "\" ";
      }      
      row+= " id=\"" + aux.id + "\"></triangle>";
      //String row = "<triangle></triangle>";
      out = append(out, row);
    }
    out = append(out, "<id_count>" + triangle_id_count + "</id_count>");

    out = append(out, "</XML>");
    saveStrings("data/triangles.xml", out);
  }

  void loadPoints() {
    XML xml;
    try {
      xml = loadXML("data/points.xml");
    }
    catch(Exception e) {
      xml = null;
      println("no point config found");
    }
    if (xml!=null) {
      XML[] children = xml.getChildren("point");
      XML[] count = xml.getChildren("id_count");

      for (int i = 0; i < children.length; i++) {
        float x = children[i].getFloat("x");
        float y = children[i].getFloat("y");
        int id = children[i].getInt("id");
        Point p = new Point(x, y, id);


        for (int j = 0; j < points.size(); j ++) {
          points.get(j).deselect();
        }
        p.select();
        points.add(p);
        point_select_index = points.size()-1;
      }

      point_id_count = int(count[0].getContent());
      println(point_id_count);
    }
  }


  void loadTriangles() {
    XML xml;
    try {
      xml = loadXML("data/triangles.xml");
    }
    catch(Exception e) {
      xml = null;
      println("no triangle config found");
    }
    if (xml!=null && points.size()>0) {

      XML[] children = xml.getChildren("triangle");
      XML[] count = xml.getChildren("id_count");

      for (int i = 0; i < children.length; i++) {
        int a = children[i].getInt("point_0");
        int b = children[i].getInt("point_1");
        int c = children[i].getInt("point_2");

        int id = children[i].getInt("id");

        ArrayList <Point> p;
        p = new ArrayList();
        p.add(points.get(a));
        p.add(points.get(b));
        p.add(points.get(c));
        Triangle aux = new Triangle(p, id);
        aux.setFont(triangle_font);
        triangles.add(aux);
        //      triangles.add(p);
      }

      triangle_id_count = int(count[0].getContent());
      println(triangle_id_count);
    }
  }

  Triangle getTriangle(int index) {
    Triangle t = null;
    if (index < triangles.size()) {
      t = triangles.get(index);
    }
    return t;
  }
}
