class Level { 
  color col;
  float tempo;
  float accTempo;
  double timer;
  float targetRotation1;
  float targetRotation2;

  //CONSTRUCTOR
  Level(color _col) { 
    col = _col;
    tempo = 0;
    accTempo = 0.005;
    timer = 0;
    targetRotation1 = 0;
    targetRotation2 = 0;
  }

  void display() {
    background(col);
  }


  void inputVisualizer(int activeLevel) {
    /////////////////LEVEL0/////////////////
    if (activeLevel==0) {
      for (int i = 0; i < totalNotes; i++) {
        if (keyz[i]) {
          float barWidth = width/(float(totalNotes));
          fill(color(i*10, 0, i*5));
          rect(i*barWidth, 0, barWidth, height);
        }
      }
    }
    /////////////////LEVEL1/////////////////
    else if (activeLevel==1) {
      for (int i = 0; i < keyz.length; i++) {
        if (keyz[i]) {
          int barHeight = height/totalNotes;
          fill(color(i*10, 0, i*5));
          //rect(0, height-i*barHeight, width, barHeight);
          rect(0, height-(i*barHeight+52*barHeight), width, barHeight);
          //ypos = height-screenUnitY*MIDINotes[i].key;
          //println("key"+i);
        }
      }
    }
    /////////////////LEVEL2/////////////////
    else if (activeLevel==2) {
      for (int i = 0; i < keyz.length; i++) {
        if (keyz[i]) {
          //print(i);
          int barHeight = height/totalNotes;
          fill(color(1, 0, i*5, 0.5));
          ellipse(width-width/2, height-height/2, 1.5*i*barHeight+barHeight, 1.5*i*barHeight+barHeight);
        }
      }
    }
    /////////////////LEVEL3/////////////////
    else if (activeLevel==3) {

      int barHeight = height/totalNotes;
      fill(color(1, 0, 0, 0.5));

      pushMatrix();
      translate(width/2, height/2);
      ellipse(0, 0, 500, 500);
      tempo+=accTempo;
      rotate(tempo);
      line(0, 0, 0, 270);
      for (int i = 0; i < keyz.length; i++) {
        if (keyz[i]) {
          ellipse(0, 270, i*100+100, i*100+100);
        }
      }
      popMatrix();

      //HIT THESE
      fill(0);
      ellipse(width/2, height/2-250, 10, 10);
      ellipse(width/2-250, height/2, 10, 10);
      ellipse(width/2, height/2+250, 10, 10);
      ellipse(width/2+250, height/2, 10, 10);
    }
    /////////////////LEVEL4/////////////////
    else if (activeLevel==4) {

      int barHeight = height/totalNotes;
      fill(color(1, 0, 0, 0.5));

      pushMatrix();
      translate(width/2, height/2);
      ellipse(0, 0, 500, 500);
      tempo+=accTempo;
      rotate(tempo);
      line(0, 0, 0, -270);
      for (int i = 0; i < keyz.length; i++) {
        if (keyz[i]) {
          ellipse(0, -270, i*100+100, i*100+100);
        }
      }
      popMatrix();
      timer+=tempo;

      //HIT THESE RANDOMIZED(at timer=2000)
      pushMatrix();
      translate(width/2, height/2);
      rotate(PI/4);
      fill(0);
      ellipse(0, -250, 10, 10);
      ellipse(-250, 0, 10, 10);
      ellipse(0, 250, 10, 10);
      ellipse(250, 0, 10, 10);
      popMatrix();
      pushMatrix();
      translate(width/2, height/2);
      rotate(PI/2);
      fill(0);
      ellipse(0, -250, 10, 10);
      ellipse(0, 250, 10, 10);
      popMatrix();
    }
    /////////////////LEVEL5/////////////////
    else if (activeLevel==5) {

      int barHeight = height/totalNotes;
      fill(color(1, 0, 0, 0.5));

      pushMatrix();
      translate(width/2, height/2);
      ellipse(0, 0, 500, 500);
      tempo+=accTempo;
      rotate(tempo);
      line(0, 0, 0, -270);
      for (int i = 0; i < keyz.length; i++) {
        if (keyz[i]) {
          ellipse(0, -270, i*100+100, i*100+100);
        }
      }
      popMatrix();
      //print (",   tempo:"+tempo);
      if (tempo >= 6.35) {
        tempo=0;
        targetRotation1 = random(TWO_PI);
        targetRotation2 = random(TWO_PI);
      }

      //HIT THESE RANDOMIZED(at timer=2000)
      pushMatrix();
      translate(width/2, height/2);
      rotate(PI/4+targetRotation1);
      fill(0);
      ellipse(0, -250, 10, 10);
      ellipse(-250, 0, 10, 10);
      ellipse(0, 250, 10, 10);
      ellipse(250, 0, 10, 10);
      popMatrix();
      pushMatrix();
      translate(width/2, height/2);
      rotate(PI/2+targetRotation2);
      fill(0);
      ellipse(0, -250, 10, 10);
      ellipse(0, 250, 10, 10);
      popMatrix();
    }
  }
}