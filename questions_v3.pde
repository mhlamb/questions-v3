import generativedesign.*;
import java.util.Calendar;

float xPan = 0;
float yPan = 0;
boolean zoomIn = false;
boolean zoomOut = false;
boolean panLeft = false;
boolean panRight = false;
boolean panUp = false;
boolean panDown = false;
int zoomSpeed = 8;
float[] starX = new float[200];
float[] starY = new float[200];
Table table;
String question;
ArrayList<NodeGroup> nodeGroups = new ArrayList<NodeGroup>();

void setup() {
  //size (1250, 900);
  fullScreen();
  textAlign(CENTER, CENTER);
  for (int i = 0; i < starX.length; i++) {
    starX[i] = random(-600, width + 600);
    starY[i] = random(-600, height + 600);
  } 
  table = loadTable("data.csv", "header");
  
  String[][] words = {{"future", "futures"},{"moon", "moons"},{"cats", "cat"},{"real", "reality"},
  {"fire", "fires"},{"cars", "car"},{"space", "space"},{"colour", "colours"},{"sleep", "sleeping"},
  {"death", "die"},{"change", "changes"},{"water", "ocean"},{"brain", "brains"},{"sun", "suns"},
  {"aliens", "alien"},{"babies", "baby"},{"life", "living"},{"skin", "skins"},{"time", "times"},
  {"days", "day"},{"work", "working"},{"night", "midnight"},{"end", "ending"},{"smell", "smelly"},
  {"hair", "hair"}};
  
  int wordIndex = 0;
  for (int x = 300; x <= 2700; x += 600){
    for (int y = 300; y <= 2700; y += 600) {
      nodeGroups.add(new NodeGroup(y, x, words[wordIndex], table));
      wordIndex++;
    }
  }
}

void draw() {
  background(0);
  fill(255, 150);
  for (int i = 0; i < starX.length; i++) {
    ellipse(starX[i], starY[i], 10, 10);
    if (frameCount % 30 == 0) {
      starX[i] += random(-1, 1);
      starY[i] += random(-1, 1);
    }
  }
  NodeGroup[] tempNodeGroup = new NodeGroup[nodeGroups.size()];
  for (int i = 0; i < nodeGroups.size(); i++) {
    tempNodeGroup[i] = nodeGroups.get(i);
  }

  if (panLeft) {
    if (xPan < 50) {
      xPan += zoomSpeed;
      for (int i = 0; i < tempNodeGroup.length; i++) {
        tempNodeGroup[i].moveAll(zoomSpeed, 0);
      }
      for (int i = 0; i < starX.length; i++) {
        starX[i] += (zoomSpeed / 3);
      }
    }
  }
  if (panRight) {
    if (xPan > -1150) {
      xPan -= zoomSpeed;
      for (int i = 0; i < tempNodeGroup.length; i++) {
        tempNodeGroup[i].moveAll(-zoomSpeed, 0);
      }
      for (int i = 0; i < starX.length; i++) {
        starX[i] -= (zoomSpeed / 3);
      }
    }
  }
  if (panUp) {
    if (yPan < 50) {
      yPan += zoomSpeed;
      for (int i = 0; i < tempNodeGroup.length; i++) {
        tempNodeGroup[i].moveAll(0, zoomSpeed);
      }
      for (int i = 0; i < starX.length; i++) {
        starY[i] += (zoomSpeed / 3);
      }
    }
  }
  if (panDown) {
    if (yPan > -1950) {
      yPan -= zoomSpeed;
      for (int i = 0; i < tempNodeGroup.length; i++) {
        tempNodeGroup[i].moveAll(0, -zoomSpeed);
      }
      for (int i = 0; i < starX.length; i++) {
        starY[i] -= (zoomSpeed / 3);
      }
    }
  }

  for (int i = 0; i < tempNodeGroup.length; i++) {
    tempNodeGroup[i].update(mouseX, mouseY);
    tempNodeGroup[i].display(mouseX, mouseY);
  }

  //textSize(40);
  //text(xPan, width - 50, height - 50);
  //text(yPan, width - 180, height - 50);
}

void keyPressed() {

  if (key == 'w') {
    panUp = true;
    panDown = false;
  }
  if (key == 's') {
    panDown = true;
    panUp = false;
  }
  if (key == 'a') {
    panLeft = true;
    panRight = false;
  }
  if (key == 'd') {
    panRight = true;
    panLeft = false;
  }
}

void keyReleased() {
  if (keyCode == UP) {
    zoomIn = false;
  }
  if (keyCode == DOWN) {
    zoomOut = false;
  }
  if (key == 'w') {
    panUp = false;
  }
  if (key == 's') {
    panDown = false;
  }
  if (key == 'a') {
    panLeft = false;
  }
  if (key == 'd') {
    panRight = false;
  }
}
