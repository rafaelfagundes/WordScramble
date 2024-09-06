# WordScramble

WordScramble is a classic word scramble game built using SwiftUI. The goal of the game is to create as many unique words as possible from the given set of letters.

## Features

- **Dynamic Scoring**: Earn points based on the length of the words you create.
- **Word Validation**: Ensure words are not just scrambled but are real English words.
- **Prevent Duplicate Words**: Check that words are unique and haven't been used before.
- **Adaptive Layout**: Smooth and responsive design with a focus on usability.
- **Keyboard Management**: Automatically handles keyboard visibility for a seamless user experience.
- **Flexible Word Source**: Randomly selects a root word from a list provided in `start.txt`.

## Demo

Check out the game in action!

![WordScramble Demo](demo.mp4)

## How to Play

1. Launch the app.
2. You will see a scrambled word and a text field.
3. Enter your guessed words in the text field and submit by pressing "Return" or "Next".
4. Your score will increase based on the length of valid words you create.
5. Press the "Next Word" button to get a new root word and restart the game.

## Code Overview

### Main Components

- **ContentView.swift**: The primary view which includes the game logic and user interface.
- **StylizedWord.swift**: A subview to display the root word in a visually appealing manner.

### Important Functions

- **startGame()**: Initializes the game by selecting a new root word and resetting the score and used words.
- **addNewWord()**: Validates and adds new words to the list, updating the score appropriately.
- **isOriginal(word:)**: Checks if the word has already been used.
- **isPossible(word:)**: Ensures the word can be made from the letters of the root word.
- **isReal(word:)**: Verifies that the word is an actual English word.

### UI Design

- Uses `NavigationStack` for structure.
- Custom colors and styles applied to various UI elements for a distinctive look.
- Handles keyboard appearance to improve user input experience.
- An alert system to notify players of invalid words and game rules.

## Installation and Setup

1. Clone the repository.
   ```sh
   git clone <repository-url>
   ```
2. Open the project in Xcode.
`open Projects/hacking-with-swift/word-scramble/WordScramble/WordScramble.xcodeproj`
3. Run the app on the simulator or a connected device.