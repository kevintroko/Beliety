import java.util.Map;
import javax.swing.JOptionPane;
import processing.serial.*;
PFont myFont;
PrintWriter writer;  
ArrayList<String> lines;
boolean drawSquare, correr;
HashMap<String, Integer> hm;
BufferedReader reader, readerInfo;
String lnInfo, materia, mejorMateria, materiaActiva;
color colorActive, colorSquare, color1, color2, color3, color4; 
int subjectX, subjectY, counter, counter1, activeSquare, num, display, mayor; 

//1
Serial myPort;  // Create object from Serial class
String val;     // Data received from the serial port
//1

void setup() {
  size(1280, 720);

  //1
  String portName = Serial.list()[1]; //change the 0 to a 1 or 2 etc. to match your port
  myPort = new Serial(this, portName, 9600);
  //1

  hm = new HashMap<String, Integer>();
  lines = new ArrayList<String>();
  setSubjects();
  activeSquare=1;
  //background(149, 149, 149);
  background(180);
  colorActive= color(108, 166, 217);
  colorSquare=color(69, 95, 171);
  myFont = createFont("Seravek-bold", 32);
  textFont(myFont);
  textAlign(CENTER);
  noStroke();
  getBestSubject();
  drawSquares();
}

void draw() {

  if ( myPort.available() > 0) {  // If data is available,
    val = myPort.readStringUntil('\n');
  } 

  println(val); //print it out in the console

  if (drawSquare) {
    drawSquares();
  }
}

void serialEvent( Serial myPort) {
  val = myPort.readStringUntil('\n');
  if (val != null) {
    val = trim(val);
    drawSquare = true;
    num=0;

    if (val.equals("l")) {
      println("contact");
      if (activeSquare==1)
        counter--;
      else if (activeSquare==0) {
        resetSubjects();
        JOptionPane.showMessageDialog(null, "Reset", "Beliety", JOptionPane.INFORMATION_MESSAGE);
      }
    }else if(val.equals("r")){
      if (activeSquare==0) {
        saveSubjects();
        JOptionPane.showMessageDialog(null, "Guardado", "Beliety", JOptionPane.INFORMATION_MESSAGE);
      } else if (activeSquare==1)
        counter++;
      else if (activeSquare==2) {
        num=1;
        drawData(materiaActiva);
        getBestSubject();
      }
    }else if(val.equals("u")){
      activeSquare=(activeSquare-1)%4;
    }else if(val.equals("d")){
      activeSquare=(activeSquare+1)%4;
    }
  }
}

void keyPressed() {
  if (key == CODED) {
    drawSquare = true;
    num=0;
    if (keyCode == UP) {
      activeSquare=(activeSquare-1)%4;
    } else if (keyCode == DOWN) {
      activeSquare=(activeSquare+1)%4;
    } else if (keyCode==LEFT) {
      if (activeSquare==1)
        counter--;
      else if (activeSquare==0) {
        resetSubjects();
        JOptionPane.showMessageDialog(null, "Reset", "Beliety", JOptionPane.INFORMATION_MESSAGE);
      }
    } else if (keyCode==RIGHT) {
      if (activeSquare==0) {
        saveSubjects();
        JOptionPane.showMessageDialog(null, "Guardado", "Beliety", JOptionPane.INFORMATION_MESSAGE);
      } else if (activeSquare==1)
        counter++;
      else if (activeSquare==2) {
        num=1;
        drawData(materiaActiva);
        getBestSubject();
      }
    }
  } else {
    println("Error in the keyboard");
  }
}

void drawSquares() {
  if (activeSquare == 0) {
    color1 = colorActive;
    color2=color3=color4=colorSquare;
  } else if (activeSquare == 1 || activeSquare == -1) {
    color2 = colorActive;
    color1=color3=color4=colorSquare;
  } else if (activeSquare == 2 || activeSquare == -2) {
    color3 = colorActive;
    color2=color1=color4=colorSquare;
  } else if (activeSquare == 3 || activeSquare == -3) {
    color4 = colorActive;
    color2=color3=color1=colorSquare;
  }

  fill(color1);
  rect(100, 100, 200, 500, 10);
  fill(color2);
  rect(400, 100, 480, 100, 10);
  fill(color3);
  rect(400, 250, 480, 350, 10);
  fill(color4);
  rect(980, 100, 200, 500, 10);
  drawPanel3(num);
  drawText();
  drawSquare=false;
}

void drawText() {
  fill(0);
  this.display= Math.abs(counter%(lines.size()));
  textSize(48);
  materiaActiva=lines.get(display);
  text(materiaActiva, width/2, 170);
  text(materia, 980+100, 550);
  textSize(26);
  text("Grupo", 1080, 490);
  text("Mejor materia", 1080, 175);
  textSize(30);
  try {
    text(mejorMateria, 1080, 225);
  }
  catch(Exception e) {
    println(e);
    text(lines.get(0), 1080, 225);
  }
  text(mayor, 1080, 265);//0
  text("Guardar", 200, 170); //0
  text("Reiniciar", 200, 400); //0
  triangle(170, 220, 250, 260, 170, 300);//0
  triangle(230, 460, 150, 500, 230, 540);//0
  textSize(150);
  if (num!=1)
    text(hm.get(materiaActiva), 640, 475);
}

void drawPanel3(int num) {
  if (num==1) {
    fill(254-50, 229-50, 0);
    ellipse(640, 425, 300, 300);
    textSize(60);
    fill(0);
    text("Correcto", 640, 435);
  } else {
    fill(254, 229, 0);
    ellipse(640, 425, 300, 300);
  }
}

void setSubjects() {  
  String valor;
  readerInfo = createReader("info.txt"); 
  try {      
    materia=readerInfo.readLine();
    while ((lnInfo=readerInfo.readLine())!=null) {
      //println(lnInfo);
      lines.add(lnInfo);
      valor =  readerInfo.readLine();
      hm.put(lnInfo, int(valor));
    }   
    readerInfo.close();
  } 
  catch (IOException e) {
    e.printStackTrace();
    lnInfo = null;
  }
}

void getBestSubject() {
  int value=0;
  String materia="";
  for (int i=0; i<lines.size(); i++) {
    materia=lines.get(i);
    value=hm.get(materia);
    if (value>mayor) {
      this.mayor=value;
      this.mejorMateria=materia;
    }
  }
}

void drawData(String mat) {
  try {
    int valor=(hm.get(mat));
    hm.put(mat, valor+1);
  }
  catch(NullPointerException e) {
    print("draw Data "+e);
  }
}

void saveSubjects() {
  writer = createWriter("info.txt"); 
  writer.println(materia);
  for (int i=0; i<lines.size(); i++) {
    writer.println(lines.get(i));
    writer.println(hm.get(lines.get(i)));
  }    
  writer.flush(); // Writes the remaining data to the file
  writer.close(); // Finishes the file
}

void resetSubjects() {
  writer = createWriter("info.txt"); 
  writer.println(materia);
  for (int i=0; i<lines.size(); i++) {
    writer.println(lines.get(i));
    writer.println(0);
  }    
  writer.flush(); // Writes the remaining data to the file
  writer.close(); // Finishes the file
  this.mayor=0;
  setSubjects();
  activeSquare=1;
  getBestSubject();
  drawSquares();
}