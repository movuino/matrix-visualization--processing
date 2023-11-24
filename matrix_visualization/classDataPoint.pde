class DataPoint {
  // COORDINATES
  public float X;      // X coordinate of the data point
  public float Y;      // Y coordinate of the data point
  
  // TO REMOVE
  public int indRow;
  public int indCol;

  // DATA VALUES
  private IntList rawVals;               // array list to store each new incoming raw data
  private int N = 3;                    // size of the list
  private float curSmoothVal = 0.0;      // current smooth data = mean of the current raw data list

  DataPoint(int indCol_, int indRow_) {
    // Compute center of data point coordinated based on row and column index
    //float w_ = COLS * maxDiameter;
    //float h_ = ROWS * maxDiameter;
    //float x0 = (width - w_)/2. + maxDiameter/2.;
    //float y0 = (height - h_)/2. + maxDiameter/2.;
    //this.X = x0 + indCol_ * maxDiameter;
    //this.Y = y0 + indRow_ * maxDiameter;

    int panning_ = 50;
    float w_ = width - 2 * panning_;
    float h_ = height - 2 * panning_;
    this.X = panning_ + (indCol_)/float(COLS-1) * w_;
    this.Y = panning_ + h_ * (1 - (indRow_)/float(ROWS-1));
    
    this.indRow = indRow_;
    this.indCol = indCol_;

    this.rawVals = new IntList(); // initialize raw data list
  }

  //----------------------------------------------------------------------------

  public void pushNewRawVal(int rawVal_) {
    // Add a new raw data value in the list
    if (rawVal_ > 0) {
      this.rawVals.append(rawVal_); // add new raw value
    } else {
      this.rawVals.append(0);       // value can not be negative, so default = 0
    }

    while (this.rawVals.size() > N) {
      this.rawVals.remove(0);       // remove older data from the list
    }

    if (this.rawVals.size() > 0) {
      this.getSmoothVal();          // call function to smooth raw data
    }
  }

  //----------------------------------------------------------------------------
  public float getSmoothVal() {
    // Compute mean of last N incoming data
    int meanVal_ = 0;
    for (int i=0; i < this.rawVals.size(); i++) {
      meanVal_ += this.rawVals.get(i);
    }
    this.curSmoothVal = meanVal_ / float(this.rawVals.size());
    return this.curSmoothVal;
  }

  //----------------------------------------------------------------------------

  void display(int maxValue_, int maxDiameter_) {
    float relativeVal_ = this.curSmoothVal / float(maxValue_);
    relativeVal_ = constrain(relativeVal_, 0.0, 1.0);

    fill(getLerpColor(relativeVal_)); // get color point
    noStroke();
    float d_ = relativeVal_ * maxDiameter_;
    ellipse(this.X, this.Y, d_, d_);
    // ellipse(this.X, this.Y, 2 + this.indCol, 2 + this.indRow);
  }

  //----------------------------------------------------------------------------

  color getLerpColor(float amt_) {
    // Set the color of the data point based on its value
    color newColor_ = purple;
    if (amt_ > 0.5) {
      // shade from yellow to red if value between .5 and 1.0
      newColor_ = lerpColor(yellow, red, 2*(amt_ - 0.5));
    } else {
      // shade from blue to yellow if value between .0 and .5
      newColor_ = lerpColor(green, yellow, 2*amt_);
    }
    return newColor_;
  }
}
