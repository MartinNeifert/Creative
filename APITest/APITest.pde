JSONObject j0, j1, atr;
JSONArray j2;

int lonOffset = 72;
int latOffset = -42;

float latScale = 300;
float lonScale = 400;

int wait = 2;

public class Vehicle{
  String name;
  float lon, lat;

  public Vehicle(String name, float lon, float lat){
    this.name = name;
    this.lon = lon;
    this.lat = lat;
  }
}

Vehicle vs[] = new Vehicle[1000];
int num = 0;

void setup(){
  size(500, 500);
  //System.out.println(j2);
}

void getData(){
  j0 = loadJSONObject("https://api-v3.mbta.com/vehicles");
  j2 = j0.getJSONArray("data");
  num = 0;
  for(int i = 0; i < j2.size(); i++){
    j1 = j2.getJSONObject(i);
    atr = j1.getJSONObject("attributes");
    vs[i] = new Vehicle(j1.getString("id"), atr.getFloat("longitude"), atr.getFloat("latitude"));
    System.out.println("Vehicle " + vs[i].name + " at lon = " + vs[i].lon + " lat = " + vs[i].lat);
    num ++;
  }
}

void draw(){
  getData();
  for(int i = 0; i < num; i++){
    ellipse((vs[i].lon + lonOffset) * lonScale , (vs[i].lat + latOffset) * latScale, 1.0, 1.0);
  }
  delay(wait * 1000);
}
