public class ArduinoSerial implements Runnable {
  Thread thread;
  private long timer0;

  public ArduinoSerial() {
    timer0 = millis();
  }

  public void start() {
    thread = new Thread(this);
    thread.start();
  }

  public void run() {
    while (true) {
      // Update values based on incoming serial messages
      String serialData_ = serialData;

      if (serialData_ != "" && serialData_.length() > 1) {
        
        String[] arrayData_ = serialData_.split("\n");

        for (int i=0; i < arrayData_.length; i++) {
          String data_ = arrayData_[i];

          if (data_ != "" && data_.length() > 1) {
            data_ = data_.trim();
            if (data_.length() > 1) {
              char adr_ = data_.charAt(0);
              if (data_.length() > 3) {
                data_ = data_.substring(1, data_.length());

                switch(adr_) {
                case 'z' :
                  // GET COORDINATES
                  int[] rowtouch_ = int(split(data_, 'x'));
                  if (rowtouch_.length == COLS + 1) {
                    int rowIndex_ = int(rowtouch_[0]);

                    for (int j = 0; j < COLS; j++) {
                      pointGrid[j][rowIndex_].pushNewRawVal(rowtouch_[j+1]);
                      // println(rowIndex_ + " " + j + " = " + rowtouch_[j+1]); // debug
                    }
                  }
                  dataCounter++;
                  break;
                default:
                  break;
                }
              }
            }
          }
        }
        serialData = "";
      }
      delay(1);
    }
  }

  public void stop() {
    thread = null;
  }
}
