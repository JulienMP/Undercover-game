import 'player_model.dart';
import 'word_pair_model.dart';

enum GamePhase {
  setup,
  roleReveal,
  description,
  discussion,
  voting,
  mrWhiteGuess,
  gameEnd
}

enum GameResult { civilianWin, impostorWin, mrWhiteWin, ongoing }

class GameConfiguration {
  final int totalPlayers;
  final int civilians;
  final int undercovers;
  final int mrWhites;

  GameConfiguration({
    required this.totalPlayers,
    required this.civilians,
    required this.undercovers,
    required this.mrWhites,
  });

  bool get isValid {
    return civilians + undercovers + mrWhites == totalPlayers &&
           civilians >= (undercovers + mrWhites) &&
           (undercovers > 0 || mrWhites > 0);
  }

  static GameConfiguration getRecommendedConfiguration(int playerCount) {
    if (playerCount < 3) return GameConfiguration(totalPlayers: 3, civilians: 2, undercovers: 1, mrWhites: 0);
    if (playerCount <= 5) return GameConfiguration(totalPlayers: playerCount, civilians: playerCount - 1, undercovers: 1, mrWhites: 0);
    if (playerCount <= 8) return GameConfiguration(totalPlayers: playerCount, civilians: playerCount - 2, undercovers: 1, mrWhites: 1);
    
    // For larger groups
    int undercovers = (playerCount * 0.3).round();
    int mrWhites = 1;
    int civilians = playerCount - undercovers - mrWhites;
    
    return GameConfiguration(
      totalPlayers: playerCount,
      civilians: civilians,
      undercovers: undercovers,
      mrWhites: mrWhites,
    );
  }
}

class GameModel {
  List<Player> players;
  GamePhase currentPhase;
  WordPair? currentWordPair;
  int currentPlayerIndex;
  int round;
  bool isAmnesyMode;
  GameConfiguration configuration;

  GameModel({
    this.players = const [],
    this.currentPhase = GamePhase.setup,
    this.currentWordPair,
    this.currentPlayerIndex = 0,
    this.round = 1,
    this.isAmnesyMode = false,  // Ensure it defaults to false
    required this.configuration,
  });

  List<Player> get alivePlayers => players.where((p) => p.isAlive).toList();
  List<Player> get civilians => players.where((p) => p.role == PlayerRole.civilian).toList();
  List<Player> get undercovers => players.where((p) => p.role == PlayerRole.undercover).toList();
  List<Player> get mrWhites => players.where((p) => p.role == PlayerRole.mrWhite).toList();
  
  List<Player> get aliveCivilians => civilians.where((p) => p.isAlive).toList();
  List<Player> get aliveUndercovers => undercovers.where((p) => p.isAlive).toList();
  List<Player> get aliveMrWhites => mrWhites.where((p) => p.isAlive).toList();

  GameResult checkGameResult() {
    int aliveCivilianCount = aliveCivilians.length;
    int aliveImpostorCount = aliveUndercovers.length + aliveMrWhites.length;

    // Civilians win if all impostors are eliminated
    if (aliveImpostorCount == 0) {
      return GameResult.civilianWin;
    }

    // Impostors win if civilians are equal or less than impostors
    if (aliveCivilianCount <= aliveImpostorCount) {
      return GameResult.impostorWin;
    }

    return GameResult.ongoing;
  }

  void resetVotes() {
    for (var player in players) {
      player.hasVoted = false;
      player.votesReceived = 0;
    }
  }

  Player? getPlayerWithMostVotes() {
    if (alivePlayers.isEmpty) return null;
    
    var sortedPlayers = alivePlayers.toList()
      ..sort((a, b) => b.votesReceived.compareTo(a.votesReceived));
    
    // Check for ties
    if (sortedPlayers.length > 1 && 
        sortedPlayers[0].votesReceived == sortedPlayers[1].votesReceived) {
      return null; // Tie, no elimination
    }
    
    return sortedPlayers[0].votesReceived > 0 ? sortedPlayers[0] : null;
  }

  void eliminatePlayer(Player player) {
    player.isEliminated = true;
  }

  void nextPhase() {
    switch (currentPhase) {
      case GamePhase.setup:
        currentPhase = GamePhase.roleReveal;
        break;
      case GamePhase.roleReveal:
        currentPhase = GamePhase.description;
        break;
      case GamePhase.description:
        currentPhase = GamePhase.discussion;
        break;
      case GamePhase.discussion:
        currentPhase = GamePhase.voting;
        break;
      case GamePhase.voting:
        // This is handled in game logic based on voting results
        break;
      case GamePhase.mrWhiteGuess:
        currentPhase = GamePhase.gameEnd;
        break;
      case GamePhase.gameEnd:
        // Game over
        break;
    }
  }

  void startNewRound() {
    round++;
    currentPhase = GamePhase.description;
    resetVotes();
  }
}