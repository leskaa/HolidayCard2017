var lightSnow = [];
var gifts = [];
var santa;
var player;
var isLeft, isRight;
var giftImage, santaRight, santaLeft, chimneyBack, chimneyBackLeft, chimneyBackRight, chimneyFront, chimneyFrontLeft, chimneyFrontRight, code;
var milliseconds = 0;
var lastTimeReset = 0;
var score = 0;
var giftSpeed = 4;
var nextDrop = 2;
var dropRate = 6;
var nextDropRateIncrease = 10;
var nextSantaSpeedIncrease = 5000;
var nextGiftSpeedIncrease = 10000;
const GAME_STATE_MENU = 0;
const GAME_STATE_LOST = 1;
const GAME_STATE_PLAYING = 2;
const GAME_STATE_AUTOPLAYING = 3;
var gameState = GAME_STATE_AUTOPLAYING;

function setup() {
  frameRate(30);
  createCanvas(window.innerWidth, window.innerHeight);
  giftImage = loadImage("Data/Gift.png");
  santaRight = loadImage("Data/Santa.png");
  santaLeft = loadImage("Data/SantaLeft.png");
  chimneyBack = loadImage("Data/Chimney.png");
  chimneyBackLeft = loadImage("Data/ChimneyLeft.png");
  chimneyBackRight = loadImage("Data/ChimneyRight.png");
  chimneyFront = loadImage("Data/ChimneyFront.png");
  chimneyFrontLeft = loadImage("Data/ChimneyFrontLeft.png");
  chimneyFrontRight = loadImage("Data/ChimneyFrontRight.png");
  code = loadImage("Data/QRCode.png");
  santa = new Sleigh();
  player = new Chimney();
  for (var i = 0; i < (width + height) / 20; i++) {
    lightSnow.push(new Snowflake());
  }
}

function draw() {
  milliseconds = millis() - lastTimeReset;
  background(50, 89, 100);
  touchInput();

  for (var i = 0; i < lightSnow.length; i++) {
    lightSnow[i].move();
    lightSnow[i].display();
  }
  if (gameState == GAME_STATE_MENU) {
    drawMenu();
  } else if (gameState == GAME_STATE_LOST) {
    drawLoss();
  } else if (gameState == GAME_STATE_PLAYING) {
    drawPlaying();
  } else if (gameState == GAME_STATE_AUTOPLAYING) {
    drawAutoplaying();
  }
}

function drawMenu() {
  textSize(width / 12.5);
  text("Happy Holidays", width / 4, height / 4);
  image(code, width/6, height/3);
  textSize(width / 40);
  text("try the game!", width/2.2, height/2.6);
  text("Portrait Mode Safari or Chrome on IPad", width/2.2, height/2.1);
  text("Use the arrow keys or touch sides of screen to catch gifts.", width / 5, height / 1.33);
  textSize(width / 20);
  text("Press left or right to start!", width / 4.29, height / 1.14);
  if (isRight || isLeft) {
    reset();
    gameState = GAME_STATE_PLAYING;
  }
  if(milliseconds/1000>20){
    reset();
    score = 0;
    gameState = GAME_STATE_AUTOPLAYING;
  }
}

function drawLoss() {
  textSize(width / 12.5);
  text("Happy Holidays", width / 4, height / 4);
  image(code, width/6, height/3);
  textSize(width / 20);
  text("You Caught: " + score + " Gifts!", width / 3.5, height / 1.6);
  textSize(width / 40);
  text("try the game!", width/2.2, height/2.6);
  text("Portrait Mode Safari or Chrome on IPad", width/2.2, height/2.1);
  text("Use the arrow keys or touch sides of screen to catch gifts.", width / 5, height / 1.33);
  textSize(width / 20);
  text("Press left or right to start!", width / 4.29, height / 1.14);
  if (isRight || isLeft) {
    reset();
    score = 0;
    gameState = GAME_STATE_PLAYING;
  }
  if(milliseconds/1000>20){
    reset();
    score = 0;
    gameState = GAME_STATE_AUTOPLAYING;
  }
}

function drawPlaying() {
  edgeCollision();
  difficultyIncrease();

  if (random(400) < 1) {
    gifts.push(new Gift());
  }

  if (milliseconds / 1000 > nextDrop) {
    nextDrop += dropRate;
    gifts.push(new Gift());
  }

  santa.move();
  player.move();
  player.displayBack();

  for (var j = gifts.length - 1; j >= 0; j--) {
    gifts[j].velocity = giftSpeed;
    gifts[j].move();
    gifts[j].display();
    gifts[j].processCollision(j);
  }

  santa.display();
  player.displayFront();
  drawScore();
}

function drawAutoplaying() {
  
  edgeCollision();
  difficultyIncrease();

  if (random(400) < 1) {
    gifts.push(new Gift());
  }

  if (milliseconds / 1000 > nextDrop) {
    nextDrop += dropRate;
    gifts.push(new Gift());
  }

  santa.move();
  var lowest = 0;
  for (var k = gifts.length - 1; k >= 0; k--) {
    if(gifts[k].y>gifts[lowest].y){
      lowest=k;
    }
  }
  if(gifts.length>0&&player.x>gifts[lowest].x){
    isRight=false;
    isLeft=true;
  }
  if(gifts.length>0&&player.x<gifts[lowest].x){
    isLeft=false;
    isRight=true;
  }
  if(gifts.length>0&&player.x>gifts[lowest].x-15&&player.x<gifts[lowest].x+15){
    isLeft=false;
    isRight=false;
  }
  player.move();
  player.displayBack();

  for (var j = gifts.length - 1; j >= 0; j--) {
    gifts[j].velocity = giftSpeed;
    gifts[j].move();
    gifts[j].display();
    gifts[j].processCollision(j);
  }

  santa.display();
  player.displayFront();
  drawScore();
  image(code, width/6, height/3);
  textSize(width / 40);
  fill('#FFFFFFF');
  text("try the game!", width/2.2, height/2.6);
  text("Portrait Mode Safari or Chrome on IPad", width/2.2, height/2.1);
  
  if(keyIsPressed===true||touches.length>0){
    reset();
    score = 0;
    gameState = GAME_STATE_PLAYING;
  }
}

function difficultyIncrease() {
  if (milliseconds / 1000 > nextDropRateIncrease && dropRate > 1) {
    nextDropRateIncrease += 20;
    dropRate--;
  }
  if (milliseconds > nextGiftSpeedIncrease) {
    giftSpeed++;
    nextGiftSpeedIncrease += 10000;
    if (milliseconds > nextSantaSpeedIncrease) {
      santa.speed++;
      nextSantaSpeedIncrease += 5000;
    }
  }
}

function reset() {
  player.x = width / 2;
  player.y = height - 50;
  player.speed = 0;
  santa.x = width / 2;
  santa.y = 80;
  santa.speed = 4;
  santa.wayPoint = 50;
  nextSantaSpeedIncrease = 5000;
  nextGiftSpeedIncrease = 10000;
  giftSpeed = 4;
  nextDrop = 2;
  dropRate = 6;
  nextDropRateIncrease = 10;
  gifts = [];
  lastTimeReset = millis();
}

function drawScore() {
  textSize(120);
  fill("#000080");
  if (score < 10) {
    text(score, player.x - 35, player.y - 150);
  } else {
    text(score, player.x - 75, player.y - 150);
  }
}

function touchInput() {
  if (touches.length < 1 && keyIsPressed === false) {
    isLeft = false;
    isRight = false;
  }
  for (var i = 0; i < touches.length; i++) {
    if (touches[i].x < window.innerWidth / 2) {
      isLeft = true;
      isRight = false;
    }
    if (touches[i].x > window.innerWidth / 2) {
      isRight = true;
      isLeft = false;
    }
  }
}

function edgeCollision() {
  if (player.x < 80) {
    isLeft = false;
    player.speed = 0;
  }
  if (player.x > width - 80) {
    isRight = false;
    player.speed = 0;
  }
}

function keyPressed() {
  setKeyInput(keyCode, true);
}

function keyReleased() {
  setKeyInput(keyCode, false);
}

function setKeyInput(k, b) {
  switch (k) {
    case 37:
      return (isLeft = b);
    case 39:
      return (isRight = b);
    default:
      return b;
  }
}

function Chimney() {
  this.x = width / 2;
  this.y = height - 50;
  this.speed = 0;

  this.move = function() {
    if (isLeft) {
      if (this.speed > -12)
        this.speed = -12;
      this.speed -= 0.1;
    }
    if (isRight) {
      if (this.speed < 12)
        this.speed = 12;
      this.speed += 0.1;
    }
    if (this.speed > 0 && (!(isRight || isLeft)))
      this.speed = 0;
    if (this.speed < 0 && (!(isRight || isLeft)))
      this.speed = 0;
    this.x += this.speed;
  }

  this.displayBack = function() {
    if (this.speed > 1) {
      tint(255, milliseconds / 5);
      image(chimneyBackLeft, this.x - 100, this.y - 80);
      tint(255, 255);
    }
    if (this.speed < 1 && this.speed > -1) {
      tint(255, milliseconds / 5);
      image(chimneyBack, this.x - 100, this.y - 80);
      tint(255, 255);
    }
    if (this.speed < -1) {
      tint(255, milliseconds / 5);
      image(chimneyBackRight, this.x - 100, this.y - 80);
      tint(255, 255);
    }
  }

  this.displayFront = function() {
    if (this.speed > 1) {
      tint(255, milliseconds / 10);
      image(chimneyFrontLeft, this.x - 100, this.y - 80);
      tint(255, 255);
    }
    if (this.speed < 1 && this.speed > -1) {
      tint(255, milliseconds / 10);
      image(chimneyFront, this.x - 100, this.y - 80);
      tint(255, 255);
    }
    if (this.speed < -1) {
      tint(255, milliseconds / 10);
      image(chimneyFrontRight, this.x - 100, this.y - 80);
      tint(255, 255);
    }
  }
}

function Gift() {
  if (santa.x < santa.wayPoint) {
    this.x = santa.x + 20;
  } else {
    this.x = santa.x + 100;
  }
  this.y = santa.y + 30;
  this.wind = 0.4;
  this.velocity = giftSpeed;
  this.direction = 90;

  this.move = function() {
    this.y += this.velocity;
    this.x += this.wind;
  }

  this.display = function() {
    image(giftImage, this.x - 30, this.y - 30);
  }

  this.processCollision = function(index) {
    if (this.y > height - 100) {
      if (this.collision(player.x - 70, player.y - 40, 30, 90)) {
        if (this.checkSide(player.x - 65)) {
          this.nudge(player.speed + 5);
        } else {
          this.nudge(player.speed - 5);
        }
      } else if (this.collision(player.x + 40, player.y - 40, 30, 90)) {
        if (this.checkSide(player.x + 45)) {
          this.nudge(player.speed + 5);
        } else {
          this.nudge(player.speed - 5);
        }
      } else if (this.collision(player.x - 40, player.y + 30, 80, 20)) {
        gifts.splice(index, 1);
        score++;
      } else if (this.y > height + 50) {
        gameState = GAME_STATE_LOST;
        reset();
      }
    }
  }

  this.collision = function(x, y, w, h) {
    if (this.x - 30 < x + w &&
      this.x + 30 > x &&
      this.y < y + h &&
      this.y + 30 > y) {
      return true;
    }
    return false;
  }

  this.checkSide = function(x) {
    return this.x - x > 0;
  }

  this.nudge = function(s) {
    this.x += s;
  }
}

function Sleigh() {
  this.x = width / 2;
  this.y = 80;
  this.speed = 4;
  this.wayPoint = 50;

  this.move = function() {
    if (this.x > this.wayPoint - this.speed && this.x < this.wayPoint + this.speed)
      this.wayPoint = random(50, width - (100 + height / 20));
    if (this.x > this.wayPoint)
      this.x -= this.speed;
    if (this.x < this.wayPoint)
      this.x += this.speed;
  };

  this.display = function() {
    if (this.x < this.wayPoint) {
      tint(255, milliseconds / 10);
      image(santaRight, this.x, this.y);
      tint(255, 255);
    }
    if (this.x > this.wayPoint) {
      tint(255, milliseconds / 10);
      image(santaLeft, this.x, this.y);
      tint(255, 255);
    }
  };
}

function Snowflake() {
  //Snowflake's position on the screen
  this.x = random(-200, width);
  this.y = random(-2000, 0);
  //Angle to determine position in sin wave path
  this.angle = random(360);
  //Drift y-value to simulate wind
  this.wind = 0.4;
  //Size of Snowflake
  this.snowDepth = random(3, 10);
  this.size = this.snowDepth;
  this.velocity = this.snowDepth / 3;
  //Direction Snowflake is falling
  this.direction = random(85, 95);

  this.move = function() {
    this.angle += 0.03;
    this.y += this.velocity;
    this.x += sin(this.angle) / 2;
    this.x += this.wind;
    if (this.y > height + 50) {
      this.y = -10;
      this.x = random(-200, width);
    }
  };

  this.display = function() {
    fill('#FFFCFD');
    ellipse(this.x, this.y, this.size, this.size);
  };
}