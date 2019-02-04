import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class TriangleTexture extends PApplet {

int rows = 10;
int cols = 10;
Field fs[] = new Field[rows * cols];
Object m;
int fieldSize = 100;

public void setup(){
  
  int n = 0;
  
  for(int i = 0; i < rows; i++){
    for(int j = 0; j < cols; j++){
      fs[n] = new Field(j*fieldSize, i*fieldSize, fieldSize, fieldSize, false, 2);
      n++;
    }
  }  
}

public void draw(){
  clear();
  background(0);
  for(int i = 0; i < fs.length; i++){
    fs[i].step();
  }
  for(int i = 0; i < fs.length; i++){
    fs[i].draw();
  }
}

public void mouseClicked(){
  setup();
}

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
  
  public void drawTriangles(){
    int c;
    float x0, y0, x1, y1, x2, y2, x3, y3;
    for(int i = 0; i < numNodes; i++){
      x0 = particles[i].neighbors[0].x;
      x1 = particles[i].neighbors[1].x;
      x2 = particles[i].neighbors[2].x;
      x3 = particles[i].neighbors[3].x;
      y0 = particles[i].neighbors[0].y;
      y1 = particles[i].neighbors[1].y;
      y2 = particles[i].neighbors[2].y;
      y3 = particles[i].neighbors[3].y;

      //stroke(c);
      beginShape(TRIANGLE_FAN);
      vertex(particles[i].x + xOffset, particles[i].y + yOffset);
      c = color(r/(i+1), g/(i+1), b/(i+1));
      fill(c);
      vertex(x0 + xOffset, y0 + yOffset);
      vertex(x1 + xOffset, y1 + yOffset);
      c = color(.6f*r/(i+1), .6f*g/(i+1), .6f*b/(i+1));
      fill(c);
      vertex(x2 + xOffset, y2 + yOffset);
      c = color(.25f*r/(i+1), .25f*g/(i+1), .25f*b/(i+1));
      fill(c);
      vertex(x3 + xOffset, y3 + yOffset);
      c = color(.4f*r/(i+1), .4f*g/(i+1), .4f*b/(i+1));
      fill(c);
      vertex(x0 + xOffset, y0 + yOffset);
      endShape();
    }
  }

  
  public void draw(){
    drawTriangles();
    //drawSquares();
  }
  
  public void step(){
    for(int i = 0; i < numNodes; i++){
      particles[i].applyMovement();
    }
    for(int i = 0; i < numNodes; i++){
      particles[i].getNeighbors();
    }
  }
}
public class Particle{
  float x, y, speed, xDir, yDir, xMax, yMax;
  int numNodes;
  double distances[];
  Particle neighbors[];
  Particle nodes[];
  
  public Particle(){

  }

  public Particle(float xMax, float yMax, float maxSpeed, float speedScale, int numNeighbors, boolean sameDir, int numNodes, Particle[] nodes){
    x = random(xMax);
    y = random(yMax);
    this.xMax = xMax;
    this.yMax = yMax;
    this.numNodes = numNodes;
    this.nodes = nodes;
    speed = random(maxSpeed) / speedScale;
    xDir = random(2) - 1;
    yDir = random(2) - 1;
    if(sameDir){
      xDir = Math.abs(xDir);
      yDir = Math.abs(yDir);
    }
    distances = new double[numNeighbors];
    neighbors = new Particle[numNeighbors];
    for(int i = 0; i < numNeighbors; i++){
      distances[i] = 0;
    }
  }
  
  public void applyMovement(){ 
    x = (x + (speed * xDir));
    y = (y + (speed * yDir));
    if(x < 0){
      x = 0;
      xDir = -xDir;
    }
    if(y < 0){
      y = 0;
      yDir = -yDir;
    }
    if(x > xMax){
      x = xMax;
      xDir = -xDir;
    }
    if(y > yMax){
      y = yMax;
      yDir = -yDir;
    }
  }
  
  public void getNeighbors(){
    double currDist[] = new double[neighbors.length];
    double tmp;
    for(int i = 0; i < neighbors.length; i++){
      currDist[i] = 9999999;
    }
    for(int i = 0; i < neighbors.length; i++){
      neighbors[i] = null;
    }
    
    for(int i = 0; i < numNodes; i++){
      if(nodes[i] != this){
        tmp = Math.sqrt(Math.pow((x - nodes[i].x), 2) + Math.pow((y - nodes[i].y), 2));

        if(nodes[i].x <= x && nodes[i].y <= y && tmp < currDist[0]){
          currDist[0] = tmp;
          neighbors[0] = nodes[i];
        }
        else if(nodes[i].x >= x && nodes[i].y <= y && tmp < currDist[1]){
          currDist[1] = tmp;
          neighbors[1] = nodes[i];
        }
        else if(nodes[i].x >= x && nodes[i].y >= y && tmp < currDist[2]){
          currDist[2] = tmp;
          neighbors[2] = nodes[i];
        }
        else if(nodes[i].x <= x && nodes[i].y >= y && tmp < currDist[3]){
          currDist[3] = tmp;
          neighbors[3] = nodes[i];
        }
      }
    }
    for(int i = 0; i < neighbors.length; i++){
      if(neighbors[i] == null){
         Particle t = new Particle();
        switch(i){
          case 0:
            neighbors[i] = t;
            t.x = 0;
            t.y = 0;
            break;
          case 1:
            neighbors[i] = t;
            t.x = xMax;
            t.y = 0;
            break;
          case 2:
            neighbors[i] = t;
            t.x = xMax;
            t.y = yMax;
            break;
          case 3:
            neighbors[i] = t;
            t.x = 0;
            t.y = yMax;
            break;
        }
      }
    }
  }
  
  public double maxArrayVal(double[] arr){
    double val = arr[0];
    for(int i = 1; i < arr.length; i++){
      if(arr[i] > val) val = arr[i];
    }
    return val;
  }
}
  public void settings() {  size(1000, 500); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "TriangleTexture" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
