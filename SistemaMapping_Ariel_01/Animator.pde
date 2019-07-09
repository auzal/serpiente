class Animator {

  PGraphics g;
  PFont f;
  boolean animating;
  float[] x_pos;
  String [] text;
  int [] sizes;
  int [] offsets_y;
  int [] opacities;

  Animator() {
    //f = createFont("data/DDC.otf", 30);
    f = loadFont("data/DDC48.vlw");
    g = createGraphics(800, 600);
    g.beginDraw();
    g.background(255,0,0);
    g.endDraw();
    animating = false;
  }

  void draw(int x, int y) {
    pushStyle();
    image(g, x, y);
    popStyle();
  }

  void render() {
    if (animating) {
      g.beginDraw();

      g.textAlign(CENTER, CENTER);
      g.clear();


      for (int j = 0; j < text.length; j++) {

        g.pushMatrix();
        g.translate(x_pos[j], g.height/2 + offsets_y[j]);
        g.textFont(f);
        float x_acum = 0;
        for (int i = 0; i < text[j].length(); i++) {
          String s = str(text[j].charAt(i));
          float font_size = abs(sin(radians((x_pos[j] + x_acum )/2)))*sizes[j] + 20;
          g.textFont(f, font_size);
          g.fill(255, opacities[j]);
          g.scale(1);
          g.text(s, x_acum, 0);
          //g.textFont(f);
          x_acum += g.textWidth(s);
        }
        g.popMatrix();
      }
      g.endDraw();
    }
  }

  void update() {
    if (animating) {
      for (int i = 0; i < x_pos.length; i++) {
        x_pos[i] += 5;
      }
    }
  }

  void fireAnimation(String [] s) {

    text = s;
    sizes = new int[s.length];
    offsets_y = new int[s.length];
    opacities = new int[s.length];
    x_pos = new float[s.length];
    for (int i = 0; i < text.length; i ++) {
      sizes[i] = int(random(20, 150));
      offsets_y[i] = int(random(-((g.height/2)-50), ((g.height/2)-50)));
      opacities[i] = int(random(60, 255));
      pushStyle();
      textFont(f);
      x_pos[i] = -textWidth(text[i]) + random(-200);
      popStyle();
    }
    animating = true;
  }


  PImage getImage(){
    PImage aux = createImage(g.width, g.height, ARGB);
    aux.copy(g,0,0,g.width,g.height,0,0,g.width,g.height);
    return aux;
  }
}
