/*
zanekrat delam na dveh statičnih slikah, ne najdem primerne baze
*/
PFont font = createFont("Arial", 16,true); 
int Fwidth = 1400;
int Fheight = 1000;
PImage img1;
PImage img2;

import controlP5.*;
ControlP5 cp5;
DropdownList d1, d2, d3, d4;
int cnt = 0;

void setup() {
  size(Fwidth, Fheight);
  img1 = loadImage("tm.jpg");
  img2 = loadImage("house.jpg");
  cp5 = new ControlP5(this);
  //dropdowns
  d1 = cp5.addDropdownList("list1_0")
          .setSize(200,200)
          .setPosition(Fwidth/4 - 200, 100)
          ;

  d2 = cp5.addDropdownList("list1_1")
          .setSize(200,200)
          .setPosition(Fwidth/4 + 3, 100)
          ;
  d3 = cp5.addDropdownList("list2_0")
          .setSize(200,200)
          .setPosition( 3*(Fwidth/4) - 200, 100)
          ;
  d4 = cp5.addDropdownList("list2_1")
          .setSize(200,200)
          .setPosition( 3*(Fwidth/4) + 3 , 100)
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
     .setPosition(Fwidth/20,460)
     .setSize(50,20)
     ;
  
  cp5.addButton("HSB1")
     .setValue(0)
     .setPosition(Fwidth/20 + 50 + 3,460)
     .setSize(50,20)
     ;
     
  cp5.addButton("...")
     .setValue(0)
     .setPosition(Fwidth/20 + 50*2 + 6,460)
     .setSize(50,20)
     ;
  cp5.addButton("RGB2")
     .setValue(0)
     .setPosition((Fwidth/2) + Fwidth/20,460)
     .setSize(50,20)
     ;

  cp5.addButton("HSB2")
     .setValue(0)
     .setPosition((Fwidth/2) + Fwidth/20  + 50 + 3,460)
     .setSize(50,20)
     ;
     
  cp5.addButton("....")
     .setValue(0)
     .setPosition((Fwidth/2) + Fwidth/20 + 50*2 + 6,460)
     .setSize(50,20)
     ;
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


void draw() {
  background(255);  
  fill(0,150,253);
  textFont(font);
  text("Analizing and comparing works of art",(Fwidth/2)-150,40);
  //draw line
  stroke(212,212,210);
  line(Fwidth/2,70,Fwidth/2,Fheight-70);
  
  //draw images
  img1.resize(0,300);
  img2.resize(0,300);
  imageMode(CENTER);
  image(img1,Fwidth/4,Fheight/4 + 30);
  image(img2,(Fwidth/4)*3,Fheight/4 + 30);
  
}

























