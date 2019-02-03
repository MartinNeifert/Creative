import themidibus.*;

MidiBus b = new MidiBus(this, 0, -1);
Field fs[] = new Field[4];
Thread ts[] = new Thread[4];
Semaphore s = new Semaphore(4);
Object m;

void setup(){
  MidiBus.list();
  size(500, 500);
  m = new Object();
  background(255,0,0);
  fs[0] = new Field(50, 50, 200, 200, true);
  fs[1] = new Field(50, 250, 200, 200, false);
  fs[2] = new Field(250, 50, 200, 200, false);
  fs[3] = new Field(250, 250, 200, 200, true);
  
  for(int i = 0; i < fs.length; i++){
    ts[i] = new Thread(fs[i]);
    ts[i].start();
  }
}

void getSem(){
  try{
      s.acquire();
    } catch(InterruptedException exc){
      System.out.println(exc); 
    }
}

void draw(){
  clear();
  background(255,0,0);
  synchronized(m){
    for(int i = 0; i < 4; i++){
      getSem();
    }
    for(int i = 0; i < fs.length; i++){
      fs[i].draw();
    }
    m.notifyAll();
    for(int i = 0; i < 4; i++){
      s.release();
    }
  }
}

void mousePressed(){
  fs[0].xMax = 1000;
  fs[1].xMax = 1000;
}

void mouseReleased(){
  fs[0].xMax = 200;
  fs[1].xMax = 200;
}

void noteOn(int channel, int pitch, int velocity) {
  int x = 0;
  //System.out.println(pitch);
  switch(pitch){
    case 36:
      x = 0;
      break;
    case 40:
      x = 1;
      break;
    case 48:
      x = 2;
      break;
    case 49:
      x = 3;
      break;
  }
  fs[x].g = random(255);
  fs[x].b = random(255);
  fs[x].r = random(255);
}