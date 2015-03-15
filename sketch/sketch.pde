void setup(){
  size( 800, 600 );
  frameRate(1);
}

void draw() {
  float range = 50;
  float startX = random(0,width);
  float startY = random(0,height);

  float secondX = random(startX-range,startX+range);
  float secondY = random(startY-range,startY+range);

  float lastX = random(secondX-range,secondX+range);
  float lastY = random(secondY-range,startY+range);
   
  noStroke();
  fill(255, 211, 80);
  triangle(startX, startY, secondX, secondY, lastX, lastY);
}
