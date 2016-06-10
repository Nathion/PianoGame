class MIDISong {

  int MIDIcommands; //the amount of commands in the midifile
  MIDINote [] MIDINotes;
  int [] keys;
  ArrayList<OccurenceKey> keyOccurences;
  int [] ticks;
  boolean [] keySwitch;
  int [] velocities;
  int inputID;
  int totalTicks;
  float tick;
  float speed;
  float originalSpeed;
  float eyeCorrection;
  boolean activeTickerNumberDisplay;
  int track;
  boolean [] activeTracks;
  int resolution;
  int resolutionCount;

  float screenUnitX;
  float screenUnitY;

  color colorNoteIdle;
  color colorNoteActive;
  color colorNoteHit;

  int cirkleSize;
  float xPosLine1;
  float yPosLine1;
  float xPosLine2;
  float yPosLine2;
  float xPosLine3;
  float yPosLine3;
  float xPosLine4;
  float yPosLine4;

  MIDISong(Sequence sequence, int _MIDIcommands) { //CONSTRUCTOR

    MIDIcommands=_MIDIcommands*3; //on AND off
    keys = new int[MIDIcommands];
    ticks = new int[MIDIcommands];
    keySwitch = new boolean[MIDIcommands];
    velocities = new int[MIDIcommands];
    originalSpeed = speed = 6.0;
    eyeCorrection = speed*20;

    colorNoteIdle = color(200, 200, 200);
    colorNoteActive = color (0, 256/2, 0);
    colorNoteHit = color(0, 0, 0);

    cirkleSize = 100;
    xPosLine1 = cos(0)*cirkleSize;
    yPosLine1 = sin(0)*cirkleSize;
    xPosLine2 = cos(PI/2)*cirkleSize;
    yPosLine2 = sin(PI/2)*cirkleSize;
    xPosLine3 = cos(PI)*cirkleSize;
    yPosLine3 = sin(PI)*cirkleSize;
    xPosLine4 = cos(PI/2*3)*cirkleSize;
    yPosLine4 = sin(PI/2*3)*cirkleSize;

    inputID = 0;
    int trackNumber = 0;

    int NOTE_ON = 0x90;
    int NOTE_OFF = 0x80;

    for (Track track : sequence.getTracks()) {
      //trackNumber++;
      resolution = sequence.getResolution();
      for (int i=0; i < track.size(); i++) { 
        MidiEvent event = track.get(i);
        MidiMessage message = event.getMessage();

        if (message instanceof ShortMessage) {
          ShortMessage sm = (ShortMessage) message;
          //print("Channel: " + sm.getChannel() + " ");

          if (sm.getCommand() == NOTE_ON) {
            keys [inputID] = sm.getData1();
            ticks [inputID] = int(event.getTick());////24.0
            keySwitch [inputID] = true;
            velocities [inputID] = sm.getData2();
            inputID ++;
          } else if (sm.getCommand() == NOTE_OFF) {
            keys [inputID] = sm.getData1();
            ticks [inputID] = int(event.getTick());////24.0
            keySwitch [inputID] = false;
            velocities [inputID] = sm.getData2();
            inputID ++;
          }
        }
      }
    }

    MIDINotes = new MIDINote[inputID/2];
    totalTicks = ticks[MIDINotes.length];
    screenUnitX = float(width)/float(totalTicks);
    screenUnitY = float(height)/totalNotes;
    resolutionCount = totalTicks/resolution;

    int counterID=0;
    int lastTick = 0;
    for (int keyinputID=0; keyinputID<inputID; keyinputID++) { 
      if (keySwitch[keyinputID]==true) {                                             //The beginning of a note

        int beginTick = ticks[keyinputID];

        for (int keyinputID2=keyinputID; keyinputID2<inputID; keyinputID2++) {         
          if (keySwitch[keyinputID2]==false&&keys[keyinputID]==keys[keyinputID2]) {  //The end of a note

            //println(ticks[keyinputID2]+" < "+ticks[keyinputID]);

            if (lastTick-100000>ticks[keyinputID2]) {
              track++;
            }
            int endTick = ticks[keyinputID2];

            MIDINotes[counterID] = new MIDINote(counterID, keys[keyinputID], beginTick, endTick, velocities[keyinputID], track);

            lastTick = ticks[keyinputID2];

            keyinputID2=inputID;                                                     //To prevent doubles
            counterID++;
          }
        }
      }
      //totalTicks = lastTick;
    }
    activeTracks = new boolean[track+1];
    for (int i=0; i<activeTracks.length; i++) {
      activeTracks[i] = true;
    }
    keyOccurences  = oc(MIDINotes);
  }
  
  ArrayList<OccurenceKey> oc(MIDINote[] MIDINotes){
    ArrayList<OccurenceKey> occurenceKeys = new ArrayList<OccurenceKey>();
    occurenceKeys.add(new OccurenceKey(MIDINotes[0].key));
    keyloop : for(int i = 1; i < MIDINotes.length; i++){
      for(int q = 0; q < occurenceKeys.size();q++){
        if(occurenceKeys.get(q).key == MIDINotes[i].key){
          occurenceKeys.get(q).oc++;
          continue keyloop;
        }
      }
      occurenceKeys.add(new OccurenceKey(MIDINotes[i].key));
    }
    return occurenceKeys;
  }


  void printNotes() {
    for (int i=0; i<MIDINotes.length; i++) {
      println("ID:"+MIDINotes[i].ID+" key:"+MIDINotes[i].key+" beg:"+MIDINotes[i].startTick+" end:"+MIDINotes[i].endTick+" vel:"+MIDINotes[i].velocity);
    }
  }

  void printMIDI() {
    for (int i = 0; i<MIDIcommands; i++) {
      println(i+": "+keys[i], ticks[i], keySwitch[i], velocities[i]);
    }
  }

  void playENTIRESong() {
    for (int tick=0; tick<totalTicks; tick++) {
      delay(30);
      for (int i=0; i<MIDINotes.length; i++) {
        if (tick == MIDINotes[i].startTick) {
          myBus.sendNoteOn(0, MIDINotes[i].key, MIDINotes[i].velocity); // Send a Midi noteOn
        } else if (tick == MIDINotes[i].endTick) {
          myBus.sendNoteOff(0, MIDINotes[i].key, MIDINotes[i].velocity); // Send a Midi noteOn
        }
      }
    }
  }

  void playNotes() {
    for (int i=0; i<MIDINotes.length; i++) {
      for (int j=0; j<speed; j++) {
        if (tick-j == MIDINotes[i].startTick&&activeTracks[MIDINotes[i].track]) {
          myBus.sendNoteOn(0, MIDINotes[i].key, MIDINotes[i].velocity); // Send a Midi noteOn
        } else if (tick == MIDINotes[i].endTick&&activeTracks[MIDINotes[i].track]) {
          myBus.sendNoteOff(0, MIDINotes[i].key, MIDINotes[i].velocity); // Send a Midi noteOn
        }
      }
    }
  }
  

  void updateTicker() {
    tick+=speed;
    /* REPLAY
    if (tick>=totalTicks) { //Is the song done?
      tick=0;
      stopMusic();
    }*/
  }

  void displayTicker() {
    stroke(1);
    line(tick*screenUnitX, 0, tick*screenUnitX, height);
  }

  void displayResolution() {
    stroke(1);
    for  (int i=0; i<resolutionCount; i++) {
      if (i % 4 == 0) {
        strokeWeight(2);
      } else {
        strokeWeight(1);
      }
      line(i*resolution*screenUnitX, 0, i*resolution*screenUnitX, height);
    }
  }

  void displayEntireSong(float yScale, int yLocation) {
    pushMatrix();
    translate(0, yLocation);
    fill(255);
    rect(0, 0, width, height);
    displayTicker();
    displayResolution();
    tickerNumberDisplay();
    for (MIDINote note : MIDINotes) {
      if (activeTracks[note.track]) {
        float xpos = screenUnitX*note.startTick;
        float xwid = screenUnitX*note.totalTicks;
        float ypos = (height-screenUnitY*note.key)*yScale;
        float ywid = screenUnitY*yScale;
        int restartInput = note.track*(200/(MIDINotes[MIDINotes.length-1].track+1))-256/2;

        //updateNotes(i, xpos, xpos+xwid, screenUnitX);/*
        if (note.active) {
          fill(0, 256/2-restartInput, restartInput);
        } else {
          fill(200, 200, 200);
        }
        noStroke();
        rectMode(CORNER);
        rect (xpos, ypos, xwid, ywid);

        fill(0, 256-track, restartInput);
        if (debug) {
          text(note.track, xpos, ypos);
        }
      }
    }
    stroke(1);
    line(0, 0, width, 0);
    line(0, height*yScale, width, height*yScale);
    popMatrix();
  }  

  void displayPartSong() {
    pushMatrix();
    translate(-tick*screenUnitX+100, 0);
    //displayTicker();
    //tickerNumberDisplay();
    displayResolution();
    for (MIDINote note : MIDINotes) {
      if (activeTracks[note.track]) {
        float xpos = screenUnitX*note.startTick;
        float xwid = screenUnitX*note.totalTicks;
        float ypos = height-screenUnitY*note.key;
        //println(MIDINotes[i].key);
        float ywid = screenUnitY;
        int restartInput = note.track*(200/(MIDINotes[MIDINotes.length-1].track+1))-256/2;

        color noteFill = noteColor(note, restartInput);
        fill (noteFill);

        noStroke();
        rectMode(CORNER);
        rect (xpos, ypos, xwid, ywid);

        if (debug) {
          fill(0, 256, 0);
          text(note.track, xpos, ypos);
        }
      }
    }
    popMatrix();
    stroke(1);
    line(100, 0, 100, height);
  }

  color noteColor (MIDINote note, int restartInput) {
    color noteFill;
    if (note.hit) {
      noteFill = colorNoteHit;
    } else if (note.active) {
      noteFill = colorNoteActive;
    } else {
      noteFill = colorNoteIdle;
    }
    return noteFill;
  }

  void displayTempoCircle() {
    float fullCircle = TWO_PI;
    float fullCircleTick = TWO_PI/resolution;
    float circleProgression = fullCircleTick*tick/4;
    float xPosTicker = cos(circleProgression)*cirkleSize;
    float yPosTicker = sin(circleProgression)*cirkleSize;
    int fourResolutions = resolution*4; //NEXT RESOLUTION VARIABLE

    pushMatrix();
    translate(width/2, height/2-100);
    rotate(TWO_PI/4*3); //rotation fix
    /////////////////BIG CIRKLE/////////////////
    fill(100, 100, 100);
    ellipse(0, 0, cirkleSize*2, cirkleSize*2);
    /////////////////TICKER LINE/////////////////
    line(0, 0, xPosTicker, yPosTicker);
    /////////////////HELP LINES/////////////////
    stroke(150, 150, 150);
    line(0, 0, xPosLine1, yPosLine1);
    line(0, 0, xPosLine2, yPosLine2);
    line(0, 0, xPosLine3, yPosLine3);
    line(0, 0, xPosLine4, yPosLine4);
    /////////////////NOTES DISPLAY/////////////////
    for (MIDINote note : MIDINotes) {
      if (activeTracks[note.track]) {
        for (int j=0; j<resolutionCount/4; j++) {
          int newResolution = j*resolution*4; //BEGINTICK RESOLUTION
          if (newResolution<tick&&newResolution+fourResolutions>tick) {
            /////////////////NOTES ACTIVE RESOLUTION/////////////////
            if (note.startTick>=newResolution
              &&note.startTick<newResolution+fourResolutions) {
              float circleProgressionNote = (fullCircleTick*note.startTick/4);
              float xPosNote = cos(circleProgressionNote)*cirkleSize;
              float yPosNote = sin(circleProgressionNote)*cirkleSize;
              fill(200, 100, 100, 255);
              ellipse(xPosNote, yPosNote, note.velocity, note.velocity);
            }
            /////////////////NOTES NEXT RESOLUTION/////////////////
            else if (note.startTick>=newResolution+fourResolutions
              &&note.startTick<newResolution+fourResolutions+resolution) {
              float circleProgressionNote = (fullCircleTick*note.startTick/4);
              float xPosNote = cos(circleProgressionNote)*cirkleSize;
              float yPosNote = sin(circleProgressionNote)*cirkleSize;
              fill(200, 100, 100, 100);
              ellipse(xPosNote, yPosNote, 20, 20);
            }
            /////////////////NOTES NEXTx2 RESOLUTION/////////////////
            else if (note.startTick>=newResolution+fourResolutions+resolution
              &&note.startTick<newResolution+fourResolutions/2) {
              float circleProgressionNote = (fullCircleTick*note.startTick/4);
              float xPosNote = cos(circleProgressionNote)*cirkleSize;
              float yPosNote = sin(circleProgressionNote)*cirkleSize;
              fill(200, 100, 100, 0);
              ellipse(xPosNote, yPosNote, 20, 20);
            }
          }
        }
      }
    }
    popMatrix();
  }

  boolean hitNote(float pos, float pos2, float screenUnit) {
    if (tick*screenUnit>=pos-1&&tick*screenUnit<=pos2) {
      return true;
    } else {
      return false;
    }
  }

  void updateNotes() {
    for (int i=0; i<MIDINotes.length; i++) {
      float pos = screenUnitX*MIDINotes[i].startTick;
      float pos2 = screenUnitX*MIDINotes[i].endTick;
      if (tick*screenUnitX>=pos-1&&tick*screenUnitX<=pos2) {
        MIDINotes[i].active=true;
      } else {
        MIDINotes[i].active=false;
      }
    }
  }

  void stopMusic() {
    for (int i=0; i<inputID; i++) {
      myBus.sendNoteOff(0, MIDIsongs[0].keys[i], MIDIsongs[0].velocities[i]); // Stop everything when the song is over
    }
  }

  void tickerNumberDisplay() {
    if (activeTickerNumberDisplay) {
      fill(0);
      text(tick, mouseX, mouseY);
    }
  }
}