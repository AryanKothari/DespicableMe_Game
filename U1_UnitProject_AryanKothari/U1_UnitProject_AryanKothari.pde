/*
This unit project is my development of what I did for project 2. In this game, Bob's mission is to get to his pizza, 
 while blocking the objects falling from the sky. Since the creater of the game, ME, is generous, You are provided with three lives before losing. Good luck, 
 and may the odds be ever in your favor! BYEEE
 */

//Music libary for song 
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;
Minim minim;
AudioPlayer song;
AudioPlayer song2;
AudioPlayer input;
AudioPlayer song3;
AudioPlayer crying;
int screen = 0; //Levels
PImage HeartEmoji; //Images that I will be using in my game
PImage BobFront;
PImage Door;
PImage Pizza;
PImage Broc;
PImage Brick;
PImage Castle;
PImage Bob;
PImage Level2;
PImage Defense;
PImage Heaven;
PImage Hell;
PImage Holy;
PImage SadMinion;
boolean CollisionDetected = false;
boolean Playing = false; //movement controls 
int Lives = 3;
float velY = 5;
float velX = 5;
float bobX;
float DoorY;
float DoorX;
float bobY;
int LastTime = millis();
float r = random(255);
float g = random(255);
float b = random(255);
int time;
float barrierY[] = new float [6];
float barrierX[] = new float [6];
float randomSize[] = new float [10];
int nums[] = new int[500];
float Lev2barrierY[] = new float [6];
float Lev2barrierX[] = new float [6];
float random;
float Lev2velX[] = new float [6];
float Lev2velY[] = new float [6];
void setup ()
{
  //backgrounds for my game (different levels)
  Brick = loadImage("brick.png");
  Brick.resize(width, height);

  Castle = loadImage("Castle.png");
  Castle.resize(width, height);

  Level2 = loadImage("level2.png");
  Level2.resize(width, height);

  Heaven = loadImage("heaven.png");
  Heaven.resize(width, height);

  Hell = loadImage("Hell.png");
  Hell.resize(width, height);

  fullScreen();
  background(Brick);
  noStroke();

  //Music
  minim = new Minim(this); //Music 
  song = minim.loadFile("MinionSong.mp3");
  song2 = minim.loadFile("TaaDaa.mp3");
  song3 = minim.loadFile("DOH.mp3");
  crying = minim.loadFile("Crying.mp3");
  song.loop();

  for (int i = 0; i < nums.length; i++) //generate random numbers between 0, 70)
  {
    nums[i] = int(random(70));
  }

  //CooridinatesX for Barrier
  for (int i = 0; i<barrierX.length; i++) //x and y values for my falling objects
  {
    barrierX[i] = i * 200 + 100;
    barrierY[i] = 0;
  }

  for (int i = 0; i<Lev2barrierX.length; i++) //x values for my falling objects
  {
    Lev2barrierX[i] = int(random(width/4, width/1));
    Lev2barrierY[i] = int(random(height));
    Lev2velX[i] = random(-10, 10);
    Lev2velY[i] = random(-10, 10);
  }


  //Loading Images
  HeartEmoji = loadImage("HeartEmoji.png");
  BobFront = loadImage("Bob.png");
  Bob = loadImage ("Bobplayer.png");
  Pizza = loadImage("imgres.png");
  Broc = loadImage("broc.png");
  Brick = loadImage("brick.png");
  Door = loadImage("door.png");
  Defense = loadImage("objects.png");
  SadMinion = loadImage("SadMinion.png");
  Holy = loadImage("holy.png");


  bobX = width/28.8;
  DoorY = height/1.125;
  DoorX = width/1.02;
  bobY = height/1.125;

  imageMode(CENTER);
  image(BobFront, width/1.3, height/1.75, width/2.16, height/1.51);

  imageMode(CENTER);
  image(Pizza, width/5.7, height/1.9, width/2.88, height/1.8);

  fill (0, 0, 100);
  textSize(100);
  text("Bob's Mission", width/4.11, height/4.5);

  fill (0, 0, 0);
  textSize(30);
  text("Created by Aryan Kothari", width/1.371, height/1.04);

  fill(0, 255, 0);
  rect(width/2.32, height/2.25, width/8, height/18);

  fill(0, 255, 0);
  rect(width/2.32, height/1.875, width/8, height/18);

  fill(0, 0, 255);
  textSize(35);
  text("Play now!", width/2.267, height/2.04);

  fill(0, 0, 255);
  textSize(40);
  text("Quit", width/2.15, height/1.73);
}


void draw()
{
  if (Lives == 0) //go to game over screen
  {
    song.pause();
    delay(1000);
   // LastTime = millis();
   // if (millis() - LastTime > 1000)
    //{
      screen = 5;
    //}
  }

  if (screen == 5) //Game Over Screen
  {
    LosingScreen();
  }



  if (screen == 0 & mousePressed & mouseX >= width/2.32 & mouseX <= width/1.8 & 
    mouseY >= height/2.25 & mouseY <= height/2) //Play button/Go to game
  {
    screen = 1;
  }


  if (screen == 1) //Level 1 
  {
    background(Castle);
    Level1Barriers();
    Gameplay();
    CollisonDetection();

    if (CollisionDetected == true)
    {
      Lives = Lives - 1;
      CollisionDetected = false;
      Playing = false;
      bobX = width/28.8;
        for (int i = 0; i < barrierY.length; i++)
        {
          barrierY[i] = velY*-1;
          r = random(255);
          g = random(255);
          b = random(255);

          randomSize[i] = 20 + (i+1)*random(0, 10);
        }
        Playing = true;
      }

    if (bobX > width/1.05) //If bob reaches door 
    {
      screen = 2;
      Playing = true;
      bobX = width/28.8;
      bobY = height/1.15;
      DoorY = height/1.15;
    }
  }

  if (screen == 2) //Level 2 
  {
    Defense = loadImage("images.png"); //New falling object
    background(Level2);
    Level2Barriers();
    Gameplay();
    Lev2CollisonDetection();

    if (CollisionDetected == true)
    {
      Playing = false;
      Lives = Lives - 1;
      bobX = width/28.8;
      for (int i = 0; i<Lev2barrierX.length; i++) //x values for my falling objects
      {
        Lev2barrierX[i] = int(random(width/4, width/1));
        Lev2barrierY[i] = int(random(height));
      }
      CollisionDetected = false;
      Playing = true;
    }

    if (bobX > width/1.05) //if bob reaches pizza 
    {
      screen = 3;
      Playing = true;
      bobX = width/28.8;
      bobY = height/1.15;
    }
  }

  if (screen == 3) //Final Level, get to the pizza!
  {
    background(Heaven);
    image(Pizza, width/1.05, height/1.125, height/14.4, height/9);
    image(Bob, bobX, bobY, width/28.8, height/18);
    for (int i = 0; i<2; i++)
    {
      fill(0, 0, 0);
      textSize(int(random(5, 20)));
      text("SO CLOSE", int(random(width)), int(random(height)));
    } 
    if (bobX > width/1.05 - 50) 
    {
      screen = 4;
    }
  }

  if (screen == 4) //VICTORYYY!
  {
    VictoryScreen();
  }


  if (screen == 0 & mousePressed & mouseX >= width/2.32 & mouseX <= width/1.8 & 
    mouseY >= height/1.875 & mouseY <= height/1.73) //Exit Game 
  {
    exit();
  }
}



//Moving Bob
void keyPressed()
{
  if (keyPressed)
  {
    if (Playing)
    {
      if (keyCode == RIGHT)
      {
        bobX = bobX + 20;
      }
      if (keyCode == LEFT)
      {
        bobX = bobX - 20;
      }
    }
  }
}



//below are custom functions I will be using in my levels 

void Gameplay() //this contains all the other functions, and is the basis platform for my game
{
  fill(r, g, b);
  noStroke();
  scoreinfo();
  BarrierRestrictions();
  BasicPlatform();
  Playing = true;
}

void BarrierRestrictions() //Flying objects reset back to top
{
  for (int i = 0; i < barrierY.length; i++)
  {
    if (barrierY[i] > height)
    {
      barrierY[i] = velY*-1;
      r = random(255);
      g = random(255);
      b = random(255);

      randomSize[i] = 20 + (i+1)*random(0, 10);
    }
  }
}


void Level2Barriers() //makaking the defense for level 2 
{
  for (int i = 0; i<Lev2barrierX.length; i++)
  {
    fill(255, 255, 255);
    image(Defense, Lev2barrierX[i], Lev2barrierY[i], width/28.8, height/18);
    Lev2barrierX[i] = Lev2barrierX[i] + Lev2velX[i];
    Lev2barrierY[i] = Lev2barrierY[i] + Lev2velY[i];

    if (Lev2barrierY[i] > height)
    {
      Lev2velY[i] = random(-10, -2);
    }

    if (Lev2barrierY[i] < 0)
    {
      Lev2velY[i] = random(2, 10);
    }

    if (Lev2barrierX[i] < 0)
    {
      Lev2velX[i] = random(2, 10);
    }

    if (Lev2barrierX[i] > width)
    {
      Lev2velX[i] = random(-10, 2);
    }
  }
}

void Level1Barriers() //Making Barriers/The shards that fall from sky
{
  fill(r, g, b);

  for (int i=0; i < barrierX.length; i++)
  {
    fill(r, g, b);
    image(Defense, barrierX[i], barrierY[i], randomSize[i], randomSize[i]);
    barrierY[i] = barrierY[i] + random(0, 25);
  }
}

//Collision Detection Boolean
boolean CollisonDetection() //Boolean for detecting collision of Bob
{
  for (int i = 0; i<barrierX.length; i++)
  {
    if (bobX < barrierX[i] + randomSize[i] &&
      bobX + 50 - 20 > barrierX[i] &&
      bobY < barrierY[i] + randomSize[i] &&
      50 + bobY - 20 > barrierY[i])
    {
      CollisionDetected = true;
    }
  }
  return CollisionDetected;
}

boolean Lev2CollisonDetection() //Boolean for detecting collision of Bob
{
  for (int i = 0; i<barrierX.length; i++)
  {
    if (bobX < Lev2barrierX[i] + 50 &&
      bobX + 50 - 20 > Lev2barrierX[i] &&
      bobY < Lev2barrierY[i] + 50 &&
      50 + bobY - 20 > Lev2barrierY[i])
    {
      CollisionDetected = true;
    }
  }
  return CollisionDetected;
}

void scoreinfo() //Levels and Lives 
{

  fill(r, g, b);
  textSize(40);
  text("Level:", width/2.61, height/18);
  text(screen, width/2.15, height/18);
  text("Lives:", width/2.05, height/18);
  text(Lives, width/1.76, height/18);
}

void LosingScreen() //Losing screen forloop
{
  song.pause();
  background(Hell);
  fill(0, 0, 0);
  textSize(80);
  text("YOU HAVE FAILED!", width/5, height/2);
  crying.play();
  for (int i = 0; i < 100; i++)
  {
    imageMode(CENTER);
    image(SadMinion, random(width), random(height), nums[i], nums[i]);
    fill(random(255));
  }
}

void VictoryScreen() //Victory screen for loop 
{

  background(Heaven);
  fill(0, 0, 0);
  textSize(80);
  text("MISSION ACCOMPLISHED!", width/5, height/2);
  song.pause();
  song2.play();
  for (int i = 0; i < 100; i++)
  {
    imageMode(CENTER);
    image(BobFront, random(width), random(height), nums[i], nums[i]);
    fill(random(255));
  }
}

void BasicPlatform() //Door and bob
{
  imageMode(CENTER);
  image(Door, DoorX, DoorY, width/28.8, height/18);
  image(Bob, bobX, bobY, width/28.8, height/18);
}