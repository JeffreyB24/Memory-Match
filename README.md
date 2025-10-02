# Project 4 - Memory Match

Submitted by: Jeffrey Berdeal

Memory Match is an app that hides different pairs of emojis and using your memory, you must match all the different pairs in the least amount moves. 

Time spent: 24 hours spent in total

## Required Features

The following **required** functionality is completed:

- [X] App loads to display a grid of cards initially placed face-down:
  - Upon launching the app, a grid of cards should be visible.
  - Cards are facedown to indicate the start of the game.
- [X] Users can tap cards to toggle their display between the back and the face: 
  - Tapping on a facedown card should flip it to reveal the front.
  - Tapping a second card that is not identical should flip both back down
- [X] When two matching cards are found, they both disappear from view:
  - Implement logic to check if two tapped cards match.
  - If they match, both cards should either disappear.
  - If they don't match, they should return to the facedown position.
- [X] User can reset the game and start a new game via a button:
  - Include a button that allows users to reset the game.
  - This button should shuffle the cards and reset any game-related state.
 
The following **optional** features are implemented:

- [X] User can select number of pairs to play with (at least 2 unique values like 2 and 4).
  * (Hint: user Picker)
- [X] App allows for user to scroll to see pairs out of view.
  * (Hint: Use a Scrollview)
- [X] Add any flavor you’d like to your UI with colored buttons or backgrounds, unique cards, etc. 
  * Enhance the visual appeal of the app with colored buttons, backgrounds, or unique card designs.
  * Consider using animations or transitions to make the user experience more engaging.

The following **additional** features are implemented:

- [ ] List anything else that you can get done to improve the app functionality!

## Video Walkthrough

<div>
    <a href="https://www.loom.com/share/ee1e553dda4c4c46aea16bfc2818fad7">
    </a>
    <a href="https://www.loom.com/share/ee1e553dda4c4c46aea16bfc2818fad7">
      <img style="max-width:300px;" src="https://cdn.loom.com/sessions/thumbnails/ee1e553dda4c4c46aea16bfc2818fad7-48d9d58e06f36fb5-full-play.gif">
    </a>
  </div>
## Notes

- The grid of cards did not appear at first because the cards array wasn’t being initialized properly, so I had to ensure startNewGame() was always called on launch.
- Even after cards were created, they were not visible because they lacked a fixed frame size, so I added .frame(height:) to make them consistently display.
- Implementing the card flip logic was difficult because I needed to prevent more than two cards from being selected, handle mismatches with a delay, and reset the state correctly.
- The reset button initially did not clear all state variables, so I had to explicitly reset moves, matches, and the firstIndex.
- Making the control bar readable across different screen sizes was challenging since the text either wrapped, got truncated, or stretched off screen, and I fixed this by using adaptive layouts with .lineLimit, .minimumScaleFactor, and ViewThatFits.
- The “Pairs” button text kept wrapping vertically (e.g., Pairs:\n4), so I forced it to stay on one line with .lineLimit(1) and allowed it to shrink slightly instead of wrapping.
- Balancing the UI so that the buttons were clear while the game grid stayed consistent required reflowing the controls adaptively without affecting the card layout.
- Getting the card flip animations to look smooth required experimenting with custom AnyTransition and 3D rotation effects.

## License

    Copyright 2025 Jeffrey Berdeal

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
