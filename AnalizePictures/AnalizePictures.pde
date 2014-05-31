/*
zanekrat delam na dveh statičnih slikah, ne najdem primerne baze
*/
PFont font = createFont("Arial", 16,true); 
int Fwidth = Globals.FRAME_WIDTH;
int Fheight = Globals.FRAME_HEIGHT;
PImage img1;
PImage img2;

import controlP5.*;
ControlP5 cp5;
DropdownList d1, d2, d3, d4;
int cnt = 0;

Group compareViewElements;

void setup() {
  size(Fwidth, Fheight);
  img1 = loadImage("tm.jpg");
  img2 = loadImage("house.jpg");
  cp5 = new ControlP5(this);

  compareViewElements = cp5.addGroup("g1")
    .setPosition(0,0)
//    .setBackgroundHeight(100)
//    .setBackgroundColor(color(255,50))
    ;
  
  //dropdowns
  d1 = cp5.addDropdownList("list1_0")
    .setSize(Globals.boderLeftDD, Globals.boderLeftDD)
    .setPosition(Fwidth/4 - Globals.boderLeftDD, Globals.bodertopDD)
    .setGroup(compareViewElements)
    ;

  d2 = cp5.addDropdownList("list1_1")
    .setSize(Globals.boderLeftDD,Globals.boderLeftDD)
    .setPosition(Fwidth/4 + 3, Globals.bodertopDD)
    .setGroup(compareViewElements)
    ;
  d3 = cp5.addDropdownList("list2_0")
    .setSize(Globals.boderLeftDD,Globals.boderLeftDD)
    .setPosition( 3*(Fwidth/4) - Globals.boderLeftDD, Globals.bodertopDD)
    .setGroup(compareViewElements)    
    ;
  d4 = cp5.addDropdownList("list2_1")
    .setSize(Globals.boderLeftDD,Globals.boderLeftDD)
    .setPosition( 3*(Fwidth/4) + 3 , Globals.bodertopDD)
    .setGroup(compareViewElements)
    ;
  
  d1.captionLabel().set("Pick a painter");
  d2.captionLabel().set("Pick a painting");
  d3.captionLabel().set("Pick another painter");
  d4.captionLabel().set("Pick another painting");
  customize(d1); 
  customize(d2);
  customize(d3);
  customize(d4); 
  //buttons
  cp5.addButton("RGB1")
    .setValue(0)
    .setPosition(Fwidth/Globals.buttonHeight,Fheight/2 - Globals.buttonWidth)
    .setSize(Globals.buttonWidth,Globals.buttonHeight)
    .setGroup(compareViewElements)
    ;
  
  cp5.addButton("HSB1")
    .setValue(0)
    .setPosition(Fwidth/Globals.buttonHeight + Globals.buttonWidth + Globals.spaceBetweenButtons,Fheight/2 - Globals.buttonWidth)
    .setSize(Globals.buttonWidth,Globals.buttonHeight)
    .setGroup(compareViewElements)
    ;
     
  cp5.addButton("...")
    .setValue(0)
    .setPosition(Fwidth/Globals.buttonHeight + Globals.buttonWidth*2 + Globals.spaceBetweenButtons*2,Fheight/2 - Globals.buttonWidth)
    .setSize(Globals.buttonWidth,Globals.buttonHeight)
    .setGroup(compareViewElements)
    ;
  cp5.addButton("RGB2")
    .setValue(0)
    .setPosition((Fwidth/2) + Fwidth/Globals.buttonHeight,Fheight/2 - Globals.buttonWidth)
    .setSize(Globals.buttonWidth,Globals.buttonHeight)
    .setGroup(compareViewElements)
    ;

  cp5.addButton("HSB2")
    .setValue(0)
    .setPosition((Fwidth/2) + Fwidth/Globals.buttonHeight  + Globals.buttonWidth + Globals.spaceBetweenButtons,Fheight/2 - Globals.buttonWidth)
    .setSize(Globals.buttonWidth,Globals.buttonHeight)
    .setGroup(compareViewElements)
    ;
     
  cp5.addButton("....")
    .setValue(0)
    .setPosition((Fwidth/2) + Fwidth/Globals.buttonHeight + Globals.buttonWidth*2 + Globals.spaceBetweenButtons*2,Fheight/2 - Globals.buttonWidth)
    .setSize(Globals.buttonWidth,Globals.buttonHeight)
    .setGroup(compareViewElements)
    ;

  prepareData("brugel");
}

void customize(DropdownList ddl) {
  // a convenience function to customize a DropdownList
  ddl.setBackgroundColor(color(190));
  ddl.setItemHeight(30);
  ddl.setBarHeight(30);
  ddl.captionLabel().style().marginTop = 10;
  ddl.captionLabel().style().marginLeft = 5;
  ddl.valueLabel().style().marginTop = 5;
  for (int i=0;i<40;i++) {
    ddl.addItem("item "+i, i);
  }
  ddl.scroll(0);
  ddl.setColorBackground(color(60));
  ddl.setColorActive(color(255, 128));
}

void keyPressed() {
  // some key events to change the properties of DropdownList d1
  if (key=='1') {
    // set the height of a pulldown menu, should always be a multiple of itemHeight
    d1.setHeight(210);
  } 
  else if (key=='2') {
    // set the height of a pulldown menu, should always be a multiple of itemHeight
    d1.setHeight(120);
  }
  else if (key=='3') {
    // set the height of a pulldown menu item, should always be a fraction of the pulldown menu
    d1.setItemHeight(30);
  } 
  else if (key=='4') {
    // set the height of a pulldown menu item, should always be a fraction of the pulldown menu
    d1.setItemHeight(12);
    d1.setBackgroundColor(color(255));
  } 
  else if (key=='5') {
    // add new items to the pulldown menu
    int n = (int)(random(100000));
    d1.addItem("item "+n, n);
  } 
  else if (key=='6') {
    // remove items from the pulldown menu  by name
    d1.removeItem("item "+cnt);
    cnt++;
  }
  else if (key=='7') {
    d1.clear();
  }
}

void controlEvent(ControlEvent theEvent) {
  if (theEvent.isGroup()) {
    // check if the Event was triggered from a ControlGroup
    println("event from group : "+theEvent.getGroup().getValue()+" from "+theEvent.getGroup());
  } 
  else if (theEvent.isController()) {
    println("event from controller : "+theEvent.getController().getValue()+" from "+theEvent.getController());
  }
}

void prepareData(String author) {
  Globals.authorId = author;
  Globals.author = loadJSONObject(Globals.DATA_DIR + author + ".json");


  Globals.works = new JSONArray();
  JSONArray worksMeta = Globals.author.getJSONArray("works");
  for (int i = 0; i < worksMeta.size(); i++) {
    String id = worksMeta.getJSONObject(i).getString("id");
    String path = Globals.DATA_DIR + author + "/" + id + ".json";
    Globals.works.setJSONObject(i, loadJSONObject(path));
  }
}


void draw() {
  background(255);  
  fill(0,150,253);
  textFont(font);
  textAlign(CENTER);
  text("Analizing and comparing works of art",(Fwidth/2),Globals.buttonWidth);
  //draw line
  stroke(212,212,210);

  if (Globals.viewMode == Globals.VIEW_MODE_WORKS) {
    drawWorks();
  } else {
    drawCompare();
  }
}

void drawCompare() {
  //draw images
  line(Fwidth/2,Globals.buttonWidth + Globals.buttonHeight,Fwidth/2,Fheight/2);
  compareViewElements.show();
  img1.resize(0,200);
  img2.resize(0,200);
  imageMode(CENTER);
  image(img1,Fwidth/4,Fheight/4 + Globals.imageMargin);
  image(img2,(Fwidth/4)*3,Fheight/4 + Globals.imageMargin);
}

void drawWorks() {
  compareViewElements.hide();
  pushMatrix();
  int fromY = Globals.FRAME_HEIGHT / 2,
    toY = Globals.FRAME_HEIGHT - 10;
  int fromX = 10,
    toX = Globals.FRAME_WIDTH - 10;
  
  translate(fromX, toY);
  // TODO: draw only the ones that are visible

  for (int i = 0; i < Globals.works.size(); i++) {
    plotRGB(i*256, -100, i); // TODO: relative size (use zoom)
  }
  
  popMatrix();
}

// TODO: click
// TODO: drag
// TODO: zoom

void plotRGB(int xStart, int yStart, int workId) {
  JSONObject work = Globals.works.getJSONObject(workId);
  JSONObject meta = Globals.author.getJSONArray("works").getJSONObject(workId);
  
  colorMode(RGB);
  String[] chans = {"r", "g", "b"};
  int[][] colors = {
    new int[] {255, 0, 0}, new int[] {0, 255, 0}, new int[] {0, 0, 255}
  };
  for (int ch=0; ch < 3; ch++) {
    float prevX = xStart, prevY = yStart;
    JSONArray data = work.getJSONArray(chans[ch]);
    
    for (int col=0; col < 256; col++) {
      float size = data.getInt(col) / 30.0;
      float newX = xStart + col, newY = yStart - size;
      //point(xStart + col, yStart + (size/10));

      stroke(colors[ch][0], colors[ch][1], colors[ch][2]);
      line(prevX, prevY, newX, newY);
      
      prevX = newX;
      prevY = newY;
    }
  }
  textAlign(CENTER);
  textFont(font);
  text(Globals.makeShorter(meta.getString("title"), 30),
       xStart + 128, yStart + 30);
  text(meta.getString("year") + " - " + meta.getString("teh"),
       xStart + 128, yStart + 60);
}

