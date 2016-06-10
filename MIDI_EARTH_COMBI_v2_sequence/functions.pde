void mouseClicked() {
  if (songTool) {
    MIDIsongs[game.activeSong].tick=int(float(mouseX)/float(width)*float(MIDIsongs[game.activeSong].totalTicks));
  }
}

void mouseDragged() {
  if (songTool) {
    MIDIsongs[game.activeSong].speed=0;
    MIDIsongs[game.activeSong].tick=int(float(mouseX)/float(width)*float(MIDIsongs[game.activeSong].totalTicks));
  }
}

void mouseReleased() {
  if (songTool) {
    MIDIsongs[game.activeSong].speed=MIDIsongs[0].originalSpeed;
    MIDIsongs[game.activeSong].activeTickerNumberDisplay=false;
  }
  for (int i=0; i<buttons.length; i++) { //CLICKING ON BUTTON
    if (buttons[i].hover()) {
      game.activeLevel=i;
    }
  }
}

void mousePressed() {
  if (songTool) {
    MIDIsongs[game.activeSong].activeTickerNumberDisplay=true;
  }
}

void keyPressed() {
  if (songTool) {
    if (int(key)==1+48||int(key)==2+48||int(key)==3+48||int(key)==4+48||int(key)==5+48) {
      MIDIsongs[game.activeSong].stopMusic();
      game.activeSong=int(key)-49;
      MIDIsongs[game.activeSong].tick=0;
      trackSelector=false;
      game.activeTrack=0;
    }

    if (key=='a'&&trackSelector==false) {
      game.activeTrack=0;
      for (int i=game.activeTrack+1; i<MIDIsongs[game.activeSong].activeTracks.length; i++) {
        MIDIsongs[game.activeSong].activeTracks[i]=false;
        trackSelector=true;
      }
    } else if (key=='a'&&trackSelector==true) {
      for (int i=0; i<MIDIsongs[game.activeSong].activeTracks.length; i++) {
        MIDIsongs[game.activeSong].activeTracks[i]=true;
        trackSelector=false;
      }
    }
    if (keyCode==UP&&trackSelector) {
      MIDIsongs[game.activeSong].activeTracks[game.activeTrack]=false;
      if (MIDIsongs[game.activeSong].activeTracks.length>game.activeTrack+1) {
        game.activeTrack++;
      } else if (MIDIsongs[game.activeSong].activeTracks.length<=game.activeTrack+1) {
        game.activeTrack=0;
      }
      MIDIsongs[game.activeSong].activeTracks[game.activeTrack]=true;
    } else if (keyCode==DOWN&&trackSelector) {
      MIDIsongs[game.activeSong].activeTracks[game.activeTrack]=false;
      if (game.activeTrack>0) {
        game.activeTrack--;
      } else if (game.activeTrack<=0) {
        game.activeTrack=MIDIsongs[game.activeSong].activeTracks.length-1;
      }
      MIDIsongs[game.activeSong].activeTracks[game.activeTrack]=true;
    }
  }
  if (key == CODED) {
    if (keyCode == RIGHT) {
      game.activeLevel++;
      if (game.activeLevel>=levels) {
        game.activeLevel=0;
      }
    } else if (keyCode == LEFT) {
      game.activeLevel--;
      if (game.activeLevel<0) {
        game.activeLevel=levels-1;
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
    }
  }
  if (key == 'm') {  //ENTER MENU MODE
    game.activeLevel = 0;
  }
}

void play() {
  MIDIsongs[game.activeSong].speed=0;
}

void pause () {
  MIDIsongs[game.activeSong].speed=MIDIsongs[0].originalSpeed;
}

void debugDisplay() { //DEBUG MODE
  text("Score: " + playerStats.score, 10, 20);
  text("Level: " + game.activeLevel, 10, 40);
  text("Current minigame: " + game.activeLevel, 10, 60);
}

int countFiles(String map) { //Count the amount of files there are in a map, mostly meant for MIDI files
  File theDir = new File(map);
  String[] theList = theDir.list();
  int fileCount = theList.length;
  //println("[" + map + "] contains " + str(fileCount) + " file(s)");
  return fileCount;
}

void h() {
  println("HIT!");
}