# Undercover Game

A Flutter mobile app featuring social deduction mini-games, starting with the classic **Undercover** game.

## Game Description

Undercover is a social deduction game where players receive secret words and must figure out who among them are the impostors through discussion and voting.

### Player Roles

- **Civilians** (👥): Receive the same secret word. Goal: Eliminate all impostors.
- **Undercovers** (🕵️): Receive a similar but different word. Goal: Survive until they outnumber civilians.
- **Mr. White** (👤): Receives no word at all. Goal: Survive or correctly guess the civilian word.

### Game Flow

1. **Setup Phase**: Configure player count and role distribution
2. **Role Reveal Phase**: Players privately view their secret words
3. **Description Phase**: Players describe their words using one word/phrase
4. **Discussion Phase**: Free discussion to identify impostors
5. **Voting Phase**: Vote to eliminate one player
6. **Mr. White Guess** (if applicable): Final chance for Mr. White to win
7. **Results**: Game ends when one faction achieves victory

## Features

- 🎮 **Pass-and-Play Mode**: Only one device needed for 3-20 players
- 🎲 **Automatic Role Distribution**: Smart suggestions based on player count
- 🔀 **Random Word Pairs**: 25+ built-in word pair combinations
- 👁️ **Amnesy Mode**: Hide/reveal secret words during gameplay
- 📱 **Responsive Design**: Beautiful gradient UI with smooth animations
- ⚙️ **Customizable Setup**: Adjust roles or use random configuration


## Project Structure

```
lib/
├── main.dart                     # App entry point
├── models/
│   ├── game_model.dart          # Game state and configuration
│   ├── player_model.dart        # Player data structure
│   └── word_pair_model.dart     # Word pairs for the game
├── screens/
│   ├── home_screen.dart         # Main menu
│   ├── game_setup_screen.dart   # Player count and role setup
│   ├── role_reveal_screen.dart  # Secret word reveal
│   ├── description_phase_screen.dart  # Description phase
│   ├── voting_phase_screen.dart # Voting interface
│   ├── mr_white_guess_screen.dart     # Mr. White's final guess
│   └── game_result_screen.dart  # Game end and results
├── widgets/
│   ├── player_card.dart         # Player display components
│   └── role_distribution_widget.dart # Role configuration UI
├── providers/
│   └── game_provider.dart       # State management
├── services/
│   └── game_service.dart        # Game logic and flow
└── utils/
    └── constants.dart           # App constants and styling
```

## How to Play

### Setup
1. Open the app and select "Undercover"
2. Choose number of players (3-20)
3. Adjust role distribution or use recommended settings
4. Start the game

### Gameplay
1. **Role Reveal**: Each player privately views their card to see their secret word
2. **Description**: Players take turns describing their word with just one word or phrase
3. **Discussion**: Open discussion to identify who might be impostors
4. **Voting**: Vote to eliminate the most suspicious player
5. **Repeat** until one team wins

### Winning
- **Civilians win**: All impostors eliminated
- **Impostors win**: Equal or outnumber civilians  
- **Mr. White wins**: Correctly guesses the civilian word when voted out

## Technical Details

### Dependencies
- `provider: ^6.0.5` - State management
- `shared_preferences: ^2.2.2` - Local storage for settings
- `auto_size_text: ^3.0.0` - Responsive text sizing

### Key Components
- **GameProvider**: Manages game state using Provider pattern
- **GameService**: Handles game logic and flow control
- **WordPairs**: Database of 25+ word pair combinations
- **Player Cards**: Interactive UI components for player representation

### Architecture
- **MVVM Pattern**: Models, Views, and ViewModels clearly separated
- **Provider State Management**: Reactive UI updates
- **Service Layer**: Business logic isolated from UI
- **Responsive Design**: Adapts to different screen sizes

## Game Balance

The app automatically suggests balanced role distributions:

| Players | Civilians | Undercovers | Mr. White |
|---------|-----------|-------------|-----------|
| 3-5     | n-1       | 1           | 0         |
| 6-8     | n-2       | 1           | 1         |
| 9+      | ~70%      | ~25%        | 1         |

Players can customize these distributions while maintaining game balance rules.

## Future Features

- 🎯 Additional mini-games
- 🌐 Online multiplayer mode  
- 📊 Game statistics and history
- 🎨 Custom themes and card designs
- 🔊 Sound effects and background music
- 🌍 Multiple language support

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/new-game`)
3. Commit changes (`git commit -am 'Add new mini-game'`)
4. Push to branch (`git push origin feature/new-game`)
5. Create Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Credits

Inspired by the classic Undercover/One Night Ultimate Werewolf style social deduction games.

Built with Flutter 💙
