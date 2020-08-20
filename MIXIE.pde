import processing.video.*;

// Variable for capture device
Capture video;
//
PImage img1;
PImage img2;
PImage img3;
// ZAMAN ...............
PImage img4;
PImage img5;
// ZAMAN video
Movie myMovie;

// A variable for the color we are searching for.
color trackerColor;  

color trackColor1; 
color trackColor2; 
color trackColor3; 
//
int threshold = 10;
int trkrThreshold = 50;

void setup() {
  size(1400, 780);
  video = new Capture(this, 320, 240);
  video.start();
  
  // Start off tracking for red
  trackerColor =  color(120, 70, 70);
  
  trackColor1 = color(255, 0, 0);
  trackColor2 = color(0, 255, 0);
  trackColor3 = color(0, 0, 255);
  //
  img1 = loadImage("abcd.jpg"); 
  img2 = loadImage("1234.jpg"); 
  img3 = loadImage("rhyme.jpg"); 
  // ZAMAN...............
  img4 = loadImage("kids.jpg");
  img5 = loadImage("phi.jpg");
  // ZAMAN movie.........
  myMovie = new Movie(this, "twinkle.mp4");
  //myMovie.play();
}

void captureEvent(Capture video) {
  // Read image from the camera
  video.read();
}

void draw() {
  background(255);
  video.loadPixels();
  if(cmod)
  {
    image(video, 0, 0);
  }
  else
  {
    background(255);
  }
  
  //
  int totLoc = 0;

  // Before we begin searching, the "world record" for closest color is set to a high number that is easy for the first pixel to beat.
  float worldRecord1 = 500; 
  float worldRecord2 = 500;
  float worldRecord3 = 500;

  // XY coordinate of closest color
  //int closestX1 = 0;
  //int closestY1 = 0;
  ////
  //int closestX2 = 0;
  //int closestY2 = 0;
  ////
  //int closestX3 = 0;
  //int closestY3 = 0;
  
  float trkrWrldRcrd = 500;
  
  int trackerCount = 0;
  
  int trackerPosX = 0;
  int trackerPosY = 0;
  int prevTrackerPosX = 0;
  int prevTrackerPosY = 0;
  
  // Begin loop to walk through every pixel
  for (int x = 0; x < video.width; x ++ ) {
    for (int y = 0; y < video.height; y ++ ) {
      int loc = x + y*video.width;
      // What is current color
      color currentColor = video.pixels[loc];
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);
      float r2 = red(trackerColor);
      float g2 = green(trackerColor);
      float b2 = blue(trackerColor);

      // Using euclidean distance to compare colors
      float d = dist(r1, g1, b1, r2, g2, b2); // We are using the dist( ) function to compare the current color with the color we are tracking.

      // If current color is more similar to tracked color than
      // closest color, save current location and current difference
      
      if (d < threshold) {
        totLoc += loc;
        
        trackerCount ++;
        //closestX1 = x;
        //closestY1 = y;
      }
    }
  }
  
  if(trackerCount > trkrThreshold)
  {
    
  }
  
  // Begin loop to walk through every pixel
  for (int x = 0; x < video.width; x ++ ) {
    for (int y = 0; y < video.height; y ++ ) {
      int loc = x + y*video.width;
      // What is current color
      color currentColor = video.pixels[loc];
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);
      float r2 = red(trackColor1);
      float g2 = green(trackColor1);
      float b2 = blue(trackColor1);

      // Using euclidean distance to compare colors
      float d = dist(r1, g1, b1, r2, g2, b2); // We are using the dist( ) function to compare the current color with the color we are tracking.

      // If current color is more similar to tracked color than
      // closest color, save current location and current difference
      if (d < worldRecord1) {
        worldRecord1 = d;
        //closestX1 = x;
        //closestY1 = y;
      }
    }
  } 

  // Begin loop to walk through every pixel
  for (int x = 0; x < video.width; x ++ ) {
    for (int y = 0; y < video.height; y ++ ) {
      int loc = x + y*video.width;
      // What is current color
      color currentColor = video.pixels[loc];
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);
      float r2 = red(trackColor2);
      float g2 = green(trackColor2);
      float b2 = blue(trackColor2);

      // Using euclidean distance to compare colors
      float d = dist(r1, g1, b1, r2, g2, b2); // We are using the dist( ) function to compare the current color with the color we are tracking.

      // If current color is more similar to tracked color than
      // closest color, save current location and current difference
      if (d < worldRecord2) {
        worldRecord2 = d;
        //closestX2 = x;
        //closestY2 = y;
      }
    }
  }
  // Begin loop to walk through every pixel
  for (int x = 0; x < video.width; x ++ ) {
    for (int y = 0; y < video.height; y ++ ) {
      int loc = x + y*video.width;
      // What is current color
      color currentColor = video.pixels[loc];
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);
      float r2 = red(trackColor3);
      float g2 = green(trackColor3);
      float b2 = blue(trackColor3);

      // Using euclidean distance to compare colors
      float d = dist(r1, g1, b1, r2, g2, b2); // We are using the dist( ) function to compare the current color with the color we are tracking.

      // If current color is more similar to tracked color than
      // closest color, save current location and current difference
      if (d < worldRecord3) {
        worldRecord3 = d;
        //closestX3 = x;
        //closestY3 = y;
      }
    }
  }

  // We only consider the color found if its color distance is less than 10. 
  // This threshold of 10 is arbitrary and you can adjust this number depending on how accurate you require the tracking to be.
  if ((worldRecord1 < threshold) || (worldRecord2 < threshold) || (worldRecord3 < threshold)) { 
    
    if((worldRecord1 < worldRecord2) && (worldRecord1 < worldRecord3))
    {
      // Draw a circle at the tracked pixel
      //fill(trackColor1);
      //strokeWeight(4.0);
      //stroke(0);
      //ellipse(closestX1, closestY1, 16, 16);
      int posx = (int) map(prevTrackerPosX, 0, 320, 0, 1000);
      int posy = (int) map(prevTrackerPosY, 0, 320, 0, 1000);
      
      image(img1, posx, posy, width/3, height/3 );
      // ZAMAN was here.
      image(img2, posx+500, posy, width/3, height/3); 
      image(img3, posx, posy+350, width/4, height/4);
    }
    if((worldRecord2 < worldRecord1) && (worldRecord2 < worldRecord3))
    {
      // Draw a circle at the tracked pixel
      //fill(trackColor2);
      //strokeWeight(4.0);
      //stroke(0);
      //ellipse(closestX2, closestY2, 16, 16);
      int posx = (int) map(prevTrackerPosX, 0, 320, 0, 1000);
      int posy = (int) map(prevTrackerPosY, 0, 320, 0, 1000);
      
      //image(img2, posx, posy, width/3, height/3);
      // ZAMAN ...............
      //myMovie.play();
      myMovie.loop();
      image(myMovie, posx, posy);
    }
    if((worldRecord3 < worldRecord1) && (worldRecord3 < worldRecord2))
    {
      // Draw a circle at the tracked pixel
      //fill(trackColor3);
      //strokeWeight(4.0);
      //stroke(0);
      //ellipse(closestX3, closestY3, 16, 16);
      int posx = (int) map(prevTrackerPosX, 0, 320, 0, 1000);
      int posy = (int) map(prevTrackerPosY, 0, 320, 0, 1000);
      
      image(img4, posx, posy);
      //ZAMAN...............................
      image(img5, posx+500, posy);
      //stroke(100, 0, 0);
      //noFill();
      //strokeWeight(10);
      //ellipse(width/4 + 200, height/4+200, 500, 500);
      //fill(255, 0,0);
      //ellipse(width/4 + 200, height/4 + 200, 50, 50);
    }
  }
}

int counter = 0;
void mousePressed() {
  // Save color where the mouse is clicked in trackColor variable
  int loc = mouseX + mouseY*video.width;
  if(counter == 3)
  {
    counter = 0;
  }
  //else if(counter == 3)
  //{
  //  trackerColor = video.pixels[loc];
  //  counter++;
  //}
  else if(counter == 2)
  {
    trackColor3 = video.pixels[loc];
    counter++;
  }
  else if(counter == 1)
  {
    trackColor2 = video.pixels[loc];
    counter++;
  }
  else if(counter == 0)
  {
    trackColor1 = video.pixels[loc];
    counter++;
  }
}

boolean cmod = true;
void keyPressed() {
  switch(key){
    case 'c':
      cmod = !cmod;
      break;
  }
}
//ZAMAN..........
void movieEvent(Movie m) {
  m.read();
}