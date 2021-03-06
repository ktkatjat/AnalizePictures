/*
zanekrat delam na dveh statičnih slikah, ne najdem primerne baze
*/
PFont font = createFont("Arial", 16,true);
PFont font24 = createFont("Arial", 24,true);
PFont fontSmall = createFont("Arial", 12,true);
PFont fontTiny = createFont("Arial", 5,true); 
int Fwidth = Globals.FRAME_WIDTH;
int Fheight = Globals.FRAME_HEIGHT;
PImage img1;
PImage img2;

import controlP5.*;
ControlP5 cp5;
DropdownList ddAuthors, ddAbsolute;
int cnt = 0;

Group compareViewElements;
Group worksViewElements;

boolean drawChanges = true;

int[][] positions;
float[][] positionBounds;

void setup() {
  size(Fwidth, Fheight);

  cp5 = new ControlP5(this);

  compareViewElements = cp5.addGroup("g1").setPosition(0,0);
  worksViewElements = cp5.addGroup("g2").setPosition(0,0);
  
  //dropdowns
  ddAuthors = cp5.addDropdownList("authors")
    .setLabel("Select an author to analyze")
    .setSize(Globals.boderLeftDD,Globals.boderLeftDD)
    .setPosition(Globals.FRAME_WIDTH - Globals.boderLeftDD - 10, 40)
    .setGroup(worksViewElements)
    ;
  ddAbsolute = cp5.addDropdownList("absolute")
    .setLabel("Data display (relative)")
    .setSize(Globals.boderLeftDD,Globals.boderLeftDD)
    .setPosition(10, 40)
    .setGroup(worksViewElements)
    ;
  for (int i=0; i<Globals.AUTHOR_NAMES.length; i++) {
    ddAuthors.addItem(Globals.AUTHOR_NAMES[i], i);
  }
  ddAbsolute.addItem("Absolute", 0);
  ddAbsolute.addItem("Relative", 1);
  
  customize(ddAuthors);
  customize(ddAbsolute);

//buttons
  cp5.addButton("back")
    .setValue(0)
    .setLabel("Return")
    .setPosition(Globals.FRAME_WIDTH - Globals.buttonWidth - 10, 15)
    .setSize(Globals.buttonWidth, Globals.buttonHeight)
    .setGroup(compareViewElements)
    .addCallback(new CallbackListener() {
        public void controlEvent(CallbackEvent event) {
          if (event.getAction() == ControlP5.ACTION_RELEASED) {
            Globals.selectedWork1 = -1;
            Globals.selectedWork2 = -1;
            img1 = null;
            img2 = null;
            Globals.viewMode = Globals.VIEW_MODE_WORKS;
            drawChanges = true;
          }
        }
      })
    ;
  
  prepareData("picasso");
}

void customize(DropdownList ddl) {
  // a convenience function to customize a DropdownList
  ddl.setBackgroundColor(color(190));
  ddl.setItemHeight(30);
  ddl.setBarHeight(30);
  ddl.captionLabel().style().marginTop = 10;
  ddl.captionLabel().style().marginLeft = 5;
  ddl.valueLabel().style().marginTop = 5;
//  for (int i=0;i<40;i++) {
//    ddl.addItem("item "+i, i);
//  }
  ddl.scroll(0);
  ddl.setColorBackground(color(60));
  ddl.setColorActive(color(255, 128));
}

void controlEvent(ControlEvent theEvent) {
  String element = null;
  float value = 0.0;
  if (theEvent.isGroup()) {
    // check if the Event was triggered from a ControlGroup
    println("event from group : "+theEvent.getGroup().getValue()+" from "+theEvent.getGroup());
    element = theEvent.getGroup().getName();
    value = theEvent.getGroup().getValue();
  } 
  else if (theEvent.isController()) {
    println("event from controller : "+theEvent.getController().getValue()+" from "+theEvent.getController());
    value = theEvent.getController().getValue();
    element = theEvent.getController().getName();
  }
  if (element == null) { return; }

  if (element.equals("authors")) {
    println("reinit");
    zoom = 1.0;
    drawChanges = true;
    prepareData(Globals.AUTHORS[(int)value]);
  } else if (element.equals("absolute")) {
    Globals.histRelative = (int)value == 1;
  }
  drawChanges = true;
}

void prepareData(String author) {
  Globals.authorId = author;
  Globals.author = loadJSONObject(Globals.DATA_DIR + author + ".json");


  Globals.works = new JSONArray();
  JSONArray worksMeta = Globals.author.getJSONArray("works");

  Globals.maxHG = -1;
  Globals.maxV = -1;
  for (int i = 0; i < worksMeta.size(); i++) {
    String id = worksMeta.getJSONObject(i).getString("id");
    String path = Globals.DATA_DIR + author + "/" + id + ".json";
    JSONObject data = loadJSONObject(path);
    Globals.works.setJSONObject(i, data);
   
    Globals.maxHG = (float)Math.max(Globals.maxHG, data.getInt("maxHG"));
    Globals.maxV = (float)Math.max(Globals.maxV, data.getInt("maxV")); // TODO: uncomment
  }
}


void draw() {
  if (!drawChanges) { return; }
  drawChanges = false;

  background(255);  

  textFont(font);

  if (Globals.viewMode == Globals.VIEW_MODE_WORKS) {
    drawWorks();
  } else {
    drawCompare();
  }
  
  colorMode(RGB);
  fill(255, 255, 255);
  noStroke();
  rect(0, 0, Globals.FRAME_WIDTH, Globals.TOP_HEIGHT);
  
  fill(0,150,253);
  textFont(font);
  textAlign(CENTER);
  text("Analizing and comparing works of art",(Fwidth/2), 20);
  textFont(font24);
  text(Globals.author.getString("name"),(Fwidth/2), 50);

}

void drawCompare() {
  String imgDir = Globals.DATA_DIR + Globals.authorId + "/";
  
  JSONObject work1 = Globals.works.getJSONObject(Globals.selectedWork1);
  JSONObject workMeta1 = Globals.author.getJSONArray("works").getJSONObject(Globals.selectedWork1);
  JSONObject work2 = Globals.works.getJSONObject(Globals.selectedWork2);
  JSONObject workMeta2 = Globals.author.getJSONArray("works").getJSONObject(Globals.selectedWork2);

  float imgHeight = Globals.FRAME_HEIGHT/2 * 0.7;
  if (img1 == null) {
    img1 = loadImage(imgDir + workMeta1.getString("large"));
    img1.resize(0, (int)imgHeight);
  }
  if (img2 == null) {
    img2 = loadImage(imgDir + workMeta2.getString("large"));
    img2.resize(0, (int)imgHeight);
  }

  compareViewElements.show();
  worksViewElements.hide();
  
  //stroke(212,212,210);
  //line(10, Globals.FRAME_HEIGHT/2 ,Globals.FRAME_WIDTH - 20, Globals.FRAME_HEIGHT / 2);

  imageMode(CENTER);
  textAlign(CENTER);
  textFont(font);
  
  float imgMarginY = 30;
  image(img1, Globals.FRAME_WIDTH/2, imgMarginY + Globals.FRAME_HEIGHT/4);
  text(workMeta1.getString("title", "No title") + ", " + workMeta1.getString("year", "unknown year"),
       Globals.FRAME_WIDTH/2, imgMarginY + Globals.FRAME_HEIGHT/4 + imgHeight/2 + 20);
  
  image(img2, Globals.FRAME_WIDTH/2, Globals.FRAME_HEIGHT*3/4 - imgMarginY);
  text(workMeta2.getString("title", "No title") + ", " + workMeta2.getString("year", "unknown year"),
       Globals.FRAME_WIDTH/2, Globals.FRAME_HEIGHT*3/4 + imgHeight/2 + 20 - imgMarginY);
}

float zoom = 1.0, dragIndex = 0.0,
  maxDrag = 0.0;

void drawWorks() {
  compareViewElements.hide();
  worksViewElements.show();
  
  int fromY = Globals.TOP_HEIGHT + 10,
    toY = Globals.FRAME_HEIGHT - 10;
  int fromX = 10,
    toX = Globals.FRAME_WIDTH - 10;
  JSONObject events = Globals.author.getJSONObject("events");
  int lastYear = 0, workInYear = 0, newYears = 0;
  int numDisplayed = (int)(Globals.FRAME_HEIGHT / Globals.WORK_HEIGHT * zoom);
  int row = 0;

  maxDrag = (Globals.works.size() - numDisplayed + 1) * Globals.WORK_HEIGHT * zoom;

  positions = new int[Globals.works.size()][2];
  positionBounds = new float[Globals.works.size()][2];
  pushMatrix();

  translate(fromX, fromY - dragIndex);
  for (int i = 0; i < Globals.works.size(); i++) {
    JSONObject workMeta = Globals.author.getJSONArray("works").getJSONObject(i);
    
    float workX = 0, workY = (row*Globals.WORK_HEIGHT)*zoom;
    int year = Integer.parseInt(workMeta.getString("yearKey", "3000"));
    boolean newYear = year != lastYear;

    if (newYear) {
      for (int yr = (lastYear + 1); yr <= year; yr++) {
        String yearString = new String(yr + "");
        String yearEvent = events.getString(yearString, "");

        if (yr != year && yearEvent.length() == 0) { continue; }

        pushMatrix();
        translate(2, workY);
        scale(zoom);
        fill(0);
        stroke(0);
        strokeWeight(1);
        if (yearEvent.length() > 0) {
          yearString += " - " + yearEvent;
          line(600/zoom, 23, (Globals.FRAME_WIDTH - 70)/zoom, 23);
        }
        else {
          line(100/zoom, 23, (Globals.FRAME_WIDTH - 70)/zoom, 23);
        }
        textFont(font24);
        textAlign(LEFT);
        text(yearString, 0, 30);
        popMatrix();

        translate(0, Globals.yearSepSize*zoom);
        newYears++;
      }
    }
    
    if (!newYear && zoom <= Globals.COMPACT_ZOOM && (workInYear % 2 == 1)) {
      workX = Globals.FRAME_WIDTH / 2;
      workY = (row-1)*Globals.WORK_HEIGHT*zoom;
      row -= 1;
      positions[row][1] = i;
    }
    else {
      positions[row][0] = i;
      positions[row][1] = i;
      positionBounds[row] = new float[] {
        fromY/zoom + Globals.yearSepSize*newYears + row*Globals.WORK_HEIGHT,
        fromY/zoom + Globals.yearSepSize*newYears + (row+1)*Globals.WORK_HEIGHT
      };
    }
    
    pushMatrix();
    
    translate(workX, workY);
    scale(zoom);
    if (positionBounds[row][0]*zoom - dragIndex >= 0 && positionBounds[row][1]*zoom - dragIndex <= (Globals.FRAME_HEIGHT + 200)) {
      plotWork(0, 0, toX - toY, i);
    }
    popMatrix();

    lastYear = year;
    row++;
    workInYear++;
  }
  popMatrix();

  if (Globals.selectedWork1 >= 0 && Globals.selectedWork2 >= 0) {
    Globals.viewMode = Globals.VIEW_MODE_COMPARE;
    drawChanges = true;
  }
}


void mouseClicked() {
  if (Globals.viewMode != Globals.VIEW_MODE_WORKS) { return; }
  if (mouseY < Globals.TOP_HEIGHT) { return; }
  int workId = workNum(mouseX, mouseY);
  if (workId >= 0) {
    if (Globals.selectedWork1 == workId) {
      return;
    }
    if (Globals.selectedWork1 >= 0) {
      Globals.selectedWork2 = workId;
    } else {
      Globals.selectedWork1 = workId;
    }
    drawChanges = true;
  }
  else {
    Globals.selectedWork1 = -1;
    Globals.selectedWork2 = -1;
  }
}
float prevY = 0;
void mouseDragged() { // TODO: more smooth
  dragIndex -= (mouseY - prevY);// > 0 ? 10 : -10;
  prevY = mouseY;
  if (dragIndex > maxDrag) { dragIndex = maxDrag; }
  if (dragIndex < 0) { dragIndex = 0; }
  drawChanges = true;

}

void mouseMoved() {
  prevY = mouseY;
}

void mouseWheel(MouseEvent event) {
  drawChanges = true;
  zoom -= (0.1 * event.getCount());
  if (zoom < Globals.MIN_ZOOM) { zoom = Globals.MIN_ZOOM; }
  else if (zoom > Globals.MAX_ZOOM) { zoom = Globals.MAX_ZOOM; }
}


void plotWork(float xStart, float yStart, float graphWidth, int workId) {
  JSONObject work = Globals.works.getJSONObject(workId);
  JSONObject meta = Globals.author.getJSONArray("works").getJSONObject(workId);
  boolean selected = workId == Globals.selectedWork1 || workId == Globals.selectedWork2;
  float plotHeight = Globals.WORK_HEIGHT * 0.95;
  float margin = 5;
  plotHue(work, plotHeight, zoom);
  translate(margin, 0);
  plotValue(work, plotHeight, zoom);
  translate(margin, 0);
  plotMainColors(work, plotHeight, zoom);
  translate(margin, 0);
  plotWorkMeta(meta, plotHeight, zoom, selected);
}

int workNum(int x, int y) {
  float rY = (dragIndex + y);
  for (int i = 0; i < Math.min(Globals.works.size(), positions.length); i++) {
    float up = positionBounds[i][0]*zoom, down = positionBounds[i][1]*zoom;

    if (up < rY && rY < down) {
      if (zoom <= Globals.COMPACT_ZOOM) {
        return x < Globals.FRAME_WIDTH/2.0 ? positions[i][0] : positions[i][1];
      }
      else {
        return positions[i][0];
      }
    }
  }
  return -1;
}

void plotHue(JSONObject work, float pHeight) {
  plotHue(work, pHeight, 1.0);
}
void plotHue(JSONObject work, float pHeight, float intZoom) {
  JSONObject grayhist = work.getJSONObject("grayhist");
  JSONObject huehist = work.getJSONObject("huehist");

  strokeWeight(1/intZoom);
  stroke(0);
  textAlign(CENTER);
  textFont(fontTiny);
  colorMode(HSB);
  float xPos = 0, colWidth = 254.0/(Globals.NUM_OF_HUES+Globals.NUM_OF_GRAYS),
    colHeight = pHeight;// * intZoom;
  
  float maxHG = Globals.histRelative ? work.getInt("maxHG") : Globals.maxHG;
  
  for (float h = 0; h < Globals.NUM_OF_HUES; h++) {
    float num = h >= 0 ? (float)huehist.getInt(""+(int)h, 0) : 0;
    float cSize = num / maxHG * colHeight;
    fill(h/Globals.NUM_OF_HUES * 255, 255, 255);
    rect(xPos, pHeight - cSize, colWidth, cSize);
    if (intZoom >= 1.5) {
      fill(0, 0, 0);
      text(""+(int)num, xPos + colWidth / 2, pHeight - cSize - 5);
    }
    xPos += colWidth;
  }

  colorMode(RGB);
  for (int g = 0; g < Globals.NUM_OF_GRAYS; g += 1) {
    float gray = g * (255/Globals.NUM_OF_GRAYS);
    float num = gray >= 0 ? (float)grayhist.getInt(""+g, 0) : 0;
    float cSize = num / maxHG * colHeight;
    fill(gray, gray, gray);
    rect(xPos, pHeight - cSize, colWidth, cSize);
    if (intZoom > 1.4) {
      fill(0);
      text(""+(int)num, xPos + colWidth / 2, pHeight - cSize - 5);
    }
    xPos += colWidth;
  }
  // Move correctly right
  translate(xPos, 0);
}

void plotValue(JSONObject work, float pHeight, float intZoom) {
  JSONObject hist = work.getJSONObject("valhist");

  stroke(0);
  textAlign(CENTER);
  textFont(fontTiny);
  colorMode(RGB);
  float xPos = 0, colWidth = 1,
    colHeight = pHeight;
  
  float maxV = Globals.histRelative ? work.getInt("maxV") : Globals.maxV;

  for (int i = 0; i < 255; i++) {
    float num = (float)hist.getInt(""+(int)i, 0);
    float cSize = num / maxV * colHeight;
    fill(150);
    noStroke();
    rect(xPos, pHeight - cSize, colWidth, cSize);
    if (intZoom >= 1.5) {
      fill(0);
      text(""+(int)num, xPos + colWidth / 2, pHeight - cSize - 5);
    }
    xPos += colWidth;
  }
  translate(xPos, 0);
}

void plotMainColors(JSONObject work, float pHeight, float intZoom) {
  JSONArray colors = work.getJSONArray("colors");
  float plotWidth = 200;
  for (int i = 0; i < colors.size(); i++) {
    JSONArray mainColorData = colors.getJSONArray(i);
    JSONArray rgb = mainColorData.getJSONArray(0);
    float rectSize = mainColorData.getFloat(2) * plotWidth;
    colorMode(RGB);
    fill(rgb.getInt(0), rgb.getInt(1), rgb.getInt(2));
    noStroke();
    rect(0, 0.3*pHeight, rectSize, 0.7*pHeight);
    translate(rectSize, 0);
  }
}
void plotWorkMeta(JSONObject meta, float pHeight, float intZoom, boolean sel) {
  int textNum = 40;
  String title = Globals.makeShorter(meta.getString("title", "No title"), textNum);
  String teh = Globals.makeShorter(meta.getString("teh", "/"), textNum);
  String year = Globals.makeShorter(meta.getString("year", ""), textNum);
  String bullet = "○ ";
  
  textFont(font);
  textAlign(LEFT);
  colorMode(RGB);
  if (sel) {
    fill(255, 0, 0);
  } else {
    fill(0);
  }
  
  text(bullet + title, 0, 30);
  text(bullet + teh, 0, 60);
  text(bullet + year, 0, 90);
  
}
