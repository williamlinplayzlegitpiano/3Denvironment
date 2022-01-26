import java.awt.Robot;
Robot PayMePlz;

color black = #000000;
color white = #FFFFFF;
color red = #ED1C24;
color orange = #FF7F27;

int gridSize;
PImage map;

PImage diamond, furnacetop, furnaceside, furnaceface, observerface, observerbottom, observerside, observertop, observerback, wood;

boolean w, a, s, d;
float eyeX, eyeY, eyeZ, focusX, focusY, focusZ, tiltX, tiltY, tiltZ;
float leftrightHeadangle, updownHeadangle;
boolean skipFrame;

void setup() {
  size(displayWidth, displayHeight, P3D);

  diamond  = loadImage("diamond.png");
  furnacetop = loadImage("furnacetop.png");
  furnaceside = loadImage("furnaceside.png");
  furnaceface = loadImage("furnaceface.png");
  observerface = loadImage("observerface.png");
  observerbottom = loadImage("observerbottom.png");
  observerside = loadImage("observerside.png");
  observertop = loadImage("observertop.png");
  observerback = loadImage("observerback.png");
  wood = loadImage("wood.png");
  textureMode(NORMAL);

  w = a = s = d = false;

  eyeX = width/2;
  eyeY = 9*height/10;
  eyeZ = 0;
  focusX = width/2;
  focusY = height/2;
  focusZ = 10;
  tiltX = 0;
  tiltY = 1;
  tiltZ = 0;

  leftrightHeadangle = radians (270);

  noCursor();
  try {
    PayMePlz = new Robot();
  }
  catch(Exception e) {
    e.printStackTrace();
  }
  skipFrame = false;

  map = loadImage("map.png");
  gridSize = 100;
}

void draw() {
  background(0);
  pointLight(255, 255, 255, eyeX, eyeY, eyeZ);
  camera(eyeX, eyeY, eyeZ, focusX, focusY, focusZ, tiltX, tiltY, tiltZ);
  drawFloor(-2000, 2000, height, gridSize);
  drawFloor(-2000, 2000, height - gridSize*4, gridSize);
  drawFocus();
  controlCamera();
  drawMap();
}

void drawFloor(int sx, int ex, int h, int g) {
  stroke(255);
  strokeWeight(1);
  int x = sx;
  int z = sx;
  while (z < ex) {
    textureCube(x, h, z, wood, g);
    x = x + g;
    if (x >= ex) {
      x = sx;
      z = z + g;
    }
  }
}

void drawFocus() {
  pushMatrix();
  translate(focusX, focusY, focusZ);
  sphere(5);
  popMatrix();
}


void controlCamera() {
  if (w) {
    eyeZ = eyeZ + sin (leftrightHeadangle)*10;
    eyeX = eyeX + cos (leftrightHeadangle)*10;
  }
  if (s) {
    eyeZ = eyeZ - sin (leftrightHeadangle)*10;
    eyeX = eyeX - cos (leftrightHeadangle)*10;
  }
  if (a) {
    eyeZ = eyeZ - sin (leftrightHeadangle + PI/2)*10;
    eyeX = eyeX - cos (leftrightHeadangle + PI/2)*10;
  }
  if (d) {
    eyeZ = eyeZ - sin (leftrightHeadangle - PI/2)*10;
    eyeX = eyeX - cos (leftrightHeadangle - PI/2)*10;
  }
  if (skipFrame == false) {
    leftrightHeadangle = leftrightHeadangle + (mouseX - pmouseX)*0.01;
    updownHeadangle = updownHeadangle + (mouseY - pmouseY)*0.01;
  }

  if (updownHeadangle > PI/2.5) updownHeadangle = PI/2.5;
  if (updownHeadangle < -PI/2.5) updownHeadangle = -PI/2.5;

  focusX = eyeX + cos(leftrightHeadangle) * 300;
  focusZ = eyeZ + sin(leftrightHeadangle) * 300;
  focusY = eyeY + tan(updownHeadangle) * 300;

  if (mouseX > width - 2) {
    PayMePlz.mouseMove(3, mouseY);
    skipFrame = true;
  } else if (mouseX < 2) {
    PayMePlz.mouseMove(width-3, mouseY);
    skipFrame = true;
  } else {
    skipFrame = false;
  }
}

void drawMap() {
  for (int x = 0; x < map.width; x++) {
    for (int y = 0; y < map.height; y++) {
      color c = map.get(x, y);
      if (c != white) {
        if (c == black) {
          textureCube(x*gridSize-2000, height-gridSize, y*gridSize-2000, diamond, gridSize);
          textureCube(x*gridSize-2000, height-gridSize*2, y*gridSize-2000, diamond, gridSize);
          textureCube(x*gridSize-2000, height-gridSize*3, y*gridSize-2000, diamond, gridSize);
        }
        if (c == red) {
          textureCube(x*gridSize-2000, height-gridSize, y*gridSize-2000, furnaceside, furnacetop, furnaceface, gridSize);
          textureCube(x*gridSize-2000, height-gridSize*2, y*gridSize-2000, furnaceside, furnacetop, furnaceface, gridSize);
          textureCube(x*gridSize-2000, height-gridSize*3, y*gridSize-2000, furnaceside, furnacetop, furnaceface, gridSize);
        }
        if (c == orange) {
          textureCube(x*gridSize-2000, height-gridSize, y*gridSize-2000, observerside, observertop, observerbottom, observerface, observerback, gridSize);
          textureCube(x*gridSize-2000, height-gridSize*2, y*gridSize-2000, observerside, observertop, observerbottom, observerface, observerback, gridSize);
          textureCube(x*gridSize-2000, height-gridSize*3, y*gridSize-2000, observerside, observertop, observerbottom, observerface, observerback, gridSize);
        }
      }
    }
  }
}

void keyPressed () {

  if (key == 'w' || key == 'W')  w = true;
  if (key == 'a' || key == 'A')  a = true;
  if (key == 's' || key == 'S')  s = true;
  if (key == 'd' || key == 'D')  d = true;
}

void keyReleased () {
  if (key == 'w' || key == 'W') w = false;
  if (key == 'a' || key == 'A') a = false;
  if (key == 's' || key == 'S') s = false;
  if (key == 'd' || key == 'D') d = false;
}
