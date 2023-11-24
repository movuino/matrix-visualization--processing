import processing.serial.*;

// Serial communication
Serial myPort; // Serial communication with touch sensor
ArduinoSerial arduinoSerial;
Thread serialThread;
String serialData = "";

// Colors
color red = color(245, 91, 85);
color blue = color(125, 222, 227);
color yellow = color(243, 240, 114);
color green = color(0, 255, 127);
color purple = color(73, 81, 208);
color white = color(255, 255, 255);

// Size
int maxValue = 1024;
int maxDiameter = 75;       // Max range to display data point

// Sensors
DataPoint[][] pointGrid;    // Array of data points from the touch surface
int COLS = 7; // 7;         // number of data point on X axis for touch surface
int ROWS = 15; // 15;       // number of data point on Y axis for touch surface
int dataCounter = 0;        // count number of incoming data
long timerDataCounter0 = 0; // timer to compute incoming data rate

Table table; //For writing to the .csv file
TableRow newRow;
String colId = "";
boolean isRecording = false;
boolean isOnOff = false;
float time_sec = 0;
int recordCount = 0;

//Record button parameters
int button_d = 1;
int button_x1 = 10 + button_d/2;
int button_y1 = 10 + button_d/2;
int button_x2 = button_x1 + 3*button_d/2;
int button_y2 = button_y1;
RecordButton  play = new RecordButton(button_x1, button_y1, button_d); 
RecordButton rec = new RecordButton(button_x2, button_y2, button_d);

int w = COLS*100;
int h = ROWS*100 + 2*button_d + 10;

void setup()
{
  // Set size
  size(400, 900);
  maxDiameter = int(width / float(COLS) - 10);

  // Set data point grid
  pointGrid = new DataPoint[COLS][ROWS];
  for (int i = 0; i < COLS; i++) {
    for (int j = 0; j < ROWS; j++) {
      pointGrid[i][j] = new DataPoint(i, j);
    }
  }

  // Set Table 
  table = new Table();
  table.addColumn("time");
  for (int i = 0; i < COLS; i++) {
    for (int j = 0; j < ROWS; j++) {
      colId = "x" + str(j) + "y" + str(i);
      table.addColumn(colId);
    }
  }

  // Set serial communication with touch sensors
  printArray(Serial.list());
  String portName = Serial.list()[3];
  myPort = new Serial(this, portName, 115200); // initialize serial communication
  arduinoSerial = new ArduinoSerial();
  serialThread = new Thread(arduinoSerial);
  serialThread.start();                       // start serial thread

  timerDataCounter0 = millis();

  myPort.clear();
}

void draw()
{
  background(purple);

  play.displayOnOff(isOnOff);
  rec.displayRecord(isRecording);

  // Display data points
  for (int i = 0; i < COLS; i++) {
    for (int j = 0; j < ROWS; j++) {
      pointGrid[i][j].display(maxValue, maxDiameter); // display data point
    }
  }

  //Recording the dataPoints' smooth values
  if (isRecording) {
    for (int i = 0; i < COLS; i++) {
      for (int j = 0; j < ROWS; j++) {
        if (i == 0  && j == 0) {
          newRow = table.addRow();
          newRow.setFloat("time", (float)(millis() - time_sec)/1000);
        }
        String id = "x" + str(j) + "y" + str(i);
        newRow.setInt(id, (int)pointGrid[i][j].getSmoothVal());
      }
    }
  }

  // For debug
  if (millis() - timerDataCounter0 > 1000) {
    // println("serial speed = ", int(1000 * dataCounter / (millis() - timerDataCounter0)), "data/seconde");
    timerDataCounter0 = millis();
    dataCounter = 0;
  }
}

void mouseClicked() {
  if (mouseX > button_x1 - button_d/2 && mouseX < button_x1 + button_d/2 && 
    mouseY > button_y1 - button_d/2 && mouseY < button_y1 + button_d/2) { 
    if (isOnOff) {
      isOnOff = false;
      play.displayOnOff(isOnOff);
      myPort.write('S'); //Stop sending data
    } else {
      isOnOff = true;
      play.displayOnOff(isOnOff);
      myPort.write('G'); //Go and start sending data
    }
  } 
  if (mouseX > button_x2 - button_d/2 && mouseX < button_x2 + button_d/2 && 
    mouseY > button_y2 - button_d/2 && mouseY < button_y2 + button_d/2) { 
    if (isRecording) {
      recordCount++;
      isRecording = false;
      rec.displayRecord(isRecording);
      String fileName = "data/record" + str(recordCount) + ".csv";
      saveTable(table, fileName);
      table.clearRows();
    } else {
      isRecording = true;
      time_sec = millis();
      rec.displayRecord(isRecording);
    }
  }
}

void serialEvent(Serial myPort) {
  String message = myPort.readStringUntil(13);

  if (message != null)
  {
    // println("-------------");
    println(message);
    serialData = message;
    //serialData = message.substring( 0, message.length()-1 ); // remove 'q' character
    myPort.clear();
  }
}
