int rows = 10;
int cols = 10;
Field fs[] = new Field[rows * cols];
Object m;
int fieldSize = 100;

void setup(){
  size(1000, 500);
  int n = 0;
  
  for(int i = 0; i < rows; i++){
    for(int j = 0; j < cols; j++){
      fs[n] = new Field(j*fieldSize, i*fieldSize, fieldSize, fieldSize, false, 2);
      n++;
    }
  }  
  
  
  
  //fs[n] = new Field(0, 0, 500, 500, false, 5);
  //fs[n] = new Field(400, 400, 400, 400, false);
}

void draw(){
  clear();
  background(255,0,0);
  for(int i = 0; i < fs.length; i++){
    fs[i].step();
  }
  for(int i = 0; i < fs.length; i++){
    fs[i].draw();
  }
}