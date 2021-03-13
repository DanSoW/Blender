import processing.opengl.*;
import java.awt.event.KeyEvent;

boolean active = false, down = false, up = false, right = false, left = false;

//coords for mouse
float xmag, ymag = 0; 
float newXmag, newYmag = 0;

//coords of helicopter
float coord_x = 0, coord_y = 0, coord_z;
float speedMove = 2;
float speedRotatePropeller = 0;

//speed of rotate
float speedMax = 4;
float speedMin = 0;
float speed = 0;

//rotate of helicopter
float rotateHelicopter = 0;

//plane up
float planeMax = 500;
float planeMin = -500;
float plane;
boolean planeUp = false, planeDown = false;

//texture for cube
PImage imgUp, imgDown, imgBack, imgFront, imgRight, imgLeft;

//part of helicopter
PShape body;
PShape propeller;

public void keyPressed(KeyEvent e){
  if(e.getKeyCode() == KeyEvent.VK_ENTER){
    active = !active;
  }
  else if(e.getKeyCode() == KeyEvent.VK_DOWN){
    down = true;
  }else if(e.getKeyCode() == KeyEvent.VK_UP){
    up = true;
  }else if(e.getKeyCode() == KeyEvent.VK_RIGHT){
    right = true;
  }else if(e.getKeyCode() == KeyEvent.VK_LEFT){
    left = true;
  }
  
  if(e.getKeyCode() == 50){
    planeUp = true;
  }else if(e.getKeyCode() == 49){
    planeDown = true;
  }
}

public void keyReleased(KeyEvent e){
  if(e.getKeyCode() == KeyEvent.VK_DOWN){
    down = false;
  }else if(e.getKeyCode() == KeyEvent.VK_UP){
    up = false;
  }else if(e.getKeyCode() == KeyEvent.VK_RIGHT){
    right = false;
  }else if(e.getKeyCode() == KeyEvent.VK_LEFT){
    left = false;
  }
  
  if(e.getKeyCode() == 50){
    planeUp = false;
  }else if(e.getKeyCode() == 49){
    planeDown = false;
  }
}

void setup () {
size (640,480,OPENGL);
colorMode(RGB,1);
noStroke();

imgBack = loadImage("back.png");
imgFront = loadImage("front.png");
imgUp = loadImage("up.png");
imgDown = loadImage("down.png");
imgRight = loadImage("rigth.png");
imgLeft = loadImage("left.png");
textureMode(NORMAL);
body = loadShape("body_helicopter.obj");
propeller = loadShape("propeller_helicopter.obj");

speed = 0.01;
}

void draw () {
  /*directionalLight(255, 255, 255, 0, 0, 0);
  directionalLight(255, 255, 255, 100, 100, 100);
  directionalLight(255, 255, 255, 150, 150, 150);
  directionalLight(255, 255, 255, -100, 50, 50);
  directionalLight(255, 255, 255, -200, -200, 200);
  directionalLight(255, 255, 255, 5, 5, 5);
  directionalLight(255, 255, 255, 4, 20, 78);
  directionalLight(255, 255, 255, -1, 55, 125);*/

background(0,0,0);
newXmag = mouseX/float(width) * TWO_PI;
newYmag = mouseY/float(height) * TWO_PI;
float diff = xmag-newXmag;
if (abs(diff) > 0.01) { xmag -= diff/4.0; }
diff = ymag-newYmag;
if (abs(diff) > 0.01) { ymag -= diff/4.0; }
translate(width/2, height/2);
rotateX(-ymag);
rotateY(-xmag);



if(active == true){
  speedRotatePropeller += speed;
  if(speed >= speedMax){
    speed = speedMax;
  }else{
    speed += 0.005;
  }
}else if((active == false) && (speedRotatePropeller > 0)){
  speedRotatePropeller -= speed;
  if(speed <= speedMin){
    speed = speedMin;
  }else{
    speed -= 0.005;
  }
}

if(speedRotatePropeller < 0){
  speedRotatePropeller = 0;
}

pushMatrix();
/*
For management right/left used cube of rotating and map of rotating
*/

if(right == true){
  rotateHelicopter += 0.01;
}else if(left == true){
  rotateHelicopter -= 0.01;
}

rotateY(rotateHelicopter);

rotateX(4.70);
translate(-100,0);
scale(2000);

//back
beginShape(QUADS);
texture(imgDown);
textureWrap(CLAMP);
vertex(1,-1,-1,  0, 0);
vertex(-1,-1,-1, 1, 0);
vertex(-1, 1,-1, 1, 1);
vertex( 1, 1,-1, 0, 1);
endShape();

//left
beginShape(QUADS);
texture(imgLeft);
vertex(-1,-1,-1, 0, 1);
vertex(-1,1,-1, 1, 1);
vertex(-1,1,1, 0, 0);
vertex(-1,-1,1, 1, 0);
endShape();

//back
beginShape(QUADS);
texture(imgBack);
vertex(-1,-1,-1, 0, 1);
vertex(-1,-1,1, 0, 0);
vertex(1,-1,1, 1, 0);
vertex(1,-1,-1, 1, 1);
endShape();

//right
beginShape(QUADS);
texture(imgRight);
vertex(1,1,1, 1, 0);
vertex(1,1,-1, 1, 1);
vertex(1,-1,-1, 0, 1);
vertex(1, -1, 1, 0, 0);
endShape();

//front
beginShape(QUADS);
texture(imgFront);
vertex(1,1,1, 1, 0);
vertex(-1,1,1, 0, 0);
vertex(-1,1,-1, 1, 1);
vertex(1,1,-1, 0, 1);
endShape();

//up
beginShape(QUADS);
texture(imgUp);
vertex(1,1,1, 0, 0);
vertex(1,-1,1, 1, 1);
vertex(-1,-1,1, 1, 0);
vertex(-1,1,1, 0, 1);

endShape();
popMatrix();

pushMatrix();

if(planeUp == true){
  if(plane < planeMax){
    plane += 1;
  }
}else if(planeDown == true){
  if(plane > planeMin){
    plane -= 1;
  }
}

pushMatrix();
if(up == true){
  coord_z -= speedMove;
}else if(down == true){
  coord_z += speedMove;
}

translate(0, plane, coord_z);
scale(50, 50, 50);
beginShape();
shape(body,0,0); //add body of helicopter on map
endShape();

popMatrix();

pushMatrix();
if(up == true){
  coord_z -= speedMove;
}else if(down == true){
  coord_z += speedMove;
}

translate(0, -47 + plane, coord_z);

if(speedRotatePropeller != 0){
  rotateY(speedRotatePropeller);
}

scale(50, 50,50);
beginShape();
shape(propeller,0,0); //add propeller of helicopter on map
endShape();
popMatrix();

popMatrix();

}
