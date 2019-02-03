public class Particle{
  float x, y, speed, xDir, yDir, xMax, yMax;
  int numNodes;
  double distances[];
  Particle neighbors[];
  Particle nodes[];
  color c;
  
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


  void getFill(float xOffset, float yOffset){
    //TODO: float to ints or something

    float r, g, b;
    color c0, c1, c2, c3;

    c0 = p.get((int)(neighbors[0].x + xOffset), (int)(neighbors[0].y + yOffset));
    c1 = p.get((int)(neighbors[1].x + xOffset), (int)(neighbors[1].y + yOffset));
    c2 = p.get((int)(neighbors[2].x + xOffset), (int)(neighbors[2].y + yOffset));
    c3 = p.get((int)(neighbors[3].x + xOffset), (int)(neighbors[3].y + yOffset));

    r = red(c0) * red(c0) + red(c1) * red(c1) + red(c2) * red(c2) + red(c3) * red(c3);
    g = green(c0) * green(c0) + green(c1) * green(c1) + green(c2) * green(c2) + green(c3) * green(c3);
    b = blue(c0) * blue(c0) + blue(c1) * blue(c1) + blue(c2) * blue(c2) + blue(c3) * blue(c3);
    c = color((int)Math.sqrt(r)/2, (int)Math.sqrt(g)/2, (int)Math.sqrt(b)/2);
  }
  
  double maxArrayVal(double[] arr){
    double val = arr[0];
    for(int i = 1; i < arr.length; i++){
      if(arr[i] > val) val = arr[i];
    }
    return val;
  }
}
