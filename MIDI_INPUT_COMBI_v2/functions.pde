void mouseClicked() {
  MIDIsongs[activeSong].tick=int(float(mouseX)/float(width)*float(MIDIsongs[activeSong].totalTicks));
}

void mouseDragged() {
  MIDIsongs[activeSong].speed=0;
  MIDIsongs[activeSong].tick=int(float(mouseX)/float(width)*float(MIDIsongs[activeSong].totalTicks));
}

void mouseReleased() {
  MIDIsongs[activeSong].speed=MIDIsongs[0].originalSpeed;
  MIDIsongs[activeSong].activeTickerNumberDisplay=false;
}

void mousePressed() {
  MIDIsongs[activeSong].activeTickerNumberDisplay=true;
}

void keyPressed() {
  if (int(key)==1+48||int(key)==2+48||int(key)==3+48||int(key)==4+48||int(key)==5+48) {
    MIDIsongs[activeSong].stopMusic();
    activeSong=int(key)-49;
    MIDIsongs[activeSong].tick=0;
    trackSelector=false;
    activeTrack = 0;
  }

  if (key=='a'&&trackSelector==false) {
    activeTrack = 0;
    for (int i=activeTrack+1; i<MIDIsongs[activeSong].activeTracks.length; i++) {
      MIDIsongs[activeSong].activeTracks[i]=false;
      trackSelector=true;
    }
  } else if (key=='a'&&trackSelector==true) {
    for (int i=0; i<MIDIsongs[activeSong].activeTracks.length; i++) {
      MIDIsongs[activeSong].activeTracks[i]=true;
      trackSelector=false;
    }
  }
  if (keyCode==UP&&trackSelector) {
    MIDIsongs[activeSong].activeTracks[activeTrack]=false;
    if (MIDIsongs[activeSong].activeTracks.length>activeTrack+1) {
      activeTrack++;
    } else if (MIDIsongs[activeSong].activeTracks.length<=activeTrack+1) {
      activeTrack=0;
    }
    MIDIsongs[activeSong].activeTracks[activeTrack]=true;
  } else if (keyCode==DOWN&&trackSelector) {
    MIDIsongs[activeSong].activeTracks[activeTrack]=false;
    if (activeTrack>0) {
      activeTrack--;
    } else if (activeTrack<=0) {
      activeTrack=MIDIsongs[activeSong].activeTracks.length-1;
    }
    MIDIsongs[activeSong].activeTracks[activeTrack]=true;
  }
  if (key == CODED) {
    if (keyCode == RIGHT) {
      activeLevel++;
      if (activeLevel>=levels) {
        activeLevel=0;
      }
    } else if (keyCode == LEFT) {
      activeLevel--;
      if (activeLevel<0) {
        activeLevel=levels-1;
      }
    }
  }
  if (key == ' '&&playing) {
    pause();
    playing=false;
  } else if (key == ' '&&playing==false) {
    play();
    playing=true;
  }
  if (key == 'd') {  //ENTER DEBUG MODE
    if (debug) {
      debug = false;
    } else {
      debug=true;
    };
  }
}

void play() {
  MIDIsongs[activeSong].speed=0;
}

void pause () {
  MIDIsongs[activeSong].speed=MIDIsongs[0].originalSpeed;
}

int countFiles(String map) { //Count the amount of files there are in a map, mostly meant for MIDI files
  File theDir = new File(map);
  String[] theList = theDir.list();
  int fileCount = theList.length;
  //println("[" + map + "] contains " + str(fileCount) + " file(s)");
  return fileCount;
}