
class Button {
  boolean active;
  int level;
  float xpos;
  float originalxpos;
  float ypos;
  float wsize;
  int hsize;

  Button(int _level, float _xpos, float _ypos, int size) {
    active = false;
    level = _level;
    xpos = _xpos;
    originalxpos = xpos;
    ypos = _ypos;
    wsize = size;
    hsize = size;
  }

  void activityUpdate() {

    //If level 0 should be active make it active
    if (level==0&&game.activeLevel!=0) {
      active = true;
    } else if (level==0&&game.activeLevel==0) {
      active = false;
    }

    //If the other levels should be active make them active
    if (level!=0&&game.activeLevel!=0) {
      active = false;
    } else if (level!=0&&game.activeLevel==0) {
      active = true;
    }
  }

  void placeUpdate(float xposEarth) {
    xpos = xposEarth+originalxpos;
  }

  void display() {

    rectMode(CORNER); //Mode which uses the top left and bottom right corners
    if (active) {
      text(level, xpos, ypos);
      rect(xpos, ypos, wsize, hsize);

      if (game.activeLevel==0) {
        text("START SCREEN", width/2, height/2);
      }
    }
  }

  boolean hover() { //Check if the cursor is hovering over a button
    if (mouseX>=xpos&&mouseX<=xpos+wsize&&mouseY>=ypos&&mouseY<=ypos+hsize) {
      return true;
    } else {
      return false;
    }
  }
}