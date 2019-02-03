
public class Field{
  int numNeighbors = 4;
  int numNodes;
  float xOffset, yOffset, xMax, yMax;
  float speedDif = 30;
  float speedScale = 7;
  float r, g, b;
  Particle[] particles; 
  int maxDist = 1000;
  boolean sameDir;
  
  public Field(float xOffset, float yOffset, float xMax, float yMax, boolean sameDir, int numNodes){
    this.xOffset = xOffset;
    this.yOffset = yOffset;
    this.xMax = xMax;
    this.yMax = yMax;
    this.sameDir = sameDir;
    this.numNodes = numNodes;
    particles = new Particle[numNodes];
    r = random(255);
    g = random(255);
    b = random(255);
    for(int i = 0; i < numNodes; i ++){
      particles[i] = new Particle(xMax, yMax, speedDif, speedScale, numNeighbors, sameDir, numNodes, particles);
    }
  }
  
  void drawTriangles(){
    float x0, y0, x1, y1, x2, y2;
    for(int i = 0; i < numNodes; i++){
      x0 = particles[i].x;
      x1 = particles[i].neighbors[0].x;
      x2 = particles[i].neighbors[1].x;
      y0 = particles[i].y;
      y1 = particles[i].neighbors[0].y;
      y2 = particles[i].neighbors[1].y;
      fill(particles[i].c);
      triangle(x0 + xOffset, y0 + yOffset, x1 + xOffset, y1 + yOffset, x2 + xOffset, y2 + yOffset);
    }
  }

    void drawSquares(){
      float x0, y0, x1, y1, x2, y2, x3, y3;
      t = millis();
      for(int i = 0; i < numNodes; i++){

        x0 = particles[i].neighbors[0].x;
        x1 = particles[i].neighbors[1].x;
        x2 = particles[i].neighbors[2].x;
        x3 = particles[i].neighbors[3].x;

        y0 = particles[i].neighbors[0].y;
        y1 = particles[i].neighbors[1].y;
        y2 = particles[i].neighbors[2].y;
        y3 = particles[i].neighbors[3].y;
        fill(particles[i].c);
        stroke(particles[i].c);
        quad(x0 + xOffset, y0 + yOffset, x1 + xOffset, y1 + yOffset, x2 + xOffset, y2 + yOffset, x3 + xOffset, y3 + yOffset);
      }
       c += millis() - t;
  t = millis() - t;
  y++;
  }
 
  
  void draw(){
    //drawTriangles();
    drawSquares();
  }
  
  void step(){
    for(int i = 0; i < numNodes; i++){
      particles[i].applyMovement();
    }
    for(int i = 0; i < numNodes; i++){
      particles[i].getNeighbors();
      particles[i].getFill(xOffset, yOffset);
    }
  }
}
