import javax.sound.midi.*;
import themidibus.*;
//Import other java libraries - WHAT DO THEY DO?
import java.util.ArrayList;
import java.util.List;
import java.io.*;

//MIDI things
MIDISong[] MIDIsongs;
MidiBus myBus;

MidiHandler midiHandler;

boolean playing = true;
boolean debug;
String H = "HIT!";

int levels = 6;
Level lvls[] = new Level [levels];
int activeLevel = 1;
int activeSong = 2;
int activeTrack = 0;
boolean trackSelector;
int totalNotes = 84;
boolean keyz[] = new boolean [totalNotes+1];

void setup() {
  size(1000, 800);
  smooth();//fullScreen();

  /////////////////LOADING SONGS/////////////////
  int MIDIfilesAmount = countFiles("E:/Bachelor Assignment/Processing/MIDI_files/");
  File [] file = new File[MIDIfilesAmount]; //Create array with midifiles
  Sequence [] sequences = new Sequence[MIDIfilesAmount];
  MIDIsongs = new MIDISong[MIDIfilesAmount];
  MIDIsonginator(file, sequences, 0, "E:/Bachelor Assignment/Processing/MIDI_files/1492_Conquest_of_Paradise.mid");
  MIDIsonginator(file, sequences, 1, "E:/Bachelor Assignment/Processing/MIDI_files/test1.mid");
  MIDIsonginator(file, sequences, 2, "E:/Bachelor Assignment/Processing/MIDI_files/MiddleEastern.mid");
  MIDIsonginator(file, sequences, 3, "E:/Bachelor Assignment/Processing/MIDI_files/six_eight.mid");
  MIDIsonginator(file, sequences, 4, "E:/Bachelor Assignment/Processing/MIDI_files/4beat.mid");

  /////////////////SETTING MIDI BUS/////////////////
  //MidiBus.list(); //Print MIDI devices
  myBus = new MidiBus(this, 0, 2); //To send and receive information from other midi controllers

  /////////////////LEVELS/////////////////
  lvls[0] = new Level(color(30, 60, 200)); 
  lvls[1] = new Level(color(200, 100, 0));
  lvls[2] = new Level(color(200, 100, 255));
  lvls[3] = new Level(color(100, 200, 255));
  lvls[4] = new Level(color(200, 0, 0));
  lvls[5] = new Level(color(150, 150, 0));

  /////////////////OTHER/////////////////
  midiHandler = new MidiHandler(); //MIDIHandler registers objects that want to bind actions to MIDI and makes their MIDIresponders for them with the help of MIDIListener.
  //MIDIinfo(sequences[2]);
}

void draw() {
  background(255);

  /////////////////LEVELS/////////////////
  lvls[activeLevel].display();
  lvls[activeLevel].game(activeLevel);

  /////////////////PLAYER/////////////////
  MIDIsongs[activeSong].updateNotes();
  MIDIsongs[activeSong].updateTicker();
  MIDIsongs[activeSong].playNotes();

  /////////////////DISPLAYS/////////////////
  MIDIsongs[activeSong].displayPartSong();
  MIDIsongs[activeSong].displayEntireSong(0.25, 600);
  MIDIsongs[activeSong].displayTempoCircle();

  /////////////////DEBUGTEXT/////////////////
  fill(255, 102, 153);
  if (debug) {
    text("Level :" + activeLevel, 10, 30);
  }
}