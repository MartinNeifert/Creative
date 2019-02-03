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
  
  double maxArrayVal(double[] arr){
    double val = arr[0];
    for(int i = 1; i < arr.length; i++){
      if(arr[i] > val) val = arr[i];
    }
    return val;
  }
}
