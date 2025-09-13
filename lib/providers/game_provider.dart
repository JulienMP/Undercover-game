import 'package:flutter/material.dart';
import '../models/game_model.dart';
import '../models/player_model.dart';
import '../models/word_pair_model.dart';
import '../services/game_service.dart';

class GameProvider extends ChangeNotifier {
  GameModel? _game;
  final GameService _gameService = GameService();

  GameModel? get game => _game;
  bool get hasActiveGame => _game != null;

  void initializeGame(GameConfiguration config) {
    _game = GameModel(configuration: config);
    _gameService.setupGame(_game!);
    notifyListeners();
  }

  void startGame() {
    if (_game == null) return;
    _game!.currentPhase = GamePhase.roleReveal;
    notifyListeners();
  }

  void revealRole(int playerIndex) {
    // This method can be called when a player views their role
    notifyListeners();
  }

  void proceedToDescription() {
    if (_game == null) return;
    _game!.currentPhase = GamePhase.description;
    notifyListeners();
  }

  void proceedToDiscussion() {
    if (_game == null) return;
    _game!.currentPhase = GamePhase.discussion;
    notifyListeners();
  }

  void proceedToVoting() {
    if (_game == null) return;
    _game!.currentPhase = GamePhase.voting;
    _game!.resetVotes();
    notifyListeners();
  }

  void castVote(int voterIndex, int targetIndex) {
    if (_game == null) return;
    
    var voter = _game!.players[voterIndex];
    var target = _game!.players[targetIndex];
    
    if (voter.isAlive && target.isAlive && !voter.hasVoted) {
      voter.hasVoted = true;
      target.votesReceived++;
      notifyListeners();
    }
  }

  void processVotingResults() {
    if (_game == null) return;

    var eliminatedPlayer = _game!.getPlayerWithMostVotes();
    
    if (eliminatedPlayer != null) {
      if (eliminatedPlayer.role == PlayerRole.mrWhite) {
        // Mr. White gets a chance to guess
        _game!.currentPhase = GamePhase.mrWhiteGuess;
      } else {
        _game!.eliminatePlayer(eliminatedPlayer);
        _checkGameEnd();
      }
    } else {
      // No elimination due to tie, continue to next round
      _game!.startNewRound();
    }
    
    notifyListeners();
  }

  void processMrWhiteGuess(String guess) {
    if (_game == null) return;

    var mrWhitePlayer = _game!.getPlayerWithMostVotes();
    if (mrWhitePlayer?.role == PlayerRole.mrWhite) {
      if (guess.toLowerCase().trim() == _game!.currentWordPair!.civilianWord.toLowerCase()) {
        // Mr. White wins!
        _game!.currentPhase = GamePhase.gameEnd;
      } else {
        // Wrong guess, eliminate Mr. White
        _game!.eliminatePlayer(mrWhitePlayer!);
        _checkGameEnd();
      }
    }
    
    notifyListeners();
  }

  void _checkGameEnd() {
    if (_game == null) return;

    var result = _game!.checkGameResult();
    if (result != GameResult.ongoing) {
      _game!.currentPhase = GamePhase.gameEnd;
    } else {
      _game!.startNewRound();
    }
  }

  void toggleAmnesyMode() {
    if (_game == null) return;
    _game!.isAmnesyMode = !_game!.isAmnesyMode;
    notifyListeners();
  }

  void resetGame() {
    _game = null;
    notifyListeners();
  }

  String getPlayerDisplayText(Player player) {
    if (_game?.isAmnesyMode ?? false) {
      return player.name;
    }
    
    if (player.role == PlayerRole.mrWhite) {
      return "You are Mr. White";
    }
    
    return player.secretWord ?? "";
  }

  GameResult getGameResult() {
    return _game?.checkGameResult() ?? GameResult.ongoing;
  }

  List<Player> getWinners() {
    if (_game == null) return [];
    
    var result = getGameResult();
    switch (result) {
      case GameResult.civilianWin:
        return _game!.civilians;
      case GameResult.impostorWin:
        return [..._game!.undercovers, ..._game!.mrWhites];
      case GameResult.mrWhiteWin:
        return _game!.mrWhites;
      case GameResult.ongoing:
        return [];
    }
  }
}