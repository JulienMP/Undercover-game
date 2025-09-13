import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../models/player_model.dart';
import '../models/game_model.dart';
import '../widgets/player_card.dart';
import 'mr_white_guess_screen.dart';
import 'game_result_screen.dart';

class VotingPhaseScreen extends StatefulWidget {
  const VotingPhaseScreen({super.key});

  @override
  State<VotingPhaseScreen> createState() => _VotingPhaseScreenState();
}

class _VotingPhaseScreenState extends State<VotingPhaseScreen> {
  int? _selectedPlayerIndex;
  int _currentVoterIndex = 0;
  bool _showVotingResults = false;

  void _selectPlayer(int playerIndex) {
    setState(() {
      _selectedPlayerIndex = playerIndex;
    });
  }

  void _castVote() {
    if (_selectedPlayerIndex == null) return;
    
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    final game = gameProvider.game!;
    final alivePlayers = game.alivePlayers;
    
    gameProvider.castVote(
      alivePlayers[_currentVoterIndex].id,
      alivePlayers[_selectedPlayerIndex!].id,
    );
    
    setState(() {
      _selectedPlayerIndex = null;
      if (_currentVoterIndex < alivePlayers.length - 1) {
        _currentVoterIndex++;
      } else {
        _showVotingResults = true;
      }
    });
  }

  void _processResults() {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    gameProvider.processVotingResults();
    
    final game = gameProvider.game!;
    
    // Navigate based on game phase
    if (game.currentPhase == GamePhase.mrWhiteGuess) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MrWhiteGuessScreen(),
        ),
      );
    } else if (game.currentPhase == GamePhase.gameEnd) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const GameResultScreen(),
        ),
      );
    } else {
      // Continue to next round (description phase)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const VotingPhaseScreen(), // This would actually go back to description
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        final game = gameProvider.game!;
        final alivePlayers = game.alivePlayers;
        
        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF6C63FF),
                  Color(0xFF4CAF50),
                  Color(0xFFFFEB3B),
                  Color(0xFFFF5722),
                ],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    // Header
                    const Text(
                      'Voting Phase',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    
                    Text(
                      'Vote is done vocally. Click on a player to eliminate them.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Role counters
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildRoleCounter('Civilians', game.aliveCivilians.length, Colors.white),
                          _buildRoleCounter('Undercovers', game.aliveUndercovers.length, Colors.black),
                          _buildRoleCounter('Mr. White', game.aliveMrWhites.length, Colors.grey.shade400),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Player cards grid
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                          childAspectRatio: 1.2,
                        ),
                        itemCount: alivePlayers.length,
                        itemBuilder: (context, index) {
                          final player = alivePlayers[index];
                          
                          return VotingPlayerCard(
                            player: player,
                            isSelected: false,
                            isEliminated: false,
                            votesReceived: 0,
                            onTap: () => _selectPlayer(index),
                          );
                        },
                      ),
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Info text
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.white,
                            size: 20,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Discuss and vote vocally, then click on the player to eliminate',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRoleCounter(String title, int count, Color iconColor) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.person,
            color: iconColor,
            size: 20,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          count.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }
}