class NodeGroup {
  ArrayList<Node> nodes = new ArrayList<Node>();
  ArrayList<Spring> springs = new ArrayList<Spring>();
  color highlight = color(180, 100, 100);
  color notHighlight = color(0, 0, 0);

  int mainSize = 10;
  float leftOffset;
  float rightOffset;
  int nodeRad = 20;
  String mainLabel;
  Table table;
  float startX, startY;

  NodeGroup(float x, float y, String[] label, Table t) {
    startX = x;
    startY = y;
    mainLabel = label[0];
    table = t;
    Node start = new Node(x + random(-200, 200), y + random(-200, 200));
    start.setID(mainLabel);
    start.setBoundary(x - 300, y - 300, x + 300, y + 300);
    nodes.add(start);

    for (int i = 0; i < table.getRowCount(); i++) {
      TableRow row = table.getRow(i); //get the row
      String question = row.getString("Question"); // find the question in that row
      print(question + "\n");
      String[] words = splitTokens(question, "\n .,?!"); // split the question into each words
      printArray(words);
      for (int j = 0; j < words.length; j++){
        if (words[j].equals(mainLabel) || words[j].equals(label[1])){ // check if each word matches the label
          addNode(question);
          break;
        }
      }  
    }
  }

  void update(float mX, float mY) {
    
    Node[] tempNodes = new Node[nodes.size()];
    for (int i = 0; i < nodes.size(); i++) {
      tempNodes[i] = nodes.get(i);
    }
    // update nodes
    for (int i = 0; i < nodes.size(); i++) {
      Node temp = nodes.get(i);
      temp.attract(tempNodes);
      temp.update();
      float dist = dist(mX, mY, temp.x, temp.y) - 10;
      if (dist < nodeRad && mousePressed){
        temp.x = mX;
        temp.y = mY;
      }
      int randNum = round(random(27));
      if (randNum == 1){
        temp.x += random(-0.8, 0.8);
        temp.y += random(-0.8, 0.8);
      }
    }
    // update springs
    for (int i = 0; i < springs.size(); i++) {
      Spring temp = springs.get(i);
      
      temp.update();
    }
  }

  void display(float mX, float mY) {
    // show the springs
    fill(255);
    strokeWeight(2);
    stroke(255);
    for (int i = 0; i < springs.size(); i++) {
      Spring temp = springs.get(i);
      Node from = temp.getFromNode();
      Node to = temp.getToNode();

      line(from.x, from.y, to.x, to.y);
    }
    // show main node
    textSize(40);
    Node main = nodes.get(0);
    //noFill();
    //strokeWeight(2);
    //rect(main.minX, main.minY, 600, 600);
    noStroke();
    fill(0, 180);
    rect(main.x - (textWidth(main.id) / 2) - 2, main.y - 22, textWidth(main.id) + 2, 42);
    stroke(0);
    fill(255);
    text(mainLabel, main.x, main.y);
    
    // display each node and check if inside bounds
    textSize(20);
    for (int i = 1; i < nodes.size(); i++) {
      Node temp = nodes.get(i);
      
      float dist = dist(mX, mY, temp.x, temp.y);
      dist -= 20;
      
      float leftPos = temp.x - (textWidth(temp.id)/2);
      if (leftPos < 0){
        float value = -leftPos;
        leftOffset = value + 8;
      }else{
        leftOffset = 0;
      }
      
      float rightPos = temp.x + (textWidth(temp.id)/2);
      if (rightPos > width){
        float value = rightPos - width;
        rightOffset = -value - 8;
      }else{
        rightOffset = 0;
      }
      if (dist < nodeRad) {
        fill(0, 200);
        noStroke();
        rect((temp.x - (textWidth(temp.id) / 2) - 2) + leftOffset + rightOffset, temp.y - 12, textWidth(temp.id) + 2, 22);
        stroke(0);
        fill(255);
        text(temp.id, temp.x + leftOffset + rightOffset, temp.y);
      } else {
        ellipse(temp.x, temp.y, nodeRad, nodeRad);
      }
    }
  }

  void moveAll(float xDir, float yDir){
    for (int i = 0; i < nodes.size(); i++){
      Node temp = nodes.get(i);
      temp.x += xDir;
      temp.y += yDir;
      temp.minX += xDir;
      temp.maxX += xDir;
      temp.minY += yDir;
      temp.maxY += yDir;
    }
  }
  
  void addNode(String s) {
    Node fromNode = nodes.get(0);
    Node newNode = new Node(random(fromNode.x - 50, fromNode.x + 50), random(fromNode.y - 50, fromNode.x + 50));
    newNode.setDamping(0.1);
    newNode.setID(s);
    newNode.setBoundary(startX - 300, startY - 300, startX + 300, startY + 300);

    Spring newSpring = new Spring(fromNode, newNode);
    newSpring.setLength(random(130, 270));
    newSpring.setStiffness(0.05);
    newSpring.setDamping(0.1);

    nodes.add(newNode);
    springs.add(newSpring);
  }
}
