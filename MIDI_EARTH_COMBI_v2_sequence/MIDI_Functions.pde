File MIDIload (String _MIDIfilename) {
  String MIDIfilename = _MIDIfilename; //Import MIDI data and put it in a string
  return new File(MIDIfilename); //Save string as file
}

//voeg al deze dingen samen
Sequence MIDIsequences (File file) {
  Sequence s = null;
  try {
    s = MidiSystem.getSequence(file);
  }
  catch(Exception e) {
    System.err.println("Er gingen dingen stuk in MIDIsequence: " + e.getMessage());
  }
  return s;
}

InputStream MIDIinputStreamCreator (File file) {
  InputStream inputStream = null;
  try {
    inputStream = new BufferedInputStream(new FileInputStream(file));
  }
  catch(Exception e) {
    System.err.println("Er gingen dingen stuk in MIDIinputStreamCreator: " + e.getMessage());
  }
  return inputStream;
}

Sequencer MIDISequencer () {
  Sequencer sequencer = null;
  try {
    sequencer = MidiSystem.getSequencer();
  }
  catch(Exception e) {
    System.err.println("Er gingen dingen stuk in MIDISequencer: " + e.getMessage());
  }
  return sequencer;
}

void MIDIplay(InputStream inputStream, Sequencer sequencer) {
  try {
    sequencer.open();
    sequencer.setSequence(inputStream);
    //delay(500); //Because here the program slows down and slurt the first note
    sequencer.start();
  }
  catch(Exception e) {
    System.err.println("Er gingen dingen stuk in MIDIplay: " + e.getMessage());
  }
}

void MIDIinfo(Sequence sequence) {
  println("Division type: " + sequence.getDivisionType());
  println("Duration (microsec): " + sequence.getMicrosecondLength());
  println("Resolution: " + sequence.getResolution());
  println("Duration (ticks): " + sequence.getTickLength());
  Track[] tracks = sequence.getTracks();
  println("Tracks: " + tracks.length);
  for (int i = 0; i < tracks.length; i++) {
    Track t = tracks[i];
    println("  Track " + (i+1));
    println("    Notes: " + (t.size()/3));
    println("    Events: " + t.size());
    println("    Duration (ticks): " + t.ticks());
  }
}

int MIDInotesAmount (Sequence sequence) {
  int total = 0;
  Track[] tracks = sequence.getTracks();
  for (int i = 0; i < tracks.length; i++) {
    total += tracks[i].size()/3;
  }
  return total;
}

void MIDInotes(Sequence sequence) {
  String[] NOTE_NAMES = {"C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"};
  int NOTE_ON = 0x90;
  int NOTE_OFF = 0x80;
  int trackNumber = 0;
  for (Track track : sequence.getTracks()) {
    trackNumber++;
    System.out.println("Track " + trackNumber + ": size = " + track.size());
    System.out.println();
    for (int i=0; i < track.size(); i++) { 
      MidiEvent event = track.get(i);
      System.out.print("@" + event.getTick() + " ");
      MidiMessage message = event.getMessage();
      if (message instanceof ShortMessage) {
        ShortMessage sm = (ShortMessage) message;
        System.out.print("Channel: " + sm.getChannel() + " ");
        if (sm.getCommand() == NOTE_ON) {
          int key = sm.getData1();
          int octave = (key / 12)-1;
          int note = key % 12;
          String noteName = NOTE_NAMES[note];
          int velocities = sm.getData2();
          System.out.println("Note on, " + noteName + octave + " key=" + key + " velocities: " + velocities);
        } else if (sm.getCommand() == NOTE_OFF) {
          int key = sm.getData1();
          int octave = (key / 12)-1;
          int note = key % 12;
          String noteName = NOTE_NAMES[note];
          int velocities = sm.getData2();
          System.out.println("Note off, " + noteName + octave + " key=" + key + " velocities: " + velocities);
        } else {
          System.out.println("Command:" + sm.getCommand());
        }
      } else {
        System.out.println("Other message: " + message.getClass());
      }
    }
    System.out.println();
  }
}

void MIDIsonginator(File [] MIDIarray, Sequence [] MIDIsequences, int ID, String location) {
  MIDIarray[ID] = MIDIload (location);
  MIDIsequences [ID] = MIDIsequences(MIDIarray[ID]);
  MIDIsongs[ID] = new MIDISong(MIDIsequences[ID], MIDInotesAmount(MIDIsequences[ID]));
}