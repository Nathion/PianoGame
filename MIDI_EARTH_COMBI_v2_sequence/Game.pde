class Game {
  int activeLevel;
  int activeLevelSequence;
  int activeSong;
  int activeTrack;

  int pauseTime;

  //Rotating Earth variable
  float xpos;

  Game() { //CONSTRUCTOR
    activeLevel = 0;
    activeLevelSequence = 0;
    activeSong = 0;
    activeTrack = 0;

    pauseTime = 300;

    xpos = 0.0;
  }

  void update() {

    //Update game stats
    ///////
    //Update player stats
    ///////

    //Update the buttons
    for (int i=0; i<buttons.length; i++) {
      buttons[i].activityUpdate();
      buttons[i].placeUpdate(xpos);
    }
    if (activeLevel==1) {
      if (activeLevelSequence==0) {
        activeSong=5;
        MIDIsongs[activeSong].updateNotes();
        MIDIsongs[activeSong].updateTicker();
        MIDIsongs[activeSong].playNotes();
        if (MIDIsongs[activeSong].tick>=MIDIsongs[activeSong].totalTicks) {
          activeLevelSequence++;
          MIDIsongs[activeSong].tick=0;
        }
      }
      if (activeLevelSequence==1) {
        activeSong=5;
        MIDIsongs[activeSong].updateNotes();
        MIDIsongs[activeSong].updateTicker();
        MIDIsongs[activeSong].playNotes();
        if (MIDIsongs[activeSong].tick>=MIDIsongs[activeSong].totalTicks) {
          activeLevelSequence++;
          MIDIsongs[activeSong].tick=0;
        }
      }
      if (activeLevelSequence==2) {
        activeSong=1;
        MIDIsongs[activeSong].updateNotes();
        MIDIsongs[activeSong].updateTicker();
        MIDIsongs[activeSong].playNotes();
        if (MIDIsongs[activeSong].tick>=MIDIsongs[activeSong].totalTicks) {
          activeLevel = 0;
          activeLevelSequence = 0;
          MIDIsongs[activeSong].tick=0;
        }
      }
    }
  }
  void display() {
    //Display the earth
    if (activeLevel==0) {
      spinner(earthIMG);
      //Display the buttons
      for (int i=0; i<buttons.length; i++) {
        buttons[i].display();
        if (debug == true) {
          debugDisplay();
        }
      }
      image(earthSpaceIMG, 0, 0);
    }
    if (activeLevel==1&&activeLevelSequence==0||activeLevelSequence==1) {
      MIDIsongs[activeSong].displayTempoCircle();
      MIDIsongs[activeSong].displayEntireSong(0.25, 600);
    }
    if (activeLevel==1&&activeLevelSequence==2) {
      MIDIsongs[activeSong].displayPartSong();
      MIDIsongs[activeSong].displayEntireSong(0.25, 600);
    }
  }

  void levelColor(int levelCurrent, int miniCurrent) { //Change the color of the background according to the number
    background(levelCurrent*50, 0, miniCurrent*50);
  }

  void spinner(PImage picture) {

    float planeToWidth = width/float(picture.width);
    int planesAmount = ceil(planeToWidth)+2;
    float rotatingSpeed = mouseX/15-width/30;
    xpos-=rotatingSpeed;
    for (int i=0; i<planesAmount; i++) {
      image(picture, xpos-picture.width+picture.width*i, 0);
    }
    if (xpos<-picture.width) {
      xpos=0;
    }
    if (xpos>width) {
      xpos=-(picture.width-width);
    }
  }
}