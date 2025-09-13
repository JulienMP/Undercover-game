import 'dart:math';
import '../models/game_model.dart';
import '../models/player_model.dart';
import '../models/word_pair_model.dart';

class GameService {
  void setupGame(GameModel game) {
    // Generate players
    _generatePlayers(game);
    
    // Assign roles
    _assignRoles(game);
    
    // Assign words
    _assignWords(game);
  }

  void _generatePlayers(GameModel game) {
    game.players = List.generate(
      game.configuration.totalPlayers,
      (index) => Player(
        id: index,
        name: 'Player ${index + 1}',
      ),
    );
  }

  void _assignRoles(GameModel game) {
    List<PlayerRole> roles = [];
    
    // Add civilian roles
    for (int i = 0; i < game.configuration.civilians; i++) {
      roles.add(PlayerRole.civilian);
    }
    
    // Add undercover roles
    for (int i = 0; i < game.configuration.undercovers; i++) {
      roles.add(PlayerRole.undercover);
    }
    
    // Add Mr. White roles
    for (int i = 0; i < game.configuration.mrWhites; i++) {
      roles.add(PlayerRole.mrWhite);
    }
    
    // Shuffle roles
    roles.shuffle();
    
    // Assign roles to players
    for (int i = 0; i < game.players.length; i++) {
      game.players[i].role = roles[i];
    }
  }

  void _assignWords(GameModel game) {
    // Get a random word pair
    game.currentWordPair = WordPairs.getRandomWordPair();
    
    // Assign words based on roles
    for (var player in game.players) {
      switch (player.role) {
        case PlayerRole.civilian:
          player.secretWord = game.currentWordPair!.civilianWord;
          break;
        case PlayerRole.undercover:
          player.secretWord = game.currentWordPair!.undercoverWord;
          break;
        case PlayerRole.mrWhite:
          player.secretWord = null; // Mr. White gets no word
          break;
      }
    }
  }

  Player getRandomStartingPlayer(GameModel game) {
    var alivePlayers = game.alivePlayers;
    if (alivePlayers.isEmpty) return game.players.first;
    
    var random = Random();
    return alivePlayers[random.nextInt(alivePlayers.length)];
  }

  List<Player> getPlayerOrder(GameModel game, Player startingPlayer) {
    var alivePlayers = game.alivePlayers;
    var startIndex = alivePlayers.indexOf(startingPlayer);
    
    if (startIndex == -1) return alivePlayers;
    
    // Rotate the list to start with the starting player
    return [
      ...alivePlayers.sublist(startIndex),
      ...alivePlayers.sublist(0, startIndex),
    ];
  }

  bool canGameContinue(GameModel game) {
    return game.checkGameResult() == GameResult.ongoing;
  }

  String getPhaseDescription(GamePhase phase) {
    switch (phase) {
      case GamePhase.setup:
        return "Game Setup";
      case GamePhase.roleReveal:
        return "Role Reveal";
      case GamePhase.description:
        return "Description Phase";
      case GamePhase.discussion:
        return "Discussion Phase";
      case GamePhase.voting:
        return "Voting Phase";
      case GamePhase.mrWhiteGuess:
        return "Mr. White's Guess";
      case GamePhase.gameEnd:
        return "Game End";
    }
  }

  String getGameResultDescription(GameResult result) {
    switch (result) {
      case GameResult.civilianWin:
        return "Civilians Win!";
      case GameResult.impostorWin:
        return "Impostors Win!";
      case GameResult.mrWhiteWin:
        return "Mr. White Wins!";
      case GameResult.ongoing:
        return "Game Ongoing";
    }
  }
}