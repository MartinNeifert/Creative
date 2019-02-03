public class Particle implements Runnable {
  float x, y, speed, xDir, yDir, xMax, yMax;
  int numNodes;
  double distances[];
  Particle neighbors[];
  Particle nodes[];
  
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
  
  public void run(){
    applyMovement();
    getNeighbors();
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
    double farthestDistance = 99999999;
    double currDist = 0;
    for(int i = 0; i < neighbors.length; i++){
      distances[i] = farthestDistance;
      neighbors[i] = null;
    }
    
    for(int i = 0; i < numNodes; i++){
      if(nodes[i] != this){
        currDist = Math.sqrt(Math.pow((x - nodes[i].x), 2) + Math.pow((y - nodes[i].y), 2));
        if(currDist < farthestDistance){
          int j = 0;
          while(distances[j] < farthestDistance){
            j++;
          }
          distances[j] = currDist;
          neighbors[j] = nodes[i];
          farthestDistance = maxArrayVal(distances);
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
