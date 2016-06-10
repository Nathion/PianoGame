class MIDINote {
  int ID;
  int key;
  int startTick;
  int endTick;
  int velocity;
  int totalTicks;
  boolean active;
  int track;
  boolean hit;
  boolean blackKey;
  int octave;
  String keyInText;
  String keysInText[] = {"C","C#","D","D#","E","F","F#","G","G#","A","A#","B"}; 
  boolean[] blackKeys = {false,true,false,true,false,false,true,false,true,false,true,false};

  MIDINote (int _ID, int _key, int _startTick, int _endTick, int _velocity,int track_) {
    ID=_ID;
    key = _key;
    startTick=(_startTick)/2;
    endTick=(_endTick)/2;
    totalTicks = endTick-startTick;
    velocity = _velocity;
    track = track_;
    hit = false;
    octave = key / 12 - 1;
    keyInText = keysInText[(key % 12)];
    blackKey = blackKeys[(key % 12)];
  }
}