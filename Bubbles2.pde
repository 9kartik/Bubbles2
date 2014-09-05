/**
 *  Buttons and bodies
 *
 *  by Ricard Marxer
 *
 *  This example shows how to create a blob.
 */

import fisica.*;
import ketai.sensors.*;

FWorld world;

KetaiSensor sensor;
float accelerometerX, accelerometerY, accelerometerZ;
int valx, valy,pvalx,pvaly,nval=0;

int circleCount = 20;
float hole = 50;
float topMargin = 50;
float bottomMargin = 300;
float sideMargin = 100;
float xPos = 0;

void setup() {
  size(displayWidth, displayHeight);
  smooth();

  sensor = new KetaiSensor(this);
  sensor.start();
  orientation(PORTRAIT);
  textAlign(CENTER, CENTER);
  textSize(36);
  valx=0;
  valy=0;
  pvalx=76;
  pvaly=788;
  
  Fisica.init(this);

  world = new FWorld();
  


  FPoly l = new FPoly();
  l.vertex(10, 0);
  l.vertex(0, 0);
  l.vertex(0, height);
  l.vertex(10, height);
  l.vertex(10, height-bottomMargin);
  l.vertex(10, topMargin);
  l.setStatic(true);
  l.setFill(0);
  l.setFriction(50);
  world.add(l);

  FPoly r = new FPoly();
  r.vertex(width-10, 0);
  r.vertex(width, 0);
  r.vertex(width, height);
  r.vertex(width-10, height);
  r.vertex(width-10, height-bottomMargin);
  r.vertex(width-10, topMargin);
  r.setStatic(true);
  r.setFill(0);
  r.setFriction(50);
  world.add(r);
  
  FPoly rx = new FPoly();
  rx.vertex(10, 0);
  rx.vertex(width-10, 0);
  rx.vertex(width-10, 10);
  rx.vertex(10,10);
  rx.vertex(10,0);
  rx.setStatic(true);
  rx.setFill(0);
  rx.setFriction(50);
  world.add(rx);
  
  FPoly ry = new FPoly();
  ry.vertex(10, height-10);
  ry.vertex(width-10, height-10);
  ry.vertex(width-10, height);
  ry.vertex(10,height);
  ry.vertex(10,height-10);
  ry.setStatic(true);
  ry.setFill(0);
  ry.setFriction(50);
  world.add(ry);
  
  FBlob b = new FBlob();
    float s = random(30, 60);
    float space = (width-sideMargin*2-s);
    xPos = (xPos + random(s, space/2)) % space;
    b.setAsCircle(sideMargin + xPos+s/2, height-random(80,100), s, 20);
    b.setStroke(0);
    b.setStrokeWeight(0.5);
    b.setFill(255,90);
    b.setFriction(0);
    world.add(b);
}
int gh=0;
/*void mousePressed()
{
  if(gh++<6)
 { FBlob b = new FBlob();
    float s = random(30, 60);
    float space = (width-sideMargin*2-s);
    xPos = (xPos + random(s, space/2)) % space;
    b.setAsCircle(sideMargin + xPos+s/2, height-random(100), s, 20);
    b.setStroke(0);
    b.setStrokeWeight(0.5);
    b.setFill(255,90);
    b.setFriction(0);
    world.add(b);
}
}*/
void draw() {
  background(80, 80, 200);
  if((nval&3)==1)valx=-width;
  if((nval&3)==2)valx=width;
  if((nval&3)==0)valx=0;
  if((nval&12)==4)valy=height;
  if((nval&12)==8)valy=-height;
  if((nval&12)==0)valy=0;
  //text("("+valx+","+valy+")",width/2,height/2);
 world.setGravity(valx,valy);
  //if ((frameCount % 40) == 1) {
    
  //}

  world.step();
  world.draw();
}
void onAccelerometerEvent(float x, float y, float z)
{
  nval=0;
  if(x<-2) nval|=1;  
  else if(x>2)  nval|=2;
  else nval&=12;  
  if(y<-2) nval|=4;
  else if(y>2) nval|=8;
  else nval&=3;
}
