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

public class MovingImage extends PApplet {

int rows = 50;
int cols = 30;
int numThreads = 4;
Field fs[] = new Field[rows * cols];
Thread ts[] = new Thread[numThreads];
Object m;
PImage p;
int fieldSize = 20;
int y = 0;
int c = 0;
int t = 0;

public void setup(){
  
  int n = 0;
  
  for(int i = 0; i < rows; i++){
    for(int j = 0; j < cols; j++){
      fs[n] = new Field(j*fieldSize, i*fieldSize, fieldSize, fieldSize, true, 3);
      n++;
    }
  }  
  

  p = loadImage("Images/HtxiYED.jpg");
  System.out.println("w = " + p.width);
  System.out.println("h = " + p.height);
}

public void draw(){
  clear();
  background(255,0,0);
  image(p, 0, 0);
  
  for(int i = 0; i < numThreads; i++){
    ts[i] = new Thread(new driver(i, fs, numThreads));
    ts[i].start();
  }
  for(int i = 0; i < numThreads; i++){
    try{
      ts[i].join();
    } catch(InterruptedException e){

    }
  }
  
  
  for(int i = 0; i < fs.length; i++){
    fs[i].draw();
  }
  
  
}

public class drawer implements Runnable{
  int tnum;
  int numThreads;
  Field fs[];

  public drawer(int tnum, Field fs[], int numThreads){
    this.tnum = tnum;
    this.fs = fs;
    this.numThreads = numThreads;
  }

  public void run(){
    for(int i = 0; i < rows * cols; i ++){
      if(i%numThreads == tnum){
        fs[i].draw();
      }
    }
  }
}

public class driver implements Runnable{
  int tnum;
  int numThreads;
  Field fs[];

  public driver(int tnum, Field fs[], int numThreads){
    this.tnum = tnum;
    this.fs = fs;
    this.numThreads = numThreads;
  }

  public void run(){
    for(int i = 0; i < rows * cols; i ++){
      if(i%numThreads == tnum){
        fs[i].step();
      }
    }
  }
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

    public void drawSquares(){
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
 
  
  public void draw(){
    //drawTriangles();
    drawSquares();
  }
  
  public void step(){
    for(int i = 0; i < numNodes; i++){
      particles[i].applyMovement();
    }
    for(int i = 0; i < numNodes; i++){
      particles[i].getNeighbors();
      particles[i].getFill(xOffset, yOffset);
    }
  }
}
public class Particle{
  float x, y, speed, xDir, yDir, xMax, yMax;
  int numNodes;
  double distances[];
  Particle neighbors[];
  Particle nodes[];
  int c;
  
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
    x = (x + (speed * xDir)) % xMax;
    y = (y + (speed * yDir)) % yMax;
    if(x < 0){
      x = xMax;
    }
    if(y < 0){
      y = yMax;
    }
  }
  
  public void getNeighbors(){
    double currDist[] = new double[4];
    double tmp;
    for(int i = 0; i < 4; i++){
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


  public void getFill(float xOffset, float yOffset){
    //TODO: float to ints or something

    float r, g, b;
    int c0, c1, c2, c3;

    c0 = p.get((int)(neighbors[0].x + xOffset), (int)(neighbors[0].y + yOffset));
    c1 = p.get((int)(neighbors[1].x + xOffset), (int)(neighbors[1].y + yOffset));
    c2 = p.get((int)(neighbors[2].x + xOffset), (int)(neighbors[2].y + yOffset));
    c3 = p.get((int)(neighbors[3].x + xOffset), (int)(neighbors[3].y + yOffset));

    r = red(c0) * red(c0) + red(c1) * red(c1) + red(c2) * red(c2) + red(c3) * red(c3);
    g = green(c0) * green(c0) + green(c1) * green(c1) + green(c2) * green(c2) + green(c3) * green(c3);
    b = blue(c0) * blue(c0) + blue(c1) * blue(c1) + blue(c2) * blue(c2) + blue(c3) * blue(c3);
    c = color((int)Math.sqrt(r)/2, (int)Math.sqrt(g)/2, (int)Math.sqrt(b)/2);
  }
  
  public double maxArrayVal(double[] arr){
    double val = arr[0];
    for(int i = 1; i < arr.length; i++){
      if(arr[i] > val) val = arr[i];
    }
    return val;
  }
}
  public void settings() {  size(888, 1200); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "MovingImage" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
