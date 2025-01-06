/*
initial layout: solution not revealed,
may may not have image
second layout
solution may or may not be revealed,
may may not have image

so: possible cases would be:
case 1: solution not revealed, no image
case 2: solution not revealed, there is image
case 3: solution revealed, no image
case 4: solution revealed, there is image

so we represent these 4 states, and set up 
the flex of the middle expanded value 
based on that.
*/

class ScreenLayoutConfig {
  bool imageExists;
  bool answerRevealed;
  ScreenLayoutConfig({
    this.imageExists = false,
    this.answerRevealed = false,
  });
}
