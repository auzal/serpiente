PVector a;
PVector b;
PVector c;

ArrayList <PVector> spiral_points;

int spiral_steps = 5;

void setup() {
  size(800, 800);
  randomizeTriangle();
  spiral_points = new ArrayList();
  // a la función calculateSpiralPoints() le pasas los vertices del triangulos y la cantidad de "pasos" que tiene el espiral
  spiral_points = calculateSpiralPoints(a,b,c,spiral_steps);
  
}


void draw() {
  background(0);
  stroke(255);
  noFill();
  strokeWeight(1);
  triangle(a.x, a.y, b.x, b.y, c.x, c.y);
  
  // dibujo del espiral
  stroke(255,0,98);
  strokeWeight(6);
  for(int i = 0 ; i < spiral_points.size()-1 ; i++){
    PVector origin = spiral_points.get(i);
    PVector destination = spiral_points.get(i+1);
    line(origin.x, origin.y, destination.x, destination.y);
    
  }
   
}

void mousePressed() {
  randomizeTriangle();
  spiral_points = calculateSpiralPoints(a,b,c, spiral_steps);
}

void randomizeTriangle() {
  a = new PVector(width/2 + random(-width/2*.7, width/2*.7), height/2 + random(-height/2*.7, height/2*.7));
  b = new PVector(width/2 + random(-width/2*.7, width/2*.7), height/2 + random(-height/2*.7, height/2*.7));
  c = new PVector(width/2 + random(-width/2*.7, width/2*.7), height/2 + random(-height/2*.7, height/2*.7));
}

PVector findCentroid(PVector a, PVector b, PVector c) {
  PVector result = null;
  float x = (a.x + b.x + c.x)/3.0;
  float y = (a.y + b.y + c.y)/3.0; 
  result = new PVector(x, y);

  return result;
}

ArrayList <PVector> calculateSpiralPoints(PVector a, PVector b, PVector c, int steps){
  PVector center;
  center = findCentroid(a, b, c);
  ArrayList <PVector> calculated_points;
  ArrayList <PVector> initial_points;
  calculated_points = new ArrayList();
  initial_points = new ArrayList();
 
 
  for (int i = 0; i < steps; i ++) {
    float x = lerp(a.x, center.x, map(i, 0, steps, 0, 1));
    float y = lerp(a.y, center.y, map(i, 0, steps, 0, 1));
    PVector aux = new PVector (x, y);
    initial_points.add(aux);
    x = lerp(b.x, center.x, map(i, 0, steps, 0, 1));
    y = lerp(b.y, center.y, map(i, 0, steps, 0, 1));
    aux = new PVector (x, y);
    initial_points.add(aux);
    x = lerp(c.x, center.x, map(i, 0, steps, 0, 1));
    y = lerp(c.y, center.y, map(i, 0, steps, 0, 1));
    aux = new PVector (x, y);
    initial_points.add(aux);
  }
  
  PVector aux = new PVector(initial_points.get(0).x,  initial_points.get(0).y);
  calculated_points.add(aux);
  
  for(int i = 1 ; i < initial_points.size() ; i++){
    if(i%3==0){
      PVector p = initial_points.get(i);
      Punto a_start = new Punto(p.x,p.y);
      Punto a_end = new Punto(initial_points.get(i+1).x,  initial_points.get(i+1).y);
      Punto b_start = new Punto(initial_points.get(i-3).x,  initial_points.get(i-3).y);
      Punto b_end = new Punto(initial_points.get(i-1).x,  initial_points.get(i-1).y);
      Punto f = obtieneCruceDosLineas( a_start, a_end, b_start, b_end );
      aux = new PVector(f.x, f.y);
      calculated_points.add(aux);
    }else{
    aux = new PVector(initial_points.get(i).x,  initial_points.get(i).y);
    calculated_points.add(aux);
    
    }
  }
  
  return calculated_points;

}
