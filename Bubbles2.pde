/**
 *  Buttons and bodies
 *
 *  by Ricard Marxer
 *
 *  This example shows how to create a blob.
 */

import fisica.*;
import ketai.sensors.*;
import ketai.data.*;
FWorld world;

KetaiSensor sensor;
KetaiSQLite db;

String CREATE_DB_SQL = "CREATE TABLE hi_skoar_bubbles (Skoar INTEGER);";

float accelerometerX, accelerometerY, accelerometerZ;
int valx, valy,pvalx,pvaly,nval=0;

int circleCount = 20;
float hole = 50;
float topMargin = 50;
float bottomMargin = 300;
float sideMargin = 100;
float xPos = 0;
int skoar=0;
 FBlob b = new FBlob();
 FPoly l = new FPoly();
 FPoly r = new FPoly();
 FPoly rx = new FPoly();
 FPoly ry = new FPoly();
void setup() {
  db = new KetaiSQLite(this);
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
  //--------------------------------------------------------------
if ( db.connect() )
  {
    // for initial app launch there are no tables so we make one
    if (!db.tableExists("hi_skoar_bubbles"))
      {
        db.execute(CREATE_DB_SQL);
        print("creating table");
      }
  }
  //-----------------------------------------------------------------
  
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
  
  
  rx.vertex(10, 0);
  rx.vertex(width-10, 0);
  rx.vertex(width-10, 10);
  rx.vertex(10,10);
  rx.vertex(10,0);
  rx.setStatic(true);
  rx.setFill(0);
  rx.setFriction(50);
  world.add(rx);
  
  
  ry.vertex(10, height-10);
  ry.vertex(width-10, height-10);
  ry.vertex(width-10, height);
  ry.vertex(10,height);
  ry.vertex(10,height-10);
  ry.setStatic(true);
  ry.setFill(0);
  ry.setFriction(50);
  world.add(ry);
  
  
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
float Xx,Yy;

boolean gameEnd=false,hx=true;
String shotext;
void draw() {
  if(!gameEnd)background(80, 80, 200);
  else {
      background(255,0,0);
      if (db.connect() && hx)
    {   
    if (!db.execute("INSERT into hi_skoar_bubbles (`Skore`) VALUES ('"+skoar/10+"')"))
      println("Failed to record data!" );
      db.query( "SELECT * FROM hi_skoar_bubbles" );
      shotext="Hi Skore :"+Integer.parseInt(db.getFieldMax("hi_skoar_bubbles","Skore"));
      hx=false;
    }
  }
  f1=0;
  if((nval&3)==1)valx=-(int)(abs(xlx))*100;
  if((nval&3)==2)valx=(int)(abs(xlx))*100;
  if((nval&3)==0)valx=0;
  if((nval&12)==4)valy=(int)(abs(xly))*100;
  if((nval&12)==8)valy=-(int)(abs(xly))*100;
  if((nval&12)==0)valy=0;
  world.setGravity(valx,valy);
  
    if(!gameEnd){
        shotext=""+skoar/10;
    }
   
  world.step();
    text(shotext,width*0.5,10);
  world.draw();
}

void mousePressed()
{
  if(gameEnd) {
    hx=true;
    gameEnd=false;
    skoar=0;
  }  
}
int  f1=0;
void contactStarted(FContact c)
{
  shotext="GameEnd";
  //b.removeFromWorld();
  
  gameEnd=true;
}
float xlx,xly;
void onAccelerometerEvent(float x, float y, float z)
{
  xlx=x;
  xly=y;
  nval=0;
  if(x<-2) nval|=1;  
  else if(x>2)  nval|=2;
  else nval&=12;  
  if(y<-2) nval|=4;
  else if(y>2) nval|=8;
  else nval&=3;
  skoar++;
  //Xx=b.getAnchorX();
  //Yy=b.getAnchorY();
}
