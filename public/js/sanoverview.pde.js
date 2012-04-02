//canvas size
int cWidth = 780;
int cHeight = 500;
//xml config
XMLElement xml;

$.ajax({
  async: false,
  cache: false,
  url: '/xml/generate',
  success: function(res){
    xml = XMLElement.parse(res);
  }
});

ArrayList sanelements = new ArrayList();
ArrayList connectionelements = new ArrayList();


//icon position
HashMap widthMap = new HashMap();
widthMap.put("storage", 600);
widthMap.put("server", 80);

//icons
int iconSize = 80;
String storage = "/img/hard_disk.png";
String storageH = "/img/hard_diskHover.png";
String server = "/img/server.png";
String serverH = "/img/serverHover.png";
String trash = "/img/trash.png";
PImage trashIco = loadImage(trash);
HashMap iconMap = new HashMap();
iconMap.put("storage",new Array(loadImage(storage),loadImage(storageH)));
iconMap.put("server", new Array(loadImage(server),loadImage(serverH)));
commitStr = "Commit";

//temp connection
boolean mode = false;
SANElement connE;
float tempX = 0;
float tempY = 0;

void setup(){
  setHeight();
  initializeElementList();
  
  background(255);
  stroke(0);  
  textSize(14);

  drawElements();
	  
  size(cWidth,cHeight);   
}  
  
void draw(){
  background(255);
  
  drawElements();
  drawTempConn();
}  

function initializeElementList(){
  for(int i = 0; i < xml.getChildCount(); i++){
    XMLElement elements = xml.getChild(i);
  	
    for(int j = 0; j < elements.getChildCount(); j++){
      XMLElement element = elements.getChild(j);
      
      if(elements.getName() == "serverList" || elements.getName() == "storageList"){
        String eName = element.getName();
        String eAtt = element.getStringAttribute("id"); 
	    
        String eContent = element.getContent();
	    
        sanelements.add(new SANElement(eName, eAtt, eContent, widthMap.get(eName), 50+j*150));
      }
      else if(elements.getName() == "connectionList"){
        String eFromId = element.getChild(0).getContent();
        String eToId = element.getChild(1).getContent();  
        
        connectionelements.add(new Connection(eFromId, eToId));
      }
    }
  } 
}

function setHeight(){
  XMLElement servers = xml.getChild(0);
  XMLElement storages = xml.getChild(1);
    
  if(storages.getChildCount() > servers.getChildCount()){
    cHeight = 30+150*storages.getChildCount();
  }
  else{
    cHeight = 30+150*servers.getChildCount();
  }
}

function drawElements(){
  for(int i = 0; i < sanelements.size(); i++){
    SANElement e = (SANElement) sanelements.get(i);
    e.drawElement();
  }
  
  for(int i = 0; i < connectionelements.size(); i++){
    Connection c = (Connection) connectionelements.get(i);
    c.drawElement();
  }

  stroke(0);
  
  textAlign(LEFT);
  text("Server",100,20);

  text(commitStr,225,20);
  
  textAlign(RIGHT);
  text("Storage",cWidth-120,20);
}

function drawTempConn(){
  noFill();
 
  if(mode == 1){
    if(connE.getType() == "server"){
      bezier(tempX,tempY,abs(tempX-mouseX)*1/4+tempX,tempY,abs(tempX-mouseX)*3/4+tempX,mouseY,mouseX,mouseY);
    }
    else if(connE.getType() == "storage"){
      bezier(mouseX,mouseY,tempX-abs(tempX-mouseX)*3/4,mouseY,tempX-abs(tempX-mouseX)*1/4,tempY,tempX,tempY);
    }
  }
}

function sendConnectionUpdate(){
  String xml = "<model>\n  <connectionList>\n";

  for(int i = connectionelements.size()-1; i >= 0; i--){
    Connection c = (Connection) connectionelements.get(i);
	
    xml += "    <connection>\n      <from>"+c.fromId+"</from>\n      <to>"+c.toId+"</to>\n    </connection>\n";

  }

  xml += "  </connectionList>\n</model>";

  $.ajax({
    type: 'POST',
    url: '/xml/update',
    data: { 
      inputxml: escape(xml)
    },
    contentType: 'text/XML',
    processData: false,
    async: false,
    cache: false
  });

}

class SANElement{
  String type;
  String id;
  String name;
  float xPos;
  float yPos;

  SANElement(String type, String id, String name, float xPos, float yPos){
    this.type = type;
    this.id = id;
    this.name = name;
    this.xPos = xPos;
    this.yPos = yPos;
  }
  
  void drawElement(){
  	String align = LEFT;
  	PImage icon;
  	float textXPos = 0;
  	float textYPos = 0;
  	
    fill(0);
    if(this.type == "server"){
      align = LEFT;
      textXPos = this.xPos;
      textYPos = this.yPos+100;
    }
    else if(this.type == "storage"){
      align = RIGHT;
      textXPos = this.xPos+80;
      textYPos = this.yPos+100;
    }
    
    if(abs(this.xPos+40-mouseX) < 40 && abs(this.yPos+40-mouseY) < 40){
      icon = iconMap.get(this.type)[1];
    } 
    else{
      icon = iconMap.get(this.type)[0];
    }
    
    textAlign(align);
    
    image(icon,this.xPos,this.yPos,iconSize,iconSize);
    text(name,textXPos,textYPos);
  }
  
  String getId(){
  	return this.id;
  }
  
  String getType(){
  	return this.type;
  }
  
  float getXPos(){
  	return this.xPos;
  }
  
  float getYPos(){
  	return this.yPos;
  }
}

class Connection{
  String fromId;
  String toId;
  boolean marked = false;
  
  Connection(String fromId, String toId){
  	this.fromId = fromId;
  	this.toId = toId;
  }	
  
  String getFromId(){
  	return this.fromId;
  }
  
  String getToId(){
  	return this.toId;
  }

  boolean compareTo(Connection c){
  	if(this.fromId == c.getFromId() && this.toId == c.getToId()){
  	  return true;
  	}
  	else{
  	  return false;
  	} 
  }
  
  void drawElement(){
  	noFill();
	
	if(this.marked){
      textAlign(LEFT);
  	  //text("removeMarked",(cWidth/2)-60,20);
  	  image(trashIco,(cWidth/2)-10,10,20,20);
	  stroke(#e03e41);
	}
  	  	
  	float xStart = 0;
  	float yStart = 0;
  	float xStop = 0;
  	float yStop = 0;
  	
    for(int i = 0; i < sanelements.size(); i++){
      SANElement e = (SANElement) sanelements.get(i);
      
      if(e.getId() == this.fromId && e.getType() == "server"){
      	xStart = e.getXPos()+72;
      	yStart = e.getYPos()+40;
      }
      if(e.getId() == this.toId && e.getType() == "storage"){
      	xStop = e.getXPos();
      	yStop = e.getYPos()+40;
      }      
    }
    
    bezier(xStart,yStart,abs(xStop-xStart)*1/4+xStart,yStart,abs(xStop-xStart)*3/4+xStart,yStop,xStop,yStop);
	
	stroke(0);
  }
  
  void setMarked(boolean markedStatus){
    this.marked = markedStatus;
  }
  
  boolean getMarked(){
    return this.marked;
  }
}

void mouseClicked(){

  boolean newConn = true;
  boolean stopConnLoop = false;
  
  float xStart = 0;
  float yStart = 0;
  float xStop = 0;
  float yStop = 0;
  float bezierX = 0;
  float bezierY = 0;
  
  for(int i = connectionelements.size()-1; i >= 0; i--){
    Connection c = (Connection) connectionelements.get(i);
	
    if(c.getMarked() && abs((cWidth/2)-mouseX) <= 10 && abs(20-mouseY) <= 10){
      connectionelements.remove(c);
    }
  }

  if(abs(250-mouseX) <= 25 && abs(15-mouseY) <= 5){
    sendConnectionUpdate();
    //alert(mouseX + " " + mouseY);
  }

  if(!mode){
    for(int i = 0; i < sanelements.size(); i++){
      SANElement e = (SANElement) sanelements.get(i);
      if(abs(e.getXPos()+40-mouseX) <= 40 && abs(e.getYPos()+40-mouseY) <= 40){
        if(e.getType() == "server"){
      	  tempX = e.getXPos()+72;
      	  tempY = e.getYPos()+40;
      	}
      	else if(e.getType() == "storage"){
      	  tempX = e.getXPos();
      	  tempY = e.getYPos()+40;
      	}
      	
      	connE = e;
      	mode = true;
      }
    }
	
    for(int i = 0; i < connectionelements.size(); i++){
      if(!stopConnLoop && !mode){
        Connection c = (Connection) connectionelements.get(i);
  
        for(int j = 0; j < sanelements.size(); j++){
          SANElement e = (SANElement) sanelements.get(j);
      
          if(e.getId() == c.fromId && e.getType() == "server"){
      	    xStart = e.getXPos()+72;
      	    yStart = e.getYPos()+40;
          }
          if(e.getId() == c.toId && e.getType() == "storage"){
      	    xStop = e.getXPos();
       	    yStop = e.getYPos()+40;
          }      
        }
	  
        for(int j = 1; j <= 200; j++){
          bezierX = bezierPoint(xStart,xStart+abs(xStop-xStart)*1/4,xStart+abs(xStop-xStart)*3/4,xStop, j/100);
          bezierY = bezierPoint(yStart,yStart,yStop,yStop, j/100);
		
          if(abs(bezierX-mouseX) <= 10 && abs(bezierY-mouseY) <= 10){
            if(c.getMarked()){
              c.setMarked(false);
            }
            else{
              c.setMarked(true);
            }

            stopConnLoop = true;
			
            break;
          }
        }
      }
    }
  }
  else{
    for(int i = 0; i < sanelements.size(); i++){
      SANElement e = (SANElement) sanelements.get(i);
      if(abs(e.getXPos()+40-mouseX) <= 40 && abs(e.getYPos()+40-mouseY) <= 40){
      	if(e.getType() != connE.getType()){
      	  if(e.getType() == "server"){
            Connection nConn = new Connection(e.getId(),connE.getId());
          }
          else if(e.getType() == "storage"){
            Connection nConn = new Connection(connE.getId(),e.getId());
          }
          
          for(int j = 0; j < connectionelements.size(); j++){
            Connection c = (Connection) connectionelements.get(j);
          	
            if(nConn.compareTo(c)){
              newConn = false;
            }
          }
          
          if(newConn){
            connectionelements.add(nConn);
          }
        }
      }
    }
      
    mode = false;
    connE = null;
    tempX = 0;
    tempY = 0;
  }
}
