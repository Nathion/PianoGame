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

  MIDINote (int _ID, int _key, int _startTick, int _endTick, int _velocity,int track_) {
    ID=_ID;
    key = _key;
    startTick=(_startTick)/2;
    endTick=(_endTick)/2;
    totalTicks = endTick-startTick;
    velocity = _velocity;
    track = track_;
    hit = false;
  }
}