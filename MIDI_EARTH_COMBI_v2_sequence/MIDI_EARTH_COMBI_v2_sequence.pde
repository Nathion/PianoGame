import javax.sound.midi.*;
import themidibus.*;
import java.util.ArrayList;
import java.util.List;
import java.io.*;

//MIDI things
MIDISong[] MIDIsongs;
MidiBus myBus;

MidiHandler midiHandler;

boolean playing = true;
boolean songTool = false;
boolean debug;

int levels = 6;
Level lvls[] = new Level [levels];
boolean trackSelector;
int lowestKey = 36;
int highestKey = 84;
int totalNotes = highestKey - lowestKey + 1;
boolean keyz[] = new boolean [totalNotes];

Game game; //Game class has all the functions and properties of the game
//GamePlayStats gameplayStats; //Simple class that keeps track of game statistics
PlayerStats playerStats; //Simple class that keeps track of player statistics
Button[] buttons = new Button[4];
int levelAmount; //The amount of levels
int actAmount; //The amout of minigames each level has
PImage earthIMG;
PImage earthSpaceIMG;

void setup() {
  size(1000, 900);
  //fullScreen();
  smooth();

  /////////////////LOADING SONGS/////////////////
  int MIDIfilesAmount = countFiles(sketchFile("")+"/MIDI_files/");
  File [] file = new File[MIDIfilesAmount]; //Create array with midifiles
  Sequence [] sequences = new Sequence[MIDIfilesAmount];
  MIDIsongs = new MIDISong[MIDIfilesAmount];
  MIDIsonginator(file, sequences, 0, sketchFile("")+"/MIDI_files/test1.mid");
  MIDIsonginator(file, sequences, 1, sketchFile("")+"/MIDI_files/test1.mid");
  MIDIsonginator(file, sequences, 2, sketchFile("")+"/MIDI_files/MiddleEastern.mid");
  MIDIsonginator(file, sequences, 3, sketchFile("")+"/MIDI_files/six_eight.mid");
  MIDIsonginator(file, sequences, 4, sketchFile("")+"/MIDI_files/4beat.mid");
  MIDIsonginator(file, sequences, 5, sketchFile("")+"/MIDI_files/4beatVelocityTest.mid");

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

  game = new Game();
  //gameplayStats = new GamePlayStats();
  playerStats = new PlayerStats();
  //Creating buttons
  buttons = new Button[4];
  //directory, xpos, ypos, size
  buttons[0] = new Button(0, 10, height-20, 20);
  buttons[1] = new Button(1, width*0.3, height*0.4, 200);
  buttons[2] = new Button(2, width*0.77, height*0.27, 20);
  buttons[3] = new Button(3, width*1.35, height*0.30, 20);
  levelAmount = 3;
  actAmount = 3; 
  earthIMG = loadImage(sketchFile("")+"/IMG_files/Earth.jpg");
  earthSpaceIMG = loadImage(sketchFile("")+"/IMG_files/EarthSpace.png");
  earthIMG.resize(0, height);
  earthSpaceIMG.resize(width, height);
}

void draw() {
  background(255);
  
  lvls[0].inputVisualizer(0);
  
  /////////////////LEVELS/////////////////
  //lvls[activeLevel].display();
  //lvls[activeLevel].game(activeLevel);
  game.update();
  game.display();

  /////////////////DEBUGTEXT/////////////////
  fill(255, 102, 153);
  if (debug) {
    text("Level :" + game.activeLevel, 10, 30);
  }
  
  if (game.activeLevel!=0&&songTool==false){
    songTool=true;
  }  
}