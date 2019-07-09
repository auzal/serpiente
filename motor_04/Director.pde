class Director {

  ArrayList <Point> points;
  ArrayList <Triangle> triangles;
  String state;
  int point_select_index = 0;
  int triangle_select_index = 0;
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

  boolean show_help = false;
  boolean show_debug = false;

  String[] point_help;
  String[] triangle_help;
  String[] running_help;

  //••••••••••••••••••••••••••••••••••••••••••

  Director() {
    points = new ArrayList();
    point_buffer = new ArrayList();
    triangles = new ArrayList();
    createFonts();
    state = "running";
    building_triangle = false;
    point_help = loadStrings("data/help_points.txt");
    triangle_help = loadStrings("data/help_triangles.txt");
    running_help = loadStrings("data/help_running.txt");
  }

  //••••••••••••••••••••••••••••••••••••••••••

  void render() {
    pushStyle();
    textFont(font_sma_med);
    for (int i = 0; i < triangles.size(); i ++) {

      if (state.equals("running")) {
        triangles.get(i).render();
      }
      if (!state.equals("running") || show_debug) {
        if (!state.equals("point calibration"))
          triangles.get(i).renderSpiral();
        triangles.get(i).renderContour();
      }
    }

    for (int i = 0; i < points.size(); i ++) {
      if (!state.equals("running") || show_debug) {
        points.get(i).render();
        if (points.get(i).selected && state.equals("point calibration")) {
          points.get(i).renderMarker();
        }
      }
    }

    if (state.equals("triangle calibration")) {
      Point aux = findClosestPoint();
      stroke(255, 90);
      if (aux!=null)
        line(mouseX, mouseY, aux.position.x, aux.position.y);

      if (point_buffer.size()>1) {
        for (int i = 0; i < point_buffer.size()-1; i++) {
          pushStyle();
          stroke(255, 128, 0);
          strokeWeight(4);
          line(point_buffer.get(i).position.x, point_buffer.get(i).position.y, point_buffer.get(i+1).position.x, point_buffer.get(i+1).position.y);
          popStyle();
        }
      }
    }

    renderState();
    if (show_help )
      renderHelp();
    popStyle();
  }

  //••••••••••••••••••••••••••••••••••••••••••

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

  //••••••••••••••••••••••••••••••••••••••••••

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
    } else if (key == 'h' || key == 'H') {
      show_help = !show_help;
    } else if (key == 'd' || key == 'D') {
      show_debug = !show_debug;
    }

    if (state.equals("point calibration")) {
      if (points.size() > 0) {
        points.get(point_select_index).keyPressed();
      }
      if (key == TAB) {
        selectNextPoint();
      } else if (key == RETURN || key == ENTER) {
        addPoint();
      } else if (key == DELETE || key == BACKSPACE) {
        deletePoint(point_select_index);
      }
    } else if (state.equals("triangle calibration")) {
      if (key == TAB) {
        selectNextTriangle();
      } else if (key == DELETE || key == BACKSPACE) {
        deleteTriangle(triangle_select_index);
      }
    }
  }

  //••••••••••••••••••••••••••••••••••••••••••

  void keyReleased() {
    if (state.equals("point calibration")) {
      if (points.size() > 0) {
        points.get(point_select_index).keyReleased();
      }
    }
  }

  //••••••••••••••••••••••••••••••••••••••••••

  void mousePressed() {
    if (state.equals("point calibration")) {
      addPoint();
    } else if (state.equals("triangle calibration")) {
      if (points.size()>2) {
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
            //  println("here " + point_buffer.size());
            if (point_buffer.size() == 3) {
              println("completed triangle");
              ArrayList <Point> p = new ArrayList<Point>(point_buffer);
              Triangle t = new Triangle(p, triangle_id_count);
              t.setFont(triangle_font);

              for (int i = 0; i < triangles.size(); i ++) {
                triangles.get(i).deselect();
              }
              t.select();

              triangles.add(t);
              triangle_id_count ++;
              point_buffer.clear();
              triangle_select_index = triangles.size()-1;
              //println("point_buffer size " + point_buffer.size());
            }
          }
        }
      }
    }
  }

  //••••••••••••••••••••••••••••••••••••••••••

  void renderHelp() {

    pushMatrix();
    pushStyle();

    String[] txt = new String[0];

    if (state.equals("point calibration")) {
      txt = point_help;
    } else if (state.equals("triangle calibration")) {
      txt = triangle_help;
    } else if (state.equals("running")) {
      txt = running_help;
    }

    textFont(font_sma_thin);



    float line_height = (textAscent()+textDescent())*1.3;
    float h = txt.length * line_height + 10;
    float w = 0;
    for (int i = 0; i < txt.length; i++) {
      if (textWidth(txt[i]) > w) {
        w = textWidth(txt[i]);
      }
    }
    w+=20;
    fill(50, 200);
    noStroke();

    translate(width-(w+20), 50);

    rect(-10, -10 - line_height*.5, w, h);
    fill(255);

    for (int i = 0; i < txt.length; i++) {
      text(txt[i], 0, i*line_height);
    }
    popStyle();
    popMatrix();
  }

  //••••••••••••••••••••••••••••••••••••••••••

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

  //••••••••••••••••••••••••••••••••••••••••••

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

  //••••••••••••••••••••••••••••••••••••••••••

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

  //••••••••••••••••••••••••••••••••••••••••••

  void selectNextPoint() {
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

  //••••••••••••••••••••••••••••••••••••••••••

  void selectNextTriangle() {
    for (int i = 0; i < triangles.size(); i++) {
      if (triangles.get(i).selected) {
        triangles.get(i).deselect();
        int index = (i+1)%triangles.size();
        triangles.get(index).select();
        triangle_select_index = index;
        break;
      }
    }
  }

  //••••••••••••••••••••••••••••••••••••••••••

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

  //••••••••••••••••••••••••••••••••••••••••••

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

  //••••••••••••••••••••••••••••••••••••••••••

  int findClosestTriangle(float x, float y) {
    int index = -1;
    if (triangles.size() > 0) {
      index = 0;
      for (int i = 0; i < triangles.size(); i++) {
        if (dist(x, y, triangles.get(i).center.x, triangles.get(i).center.y) < dist(x, y, triangles.get(index).center.x, triangles.get(index).center.y)) {
          index = i;
        }
      }
    }

    return index;
  }

  //••••••••••••••••••••••••••••••••••••••••••

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

  //••••••••••••••••••••••••••••••••••••••••••

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

  //••••••••••••••••••••••••••••••••••••••••••

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

  //••••••••••••••••••••••••••••••••••••••••••

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

  //••••••••••••••••••••••••••••••••••••••••••

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
        p.add(getPointById(a));
        p.add(getPointById(b));
        p.add(getPointById(c));
        Triangle aux = new Triangle(p, id);
        aux.setFont(triangle_font);

        for (int j = 0; j < triangles.size(); j ++) {
          triangles.get(j).deselect();
        }
        aux.select();

        triangles.add(aux);

        triangle_select_index = triangles.size()-1;
        //      triangles.add(p);
      }

      triangle_id_count = int(count[0].getContent());
      println(triangle_id_count);
    }
  }

  //••••••••••••••••••••••••••••••••••••••••••

  Triangle getTriangle(int index) {
    Triangle t = null;
    if (index < triangles.size()) {
      t = triangles.get(index);
    }
    return t;
  }

  //••••••••••••••••••••••••••••••••••••••••••

  void deleteTriangle(int index) {
    if (triangles.size()>0) {
      if (triangles.get(index).selected) {
        triangle_select_index = max(triangles.size()-2, 0);
      }
      triangles.get(triangle_select_index).select();
      triangles.remove(index);
    }
    saveTriangles();
  }

  //••••••••••••••••••••••••••••••••••••••••••

  void deletePoint(int index) {
    if (points.size()>0) {
      Point p = points.get(index);
      for (int i = triangles.size()-1; i >= 0; i--) {
        Triangle t = triangles.get(i);
        for (int j = 0; j < t.points.size(); j++) {
          if (t.points.get(j).id == p.id) {
            deleteTriangle(i);
            break;
          }
        }
      }
      point_select_index = max(points.size()-2, 0);
      points.get(point_select_index).select();
      points.remove(index);
    }
    saveTriangles();
    savePoints();
  }

  //••••••••••••••••••••••••••••••••••••••••••

  void fireAnimation(int index, String txt, float speed) {
    if (state.equals("running")) {
      if (triangles.size()>=index) {
        triangles.get(index).fireAnimation(txt, speed);
      }
    }
  }    

  //••••••••••••••••••••••••••••••••••••••••••

  void setTriangleColors(int index, color fill, color text) {
    if (state.equals("running")) {
      if (triangles.size()>=index) {
        triangles.get(index).setFillColor(fill);
        triangles.get(index).setTextColor(text);
      }
    }
  }

  //••••••••••••••••••••••••••••••••••••••••••

  int getRandomTriangleIndex() {

    int index = 0;
    if (triangles.size() > 0)
      index = floor(random(triangles.size()));
    else
      index = -1;
    return index;
  }
}