/*
simple projector-camera augmented reality system

author: nazmus saquib
social computing group
mit media lab
massachusetts institute of technology

open-source, feel free to share, but do acknowledge the author :)

*/

import processing.video.*;

// variable for capture device
Capture video;

// variables for the color we are searching for.
color wallColor; 
color skinColor;

// webcam video dimension
int videow = 320;
int videoh = 240;

// bounding box of active area
boolean cmode = true;
int[] bb = new int[4];
boolean drawbb = false;
boolean calibrated = false;

// difference frame
PImage prevFrame;
// how different must a pixel be to be a "motion" pixel
float threshold = 50;

// "on" window variables
int t_winwidth = 40; 
int tcount = 1;
boolean ison = false;

// tracked average x and y coordinates
int avgx = 0;
int avgy = 0;

// simulation
Spring2D s1, s2;

float gravity = -9.0;
float mass = 2.0;


void setup() {
  // manually adjust this to fit monitor resolution
  size(1340,700,P3D);

  video = new Capture(this,videow,videoh,30);
  // tracking for skin color
  skinColor = color(93,71,63);
  
  prevFrame = createImage(video.width,video.height,RGB);
  
  video.start();
  
  // uncomment the section belowto check available cams and frame rates
  // useful to find out which webcam you are going to use
  /*
  String[] cameras = Capture.list();
  
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }
  }
  */
  
  // start spring system
  // Inputs: x, y, mass, gravity
  s1 = new Spring2D(0.0, width/2, mass, gravity);
  s2 = new Spring2D(0.0, width/2, mass, gravity);
}

void draw() {
  
  // reset avrage (x,y) calculations
  int totx = 0;
  int toty = 0;
  int lcount = 0;
  //avgx=0;avgy=0;
  
  // Capture and display the video
  if (video.available()) {
    // Save previous frame for motion detection!!
    prevFrame.copy(video,0,0,video.width,video.height,0,0,video.width,video.height); // Before we read the new frame, we always save the previous frame for comparison!
    prevFrame.updatePixels();
    video.read();
  }
  
  loadPixels();
  video.loadPixels();
  prevFrame.loadPixels();
  
  background(255);
  
  // if asked to show webcam video, display it
  if(cmode == true)
  {
    image(video,0,0);
  }

  // before we begin searching for color,
  // the "world record" for closest color is
  // set to a high number that is easy for the first pixel to beat.
  float worldRecord = 500; 

  // XY coordinate of closest color
  int closestX = 0;
  int closestY = 0;
  
  // if we have already found a bounding box, then
  if (calibrated == true)
  {
  // Begin loop to walk through every pixel
  for (int x = bb[0]+t_winwidth; x < bb[2]; x ++ ) {
    for (int y = bb[1]; y < bb[3]; y ++ ) {
      
      int loc = x + y*video.width;
      
      // color tracking
      // What is current color
      color currentColor = video.pixels[loc];
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);
      float r2 = red(skinColor);
      float g2 = green(skinColor);
      float b2 = blue(skinColor);

      // Using euclidean distance to compare colors
      float d = dist(r1,g1,b1,r2,g2,b2); // We are using the dist( ) function to compare the current color with the color we are tracking.

      // If current color is more similar to tracked color than
      // closest color, save current location and current difference
      if (d < worldRecord) {
        worldRecord = d;
        closestX = x;
        closestY = y;
      }
      
      // motion tracking
      color current = video.pixels[loc];      // what is the current color
      color previous = prevFrame.pixels[loc]; // what is the previous color
      
      // Step 4, compare colors (previous vs. current)
      r1 = red(current); g1 = green(current); b1 = blue(current);
      r2 = red(previous); g2 = green(previous); b2 = blue(previous);
      float diff = dist(r1,g1,b1,r2,g2,b2);
      
      // scale to window size
      int sx = int(map(x,bb[0],bb[2],0,width));
      int sy = int(map(y,bb[1],bb[3],0,height));
      int loc2 = sx + sy*width;
      
      // Step 5, how different are the colors?
      // If the color at that pixel has changed, then there is motion at that pixel.
      if (diff > threshold) { 
        // If motion, display black
        totx += sx; toty += sy; lcount += 1;
        pixels[loc2] = color(0);
      } else {
        // If not, display white
        pixels[loc2] = color(255);
      }
    }
  }
  // if you'd like to see motion pixels, uncomment updatePixels()
  //updatePixels();
  
  // if there's at least one coordinate (or more), we can
  // calculate the average, otherwise division by zero would occur
  if(lcount>0)
  {
    avgx = int(totx/lcount);
    //avgx = int(map(avgx,0,videow,0,width));
    avgy = int(toty/lcount);
    //avgy = int(map(avgy,0,videoh,0,height));
  }
  }
  
  if(calibrated == true)
  {
    // check for skin color in the "on" area (lower left corner)
    ison = checkOn(skinColor);
  }
  
  if(ison == true)
  {
    text("ON",width-20,20);
  }
  else if (ison == false)
  {
    text("OFF", width-20, 20);
  }

  // We only consider the color found if its color distance is less than 10. 
  // This threshold of 10 is arbitrary and you can adjust this number depending on how accurate you require the tracking to be.
  if (worldRecord < 10 && cmode) { 
    // Draw a circle at the tracked pixel
    /*
    fill(skinColor);
    strokeWeight(4.0);
    stroke(0);
    ellipse(closestX,closestY,16,16);
    */
  }
  
  // draw bbox if asked by user
  if (drawbb == true && cmode==true)
  {
    int minx = bb[0];
    int miny = bb[1];
    int maxx = bb[2];
    int maxy = bb[3];
    stroke(255,0,0);
    line(minx,miny,maxx,miny);
    line(minx,miny,minx,maxy);
    line(minx,maxy,maxx,maxy);
    line(maxx,maxy,maxx,miny);
    // on window
    line(minx,maxy-t_winwidth,minx+t_winwidth,maxy-t_winwidth);
    line(minx+t_winwidth,maxy-t_winwidth,minx+t_winwidth,maxy);
  }
   
  /*
  // 3d model movement
  */
  
  // simulation 
  // if on by skin color
  // if(ison)
  //if any movement detected
  if(true)//lcount>10)
  {
    s1.update(avgx, avgy);
    s1.display(avgx, avgy);
    s2.update(s1.x, s1.y);
    s2.display(s1.x, s1.y);
    ellipse(avgx,avgy,20,20);
  }
}

void mousePressed() {
  // save color where the mouse is clicked in wallColor variable
  int loc = mouseX + mouseY*video.width;
  wallColor = video.pixels[loc];
}

void keyPressed()
{
  // press 'b' to find bounding box of the effective projection area
  // press 'c' to toggle webcam video display
  switch(key)
  {
    case 'b':
      bb = findbbox(wallColor);
      calibrated = true;
      drawbb = !drawbb;
      break;
    case 'c':
      cmode = !cmode;
      break;
  }
}

int[] findbbox(color bcol)
{
  // calculate the bounding box of effective projection area
  int minx = 10000;
  int maxx = -10000;
  int miny = 10000;
  int maxy = -10000;
  
  for (int x = 0; x < video.width; x ++ ) {
    for (int y = 0; y < video.height; y ++ ) {
      int loc = x + y*video.width;
      // What is current color
      color currentColor = video.pixels[loc];
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);
      float r2 = red(bcol);
      float g2 = green(bcol);
      float b2 = blue(bcol);

      // Using euclidean distance to compare colors
      float d = dist(r1,g1,b1,r2,g2,b2); // We are using the dist( ) function to compare the current color with the color we are tracking.

      // If current color is more similar to tracked color than
      // closest color, save current location and current difference
      if (d < 10) {
        if (x < minx) minx = x;
        if (x > maxx) maxx = x;
        if (y < miny) miny = y;
        if (y > maxy) maxy = y;
      }
    }
  }
  int[] bbox = new int[4];
  bbox[0] = minx; bbox[1] = miny; bbox[2] = maxx; bbox[3] = maxy;
  return bbox;
}

boolean checkOn(color bcol)
{
  // check for skin color in the on/off area (lower left corner)
  int pcount = 0;
  // color tracking in lower-left corner
    for (int x = bb[0]; x < (bb[0]+t_winwidth); x ++ ) {
    for (int y = bb[3]-t_winwidth; y < bb[3]; y ++ ) {
      int loc = x + y*video.width;
      // What is current color
      color currentColor = video.pixels[loc];
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);
      float r2 = red(bcol);
      float g2 = green(bcol);
      float b2 = blue(bcol);

      // Using euclidean distance to compare colors
      float d = dist(r1,g1,b1,r2,g2,b2); // We are using the dist( ) function to compare the current color with the color we are tracking.

      // If current color is more similar to tracked color than
      // closest color, increase counter
      if (d < 10) {
        pcount++;
      }
    }
  }
  
  if(pcount > tcount)
  {
    return true;
  }
  else
  {
    return false;
  }
}