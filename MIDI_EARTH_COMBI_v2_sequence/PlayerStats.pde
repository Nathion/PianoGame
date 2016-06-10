class PlayerStats {
  int score;
  int levelsAchieved;
  String [] abilities = {"extraPoints", "extraLife", "fewerMistakes", "godMode"};
  boolean [] activeAbilities;

  PlayerStats () {
    score=0;
    levelsAchieved=0;
    activeAbilities = new boolean[abilities.length];
  }
}