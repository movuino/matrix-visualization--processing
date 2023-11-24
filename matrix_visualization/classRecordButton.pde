class RecordButton{
  // CENTRE COORDINATES
  private int x_;      // X coordinate of the centre of the button
  private int y_;      // Y coordinate of the centre of the button
  
  private int d_ = 0;
  private boolean isOn_ = false;
  private boolean isRecord_;
  //PLAY triangle vertices coordinates
  private int x1, y1, x2, y2, x3, y3; 
  //STOP square parameters
  private int ax, ay, aw, ah; 
  //RECORD circle parameters
  private int bx, by, bd;
  
  RecordButton(int x, int y, int d){
    this.x_ = x;
    this.y_ = y;
    this.d_ = d;
    // PLAY triangle
    this.x1 = this.x_ - this.d_/4;
    this.y1 = this.y_ - this.d_/4;
    this.x2 = this.x_ - this.d_/4;
    this.y2 = this.y_ + this.d_/4;
    this.x3 = this.x_ + this.d_/4;
    this.y3 = this.y_;
    // STOP square 
    this.ax = this.x_ - this.d_/4;
    this.ay = this.y_ - this.d_/4;
    this.aw = this.d_/2;
    this.ah = this.d_/2;
    // RECORD circle
    this.bx = this.x_;
    this.by = this.y_;
    this.bd = this.d_/3;
    
  }
  
  void displayOnOff (boolean isOn){
    this.isOn_ = isOn;
    if(!this.isOn_){
     fill(green);
     ellipse(this.x_, this.y_, this.d_, this.d_);
     fill(white);
     triangle(this.x1, this.y1, this.x2, this.y2, this.x3, this.y3);
    }
    else{
     fill(red);
     ellipse(this.x_, this.y_, this.d_, this.d_);
     fill(white);
     rect(this.ax, this.ay, this.aw, this.ah);
    }
  }
  
  void displayRecord (boolean isRecord){
    this.isRecord_ = isRecord;
    if(!this.isRecord_){
     fill(white);
     ellipse(this.x_, this.y_, this.d_, this.d_);
     fill(red);
     ellipse(this.bx, this.by, this.bd, this.bd);
    }
    else{
     fill(red);
     ellipse(this.x_, this.y_, this.d_, this.d_);
     fill(white);
     ellipse(this.bx, this.by, this.bd, this.bd);
    }
  }
  
}
