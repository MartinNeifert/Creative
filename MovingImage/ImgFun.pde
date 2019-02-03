int rows = 50;
int cols = 30;
int numThreads = 4;
Field fs[] = new Field[rows * cols];
Thread ts[] = new Thread[numThreads];
Object m;
PImage p;
int fieldSize = 5;
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
  
  //fs[n] = new Field(0, 0, 888, 600, false, 1000);
  //fs[n] = new Field(400, 400, 400, 400, false);

  p = loadImage("HtxiYED.jpg");
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
    //System.out.println("start thread " + i);
  }
  for(int i = 0; i < numThreads; i++){
    try{
      ts[i].join();
      //System.out.println("end thread " + i);
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
        //System.out.println("thread " + tnum + " Running fs " + i);
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
        //System.out.println("thread " + tnum + " Running fs " + i);
        fs[i].step();
      }
    }
  }
}