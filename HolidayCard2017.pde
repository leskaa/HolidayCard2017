boolean isLeft, isRight, isUp, isDown, isEnter, isSpace;
PImage giftImage, santaRight, santaLeft, chimneyBack, chimneyBackLeft, chimneyBackRight, chimneyFront, chimneyFrontLeft, chimneyFrontRight, moon;
Sleigh santa = new Sleigh(600, 20, 2);
Snow lightSnow = new Snow(200);
Chimney player = new Chimney(600, 750);
GiftController listOfGifts = new GiftController();
int seconds = 0;
int score = 0;
int milliseconds = 0;
int lastTimeReset = 0;
boolean gameState = false;
//Menu starts as main menu (Main Menu = 0, Loss Menu = 1)
int menuType = 0;
void setup() {
  size(1200, 800);
  //Set all PImage variables to images in data file
  moon = loadImage("Data/MoonBackgroundDark.png");
  giftImage = loadImage("Data/Gift.png");
  santaRight = loadImage("Data/Santa.png");
  santaLeft = loadImage("Data/SantaLeft.png");
  chimneyBack = loadImage("Data/Chimney.png");
  chimneyBackLeft = loadImage("Data/ChimneyLeft.png");
  chimneyBackRight = loadImage("Data/ChimneyRight.png");
  chimneyFront = loadImage("Data/ChimneyFront.png");
  chimneyFrontLeft = loadImage("Data/ChimneyFrontLeft.png");
  chimneyFrontRight = loadImage("Data/ChimneyFrontRight.png");
}

void draw() {
  if (gameState==true) {
    milliseconds=millis() - lastTimeReset;
    seconds = (int)(milliseconds/1000);
    //Set Grey Background and fade in Moon Background
    background(51);
    tint(255, milliseconds/50);
    image(moon, 0, 0);
    tint(255, 255);
    //Update all Objects and show score
    lightSnow.update();
    player.update();
    listOfGifts.update(seconds);
    player.drawFront();
    santa.update(seconds);
    displayScore();
    menuType=1;
  }
  if ( gameState==false) {
    milliseconds=millis() - lastTimeReset;
    background(51);
    lightSnow.update();
    textSize(80);
    text("Happy Holidays", 300, 200);
    textSize(50);
    text("Use the arrow keys to catch gifts.", 200, 600);
    text("Press left or right to start!", 280, 700);
    if (menuType==1) {
      tint(255, 255-milliseconds/2);
      image(moon, 0, 0);
      tint(255, 255);
      text("You caught", 300, 400);
      fill(1, 102, 153);
      textSize(60);
      text(score, 600, 400);
      textSize(50);
      fill(#FFFFFF);
      if(score<10)
      text("gifts!", 660, 400);
      if(score>9&&score<100)
      text("gifts!", 700, 400);
      if(score>99)
      text("gifts!", 740, 400);
    }
    //Check to see if player starts game
    if ((isLeft||isRight)&&milliseconds>1000) {
      mainReset();
      startTimer();
      gameState=true;
      score = 0;
    }
  }
}

//Start a timer of milliseconds
void startTimer() {
  lastTimeReset=millis();
  milliseconds=millis() - lastTimeReset;
}

//Reset all objects
void mainReset() {
  santa.reset();
  player.reset();
  listOfGifts.reset();
  startTimer();
}

//Activated if a key is pressed
void keyPressed() {
  setMove(keyCode, true);
}

//Activated if a key is released
void keyReleased() {
  setMove(keyCode, false);
}

//Increments score by one
void addScore() {
  score++;
}

//Shows score above player
void displayScore() {
  textSize(100);
  fill(1, 102, 153);
  if (score<10)
    text(score, player.getX()-35, 600);
  if (score>9)
    text(score, player.getX()-70, 600);
}

//Determines what key is pressed
boolean setMove(int k, boolean b) {
  switch (k) {
  case LEFT:
    return isLeft = b;

  case RIGHT:
    return isRight = b;

  default:
    return b;
  }
}

public class Chimney {
  //Position of Chimney on screen
  private int xPos;
  private int yPos;
  //Current speed Chimney is moving
  private float speed;

  public Chimney(int xPos, int yPos) {
    this.xPos=xPos;
    this.yPos=yPos;
    this.speed=0;
  }

  public int getX() {
    return xPos;
  }

  public int getY() {
    return yPos;
  }

  public float getSpeed() {
    return speed;
  }

  //Set the value for speed based on key input
  public void move() {
    if (isLeft) {
      if (speed>-7) {
        speed=-7;
      }
      speed-=0.1;
    }
    if (isRight) {
      if (speed<7) {
        speed=7;
      }
      speed+=0.1;
    }
    if (xPos>1120) {
      xPos=1119;
      speed=0;
    }
    if (xPos<80) {
      xPos=81;
      speed=-0;
    }
  }

  //Update the position of Hitboxes and Graphical Component of Chimney
  public void update() {
    move();
    //Stops movement if no key is pressed
    if (speed>0&&(!(isRight||isLeft))) {
      speed=0;
    }
    if (speed<0&&(!(isRight||isLeft))) {
      speed=0;
    }
    xPos+=speed;
    if (speed>1) {
      tint(255, milliseconds/5);
      image(chimneyBackLeft, xPos-100, yPos-80);
      tint(255, 255);
    }
    if (speed<1&&speed>-1) {
      tint(255, milliseconds/5);
      image(chimneyBack, xPos-100, yPos-80);
      tint(255, 255);
    }
    if (speed<-1) {
      tint(255, milliseconds/5);
      image(chimneyBackRight, xPos-100, yPos-80);
      tint(255, 255);
    }
  }

  //Draws front of Chimney (To allow for present to fall into chimney "3d")
  public void drawFront() {
    if (speed>1) {
      tint(255, milliseconds/10);
      image(chimneyFrontLeft, xPos-100, yPos-80);
      tint(255, 255);
    }
    if (speed<1&&speed>-1) {
      tint(255, milliseconds/10);
      image(chimneyFront, xPos-100, yPos-80);
      tint(255, 255);
    }
    if (speed<-1) {
      tint(255, milliseconds/10);
      image(chimneyFrontRight, xPos-100, yPos-80);
      tint(255, 255);
    }
  }

  //Sets chimney back to starting state for new game
  public void reset() {
    speed=0;
    xPos=600;
  }
}

public class Gift {
  //Position of Gift on Screen
  private float xPos;
  private float yPos;
  //Angle to determine position in sin wave path
  private float angle;
  //Drift y-value to simulate wind
  private float wind = 0.4;
  //Rate of falling (Gravity)
  private float velocity = 2;
  //Direction of falling
  private float direction = 90;
  //Next time falling speed increases (seconds)
  private int nextSpeedIncrease = 20;
  
  public Gift(float xPos, float yPos) {
    this.xPos=xPos;
    this.yPos=yPos;
    //Start gifts at random point on sin path
    angle=(float)Math.random()*360;
  }

  //Update the position of Hitboxes and Graphical Component of Gift
  public void update() {
    if (seconds>nextSpeedIncrease) {
      velocity++;
      nextSpeedIncrease+=20;
    }
    angle+=0.03;
    this.yPos+=(velocity)*sin(radians(direction));
    this.xPos+=+(velocity)*cos(radians(direction));
    this.xPos+=wind;
    image(giftImage, xPos-30, yPos-30);
  }
  
  //Push gift a direction in X (Used for forces due to contact with Chimney)
  public void push(float speed){
    xPos+=speed;
  }

  //Returns true if present falls off screen
  public boolean gameLoss() {
    if (this.yPos>820) {
      return true;
    }
    return false;
  }

  //Returns if gift is closer to inside or outside of chimney (Used if gift his edge)
  public boolean checkSide(int x){
    return this.xPos-x>0;
  }
  
  //Uses Axis-Alligned Bounding Boxes to determine if Collision occurs between gift and other object
  public boolean chimneyCollision(int x, int y, int width, int height) {
    if (this.xPos - 30 < x + width &&
      this.xPos + 30 > x &&
      this.yPos < y + height &&
      this.yPos + 30 > y) {
      return true;
    }
    return false;
  }
}

import java.util.Iterator;
public class GiftController {
  //List of Gifts that are falling
  private ArrayList<Gift> gifts = new ArrayList<Gift>();
  //Time in seconds of next forced drop
  float nextDrop = 1.0;
  //Time between each forced drop
  float dropInterval = 4;
  //Time until time between each forced drop is reduced
  int nextSpeedIncrease = 10;
  
  public GiftController() {
  }
  
  //Updates each gift's position and checks for loss or collision
  public void update(int seconds) {
    //flag used to prevent concurent modification error
    boolean lossFlag = false;
    for (int i = gifts.size()-1; i>=0; i--) {
      Gift current = gifts.get(i);
      current.update();
      //Check if gift fell past screen
      if (current.gameLoss()) {
        gameState=false;
        lossFlag=true;
      }
      //Check for chimney collision on left side of player
      if (current.chimneyCollision(player.getX()-70, player.getY()-40, 30, 90)) {
        //determine direction to push gift based on if is is closer to inside or outside of chimney
        if (current.checkSide(player.getX()-65)) {
          current.push(player.getSpeed()+5);
        } else {
          current.push(player.getSpeed()-5);
        }
      }
      //Check for chimney collision on right side of player
      if (current.chimneyCollision(player.getX()+40, player.getY()-40, 30, 90)) {
        //determine direction to push gift based on if is is closer to inside or outside of chimney
        if (current.checkSide(player.getX()+45)) {
          current.push(player.getSpeed()+5);
        } else {
          current.push(player.getSpeed()-5);
        }
      }
      //Check if gift has made it to bottom of chimney and increase score
      if (current.chimneyCollision(player.getX()-40, player.getY()+30, 80, 20)) {
        gifts.set(null);
        addScore();
      }
    }
    //Increases the rate that gifts drop over time
    if (seconds>nextSpeedIncrease&&dropInterval>1) {
      nextSpeedIncrease+=10;
      dropInterval-=1;
    }
    //Forced Drop & Random Drop that increases in chance over time
    if (seconds>nextDrop) {
      dropGift(santa.getX());
      nextDrop+=dropInterval;
    } else if ((int)(Math.random()*(400-seconds))<1) {
      dropGift(santa.getX());
    }
    //Reset game after finishing iteration
    if(lossFlag){
      lossFlag=false;
      mainReset();
    }
  }
  
  //Drop a new gift from where the sleigh is
  public void dropGift(int xPos) {
    gifts.add(new Gift(xPos+30, 50));
  }
  
  //Sets gifts back to starting state for new game
  public void reset(){
    nextDrop = 1.0;
    dropInterval = 4;
    nextSpeedIncrease = 10;
    gifts.clear();
  }
}

public class Sleigh {
  //Position of Sleigh on Screen
  private int xPos;
  private int yPos;
  //Speed sleigh is moving
  private float speed;
  //Next Waypoint for sleigh to travel to
  private float wayPoint;
  //Next time that sleigh increases in speed
  private int nextSpeedIncrease;
  public Sleigh(int xPos, int yPos, float speed) {
    this.xPos=xPos;
    this.yPos=yPos;
    this.speed=speed;
    //Starting waypoint
    this.wayPoint=50;
    this.nextSpeedIncrease=10;
  }
  
  public int getX(){
    return xPos;
  }
    
  //Updates each sleigh's position and graphics
  public void update(int seconds) {
    if (seconds>this.nextSpeedIncrease) {
      speed++;
      nextSpeedIncrease+=12;
    }
    //If at waypoint generate a new one
    if (this.xPos<this.wayPoint+speed*2&&this.xPos>this.wayPoint-speed*2) {
      setNewWayPoint();
    }
    //Move towards waypoint if on right
    if (this.xPos<this.wayPoint) {
      fill(#DE4A56);
      this.xPos+=speed;
      tint(255, milliseconds/20);
      image(santaRight, xPos, yPos);
      tint(255, 255);
    }
    //Move towards waypoint if on left
    if (this.xPos>this.wayPoint) {
      fill(#E52760);
      this.xPos-=speed;
      tint(255, milliseconds/20);
      image(santaLeft, xPos-100, yPos);
      tint(255, 255);
    }
  }

  //Create a new random point for the sleigh to travel to
  public void setNewWayPoint() {
    this.wayPoint=(int)(Math.random()*850+50);
  }
  
  //Set sleigh back to starting state for new game
  public void reset(){
    xPos=600;
    speed=2;
    nextSpeedIncrease=10;
    wayPoint=50;
  }
}

public class Snow {
  //List of snowflakes that are falling
  private ArrayList<Snowflake> snowflakes = new ArrayList<Snowflake>();
  
  //Create a new snow object with number of flakes
  public Snow(int numOfFlakes){
    for(int i = 0; i<numOfFlakes; i++){
      float snowDepth = (int)(Math.random()*7+3);
      snowflakes.add(new Snowflake((float)(Math.random()*1800-600), (float)(Math.random()*-2000), (int)snowDepth, snowDepth/4, (int)(Math.random()*6+87)));
    }
  }
  
  //Call each snowflakes update method
  public void update(){
    for(Snowflake i: snowflakes){
      i.update();
    }
  }
  
}

public class Snowflake {
  //Snowflake's position on the screen
  private float xPos;
  private float yPos;
  //Angle to determine position in sin wave path
  private float angle;
  //Drift y-value to simulate wind
  private float wind = 0.4;
  //Size of Snowflake
  private int size;
  //Fall rate of Snowflake
  private float velocity;
  //Direction Snowflake is falling
  private float direction;
  
  public Snowflake(float xPos, float yPos, int size, float velocity, float direction){
    this.xPos=xPos;
    this.yPos=yPos;
    this.size=size;
    this.velocity=velocity;
    this.direction=direction;
    //Random starting position in sin wave path
    angle=(float)Math.random()*360;
  }
  
  //Update the position of Snowflake Graphics
  public void update(){
    angle+=0.03;
    this.yPos+=(velocity)*sin(radians(direction));
    this.xPos+=sin(angle)/4+(velocity)*cos(radians(direction));
    this.xPos+=wind;
    fill(#FFFCFD);
    ellipse(xPos, yPos, size, size);
    if(yPos>850){
      this.yPos=-10;
      this.xPos=(int)(Math.random()*1800-600);
    }
  }
}
