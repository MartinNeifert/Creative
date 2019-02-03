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

void setup(){
  size(888, 1200);
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

void draw(){
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

  void run(){
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

  void run(){
    for(int i = 0; i < rows * cols; i ++){
      if(i%numThreads == tnum){
        fs[i].step();
      }
    }
  }
}