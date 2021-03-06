//canvas size
int cWidth = 780; //default width
int cHeight = 500; //default height

XMLElement xml;
//load xml config from backend
$.ajax({
  async: false,
  cache: false,
  url: subdir + '/xml/generate',
  success: function(res){
    xml = XMLElement.parse(res);
  }
});

//list of sanelements -> server, storage and switch
ArrayList sanelements = new ArrayList();
//list of connections -> valid and deleted
HashMap connectionelements = new HashMap();
HashMap deletedelements = new HashMap();

//icon position -> the x coordinate
HashMap widthMap = new HashMap();
widthMap.put("storage", 600);
widthMap.put("server", 80);
widthMap.put("switch", 330);

//icons
int iconSize = 80;
String storage = subdir + "/img/hard_disk.png";
String storageH = subdir + "/img/hard_diskHover.png";
String server = subdir + "/img/server.png";
String serverH = subdir + "/img/serverHover.png";
String sanswitch = subdir + "/img/switch.png";
String sanswitchH = subdir + "/img/switchHover.png";
//String trash = "/img/trash.png";
//PImage trashIco = loadImage(trash);
HashMap iconMap = new HashMap();
iconMap.put("storage",new Array(loadImage(storage),loadImage(storageH)));
iconMap.put("server", new Array(loadImage(server),loadImage(serverH)));
iconMap.put("switch", new Array(loadImage(sanswitch),loadImage(sanswitchH)));
//commitStr = "Commit";

//temp connection
int mode = 0;
SANElement connE1;
SANElement connE2;

//setup code executed once at the beginning
void setup(){
  setHeight();
  initializeElementList();
  
  background(255);
  stroke(0);  
  textSize(14);

  drawElements();
	  
  size(cWidth,cHeight);   
}  
  
//draw function executed repeatedly for redrawing
void draw(){
  background(255);
  
  drawElements();
  drawTempConn();
}

//initalizes elementlist and connectionlist from xml data
function initializeElementList(){
  for(int i = 0; i < xml.getChildCount(); i++){
    XMLElement elements = xml.getChild(i);
  	
    for(int j = 0; j < elements.getChildCount(); j++){
      XMLElement element = elements.getChild(j);
      
      if(elements.getName() == "serverList" || elements.getName() == "storageList" || elements.getName() == "switchList"){
        String eName = element.getName();
        String eAtt = element.getStringAttribute("id");
        String eContent = element.getContent();
	    
        sanelements.add(new SANElement(eName, eAtt, eContent, widthMap.get(eName), 50+j*150));
      }
      else if(elements.getName() == "connectionList"){
        String eFromId = element.getChild(0).getContent();
        String eOverId = element.getChild(1).getContent();
        String eToId = element.getChild(2).getContent();
        String eName = element.getString("name");

        Connection c = new Connection(eFromId, eOverId, eToId);
        
        String cId = c.getFromId() +";"+ c.getOverId() + ";" + c.getToId();
        
        $(".connectionlist").append("<option value=\""+cId+"\">"+eName+"</option>");
        
        connectionelements.put(cId,c);
      }
    }
  } 
}

//defines canvas size from amount of elements
function setHeight(){
  XMLElement servers = xml.getChild(0);
  XMLElement storages = xml.getChild(1);
  XMLElement switches = xml.getChild(2);
    
  if(storages.getChildCount() > servers.getChildCount()){
    cHeight = 30+150*storages.getChildCount();
  }
  else if(switches.getChildCount() > storages.getChildCount() && switches.getChildCount() > servers.getChildCount()){
    cHeight = 30+150*switches.getChildCount();
  }
  else{
    cHeight = 30+150*servers.getChildCount();
  }
}

//method to loop through all elements and draw them -> first connections so any part that no part of the line overlaps a symbol
//also draws text for Server, Switch and Storage
function drawElements(){  
  Iterator i = connectionelements.entrySet().iterator();
  
  while(i.hasNext()){
  	Map.Entry me = (Map.Entry)i.next();
  	Connection c = (Connection) me.getValue();
  	c.drawElement();
  }
  
  for(int i = 0; i < sanelements.size(); i++){
    SANElement e = (SANElement) sanelements.get(i);
    e.drawElement();
  }

  stroke(0);
  
  textAlign(LEFT);
  text("Server",100,20);

  text("Switch",340,20);
  
  //text(commitStr,225,20);
  
  textAlign(RIGHT);
  text("Storage",cWidth-120,20);
}

//draws temporary connection for connection creation from start element to mouse position
function drawTempConn(){
  noFill();
 
  if(mode == 1){//step one of connection drawing
  	float tempX = 0;
  	float tempY = 0;
    if(connE1.getType() == "server"){
      tempX = connE1.getXPos()+72;
      tempY = connE1.getYPos()+40;
      bezier(tempX,tempY,abs(tempX-mouseX)*1/4+tempX,tempY,abs(tempX-mouseX)*3/4+tempX,mouseY,mouseX,mouseY);
    }
    else if(connE1.getType() == "storage"){
      tempX = connE1.getXPos();
      tempY = connE1.getYPos()+40;
      bezier(mouseX,mouseY,tempX-abs(tempX-mouseX)*3/4,mouseY,tempX-abs(tempX-mouseX)*1/4,tempY,tempX,tempY);
    }
  }
  if(mode == 2){//step two of connectiond drawing (includes code the temp connections so far)
  	float xStart = 0;
  	float yStart = 0;
  	float xOverStop = 0;
  	float yOverStop = 0;
  	float xOverStart = 0;
  	float yOverStart = 0;
  	float xStop = 0;
  	float yStop = 0;
  	
  	if(connE1.getType() == "server"){
  	  xStart = connE1.getXPos()+72;
  	  yStart = connE1.getYPos()+40;
  	  xOverStop = connE2.getXPos()+4;
      yOverStop = connE2.getYPos()+40;
      xOverStart = connE2.getXPos()+78;
      yOverStart = connE2.getYPos()+40;
  	  bezier(xStart,yStart,abs(xOverStop-xStart)*1/4+xStart,yStart,abs(xOverStop-xStart)*3/4+xStart,yOverStop,xOverStop,yOverStop);
  	  bezier(xOverStart, yOverStart,abs(xOverStart-mouseX)*1/4+xOverStart,yOverStart,abs(xOverStart-mouseX)*3/4+xOverStart,mouseY,mouseX,mouseY);
  	}
  	else if(connE1.getType() == "storage"){
  	  xOverStop = connE2.getXPos()+4;
      yOverStop = connE2.getYPos()+40;
      xOverStart = connE2.getXPos()+78;
      yOverStart = connE2.getYPos()+40;
      xStop = connE1.getXPos();
      yStop = connE1.getYPos()+40;
      bezier(mouseX,mouseY,xOverStop-abs(xOverStop-mouseX)*3/4,mouseY,xOverStop-abs(xOverStop-mouseX)*1/4,yOverStop,xOverStop,yOverStop);
      bezier(xOverStart, yOverStart, abs(xStop-xOverStart)*1/4+xOverStart,yOverStart,abs(xStop-xOverStart)*3/4+xOverStart,yStop,xStop,yStop);
  	}
  }
}

//send the connectionList and the deletedList to the server to update the database
function sendConnectionUpdate(){
  String xml = "<model><connectionList>";

  Iterator i = connectionelements.entrySet().iterator();
  
  while(i.hasNext()){
  	Map.Entry me = (Map.Entry)i.next();
  	Connection c = (Connection) me.getValue();
	
    xml += "<connection><from>"+c.fromId+"</from><over>"+c.overId+"</over><to>"+c.toId+"</to></connection>";
  }
  
  xml += "</connectionList><deletedList>"
  
    i = deletedelements.entrySet().iterator();
  
  while(i.hasNext()){
  	Map.Entry me = (Map.Entry)i.next();
  	Connection c = (Connection) me.getValue();
	
    xml += "<connection><from>"+c.fromId+"</from><over>"+c.overId+"</over><to>"+c.toId+"</to></connection>";
  }

  xml += "</deletedList></model>"

  $.ajax({ 
    async: 'false', 
    cache: 'false', 
    contentType: 'text/xml', 
    data: xml, 
    dataType: 'html', 
    processData: false, 
    type: 'POST', 
    headers: {
      'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
    },
    url: subdir + '/xml/update'
  }); 

}

//class definition for Switch, Server and Storage elements
//Object created upon loading the config
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
	else if(this.type == "switch"){
	  align = LEFT;
	  textXPos = this.xPos+10;
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

//Class for Connection 
//Object created upon loading the config
class Connection{
  String fromId;
  String overId;
  String toId;
  boolean marked = false;
  
  Connection(String fromId, String overId, String toId){
  	this.fromId = fromId;
  	this.overId = overId;
  	this.toId = toId;
  }	
  
  String getFromId(){
  	return this.fromId;
  }
  
  String getOverId(){
  	return this.overId;
  }
  
  String getToId(){
  	return this.toId;
  }

  boolean compareTo(Connection c){
  	if(this.fromId == c.getFromId() && this.toId == c.getToId() && this.overId == c.getOverId()){
  	  return true;
  	}
  	else{
  	  return false;
  	} 
  }
  
  void drawElement(){
  	noFill();
  	
	if(this.marked){
  	  strokeWeight(3);
	  stroke(#e03e41);
	}
  	  	
  	float xStart = 0;
  	float yStart = 0;
  	float xStop = 0;
  	float yStop = 0;
  	float xOverStart = 0;
  	float yOverStart = 0;
  	float xOverStop = 0;
  	float yOverStop = 0;

    for(int i = 0; i < sanelements.size(); i++){
      SANElement e = (SANElement) sanelements.get(i);

      if(e.getId() == this.fromId && e.getType() == "server"){
      	xStart = e.getXPos()+72;
      	yStart = e.getYPos()+40;
      }
      if(e.getId() == this.overId && e.getType() == "switch"){
      	xOverStop = e.getXPos()+4;
      	yOverStop = e.getYPos()+40;
      	xOverStart = e.getXPos()+78;
      	yOverStart = e.getYPos()+40;
      	
      }
      if(e.getId() == this.toId && e.getType() == "storage"){
      	xStop = e.getXPos();
      	yStop = e.getYPos()+40;
      }      
    }

    bezier(xStart,yStart,abs(xOverStop-xStart)*1/4+xStart,yStart,abs(xOverStop-xStart)*3/4+xStart,yOverStop,xOverStop,yOverStop);
    bezier(xOverStart, yOverStart, abs(xStop-xOverStart)*1/4+xOverStart,yOverStart,abs(xStop-xOverStart)*3/4+xOverStart,yStop,xStop,yStop);
	
	stroke(0);
	strokeWeight(1);
  }
  
  void setMarked(boolean markedStatus){
    this.marked = markedStatus;
  }
  
  boolean getMarked(){
    return this.marked;
  }
}

//method called upon click event
void mouseClicked(){

  boolean newConn = true;
  boolean stopConnLoop = false;
  
  float xStart = 0;
  float yStart = 0;
  float xStop = 0;
  float yStop = 0;
  float bezierX = 0;
  float bezierY = 0;

  //identifies element upon first click
  if(mode == 0){
    for(int i = 0; i < sanelements.size(); i++){
      SANElement e = (SANElement) sanelements.get(i);
      if(abs(e.getXPos()+40-mouseX) <= 40 && abs(e.getYPos()+40-mouseY) <= 40){
   	    if(e.getType() == "storage" || e.getType() == "server"){
      	  connE1 = e;
      	  mode = 1;   	    	
   	    }
      }
    }
  }
  //identifies element upon click on a switch -> second click
  else if(mode == 1){
  	for(int i = 0; i < sanelements.size(); i++){
  	  SANElement e = (SANElement) sanelements.get(i);
  	  if(abs(e.getXPos()+40-mouseX) <= 40 && abs(e.getYPos()+40-mouseY) <= 40){
  	  	if(e.getType() == "switch"){
  	  		connE2 = e;
  	  		mode = 2;
  	  	}
  	  }
  	}
  	if(connE2 == null){
      mode = 0;
      connE1 = null;
  	}
  }
  else{
  	//handles third click and element creation or removal
    for(int i = 0; i < sanelements.size(); i++){
      SANElement e = (SANElement) sanelements.get(i);
      if(abs(e.getXPos()+40-mouseX) <= 40 && abs(e.getYPos()+40-mouseY) <= 40){
      	if(e.getType() != connE1.getType() && e.getType() != "switch"){
      	  if(e.getType() == "server" && connE1.getType() == "storage"){
            Connection nConn = new Connection(e.getId(),connE2.getId(),connE1.getId());
          }
          else if(e.getType() == "storage" && connE1.getType() == "server"){
            Connection nConn = new Connection(connE1.getId(),connE2.getId(),e.getId());
          }
          
          Iterator i = connectionelements.entrySet().iterator();
  
		  while(i.hasNext()){
		  	Map.Entry me = (Map.Entry)i.next();
		  	Connection c = (Connection) me.getValue();
            if(nConn.compareTo(c)){
              newConn = false;
            }
          }
          
          if(newConn){
            String cId = nConn.getFromId() +";"+ nConn.getOverId() + ";" + nConn.getToId();
            connectionelements.put(cId,nConn);
            deletedelements.remove(cId);
            $(".connectionlist").append("<option value=\""+cId+"\">"+cId+"</option>");
          }
        }
      }
    }
      
    mode = 0;
    connE1 = null;
    connE2 = null;
  }
}

//update connectionlist for marked or unmarked status upon click in the connectionlist beneath the canvas
$(".connectionlist").change(function(){
	$(".connectionlist option").each(function(){
		Connection c = (Connection) connectionelements.get($(this).val());
		if($(this).attr("selected")){
			c.setMarked(true);
		}
		else{
			c.setMarked(false);
		}

	})
})

//sends out the connectionlist upon click on the commit button
$("#commit").click(function(){
  sendConnectionUpdate();
})

//deletes the marked connections from list upon click on delete button
$("#delete").click(function(){
  Iterator i = connectionelements.entrySet().iterator();
  
  while(i.hasNext()){
   Map.Entry me = (Map.Entry)i.next();
    Connection c = (Connection) me.getValue();

    if(c.getMarked()){
      String cId = c.getFromId() +";"+ c.getOverId() + ";" + c.getToId();
      deletedelements.put(cId,c);
      connectionelements.remove(cId);
      $(".connectionlist option").each(function(){
        if(cId == $(this).val()){
          $(this).remove();
        }
      })
    }
  }
})
