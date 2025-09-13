import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../models/game_model.dart';
import '../models/player_model.dart';
import '../widgets/player_card.dart';
import 'voting_phase_screen.dart';

class DescriptionPhaseScreen extends StatefulWidget {
  const DescriptionPhaseScreen({super.key});

  @override
  State<DescriptionPhaseScreen> createState() => _DescriptionPhaseScreenState();
}

class _DescriptionPhaseScreenState extends State<DescriptionPhaseScreen> {
  int? _startingPlayerIndex;

  @override
  void initState() {
    super.initState();
    _selectRandomStartingPlayer();
  }

  void _selectRandomStartingPlayer() {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    final game = gameProvider.game!;
    
    // Get all alive players who are not Mr. White
    final eligiblePlayers = game.alivePlayers
        .where((player) => player.role != PlayerRole.mrWhite)
        .toList();
    
    if (eligiblePlayers.isNotEmpty) {
      eligiblePlayers.shuffle();
      final startingPlayer = eligiblePlayers.first;
      _startingPlayerIndex = game.alivePlayers.indexOf(startingPlayer);
    }
  }

  void _proceedToVoting() {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    gameProvider.proceedToVoting();
    
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const VotingPhaseScreen(),
      ),
    );
  }

  void _toggleAmnesyMode() {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    gameProvider.toggleAmnesyMode();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        final game = gameProvider.game!;
        
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
                      'Description Phase',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    
                    if (_startingPlayerIndex != null) ...[
                      Text(
                        '${game.alivePlayers[_startingPlayerIndex!].name} starts!',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 5),
                    ],
                    
                    Text(
                      'Describe your secret word using just one word or phrase.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.8),
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
                    
                    const SizedBox(height: 20),
                    
                    // Special Roles Section
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Row(
                        children: [
                          Text(
                            'Special Roles',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                          Spacer(),
                          Text(
                            'None',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Player cards grid
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: game.alivePlayers.length,
                        itemBuilder: (context, index) {
                          final player = game.alivePlayers[index];
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: game.isAmnesyMode ? Colors.grey : player.roleColor,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Player number
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      (index + 1).toString(),
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: player.roleColor,
                                      ),
                                    ),
                                  ),
                                ),
                                
                                const SizedBox(height: 10),
                                
                                // Player info
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    game.isAmnesyMode ? player.name : gameProvider.getPlayerDisplayText(player),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Bottom buttons row
                    Row(
                      children: [
                        // Settings button
                        Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            color: Colors.pink,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            onPressed: () {
                              _showSettingsDialog();
                            },
                            icon: const Icon(
                              Icons.settings,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                        
                        const SizedBox(width: 15),
                        
                        // Amnesy mode button
                        Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            onPressed: _toggleAmnesyMode,
                            icon: Icon(
                              game.isAmnesyMode ? Icons.visibility_off : Icons.visibility,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                        
                        const SizedBox(width: 15),
                        
                        // Proceed to voting button
                        Expanded(
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Colors.orange, Colors.red],
                              ),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: ElevatedButton(
                              onPressed: _proceedToVoting,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              child: const Text(
                                'Proceed to Vote',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
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

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Game Settings'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.refresh),
                title: const Text('Reset Game'),
                onTap: () {
                  Navigator.of(context).pop();
                  _showResetConfirmation();
                },
              ),
              ListTile(
                leading: const Icon(Icons.help),
                title: const Text('Game Rules'),
                onTap: () {
                  Navigator.of(context).pop();
                  _showGameRules();
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showResetConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reset Game'),
          content: const Text('Are you sure you want to reset the game? All progress will be lost.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final gameProvider = Provider.of<GameProvider>(context, listen: false);
                gameProvider.resetGame();
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );
  }

  void _showGameRules() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Game Rules'),
          content: const SingleChildScrollView(
            child: Text(
              'DESCRIPTION PHASE:\n'
              '• Each player describes their secret word using just one word or phrase\n'
              '• Civilians have the same word\n'
              '• Undercovers have a similar but different word\n'
              '• Mr. White has no word and must improvise\n\n'
              'GOALS:\n'
              '• Civilians: Find and eliminate all impostors\n'
              '• Undercovers: Survive until only 1 civilian remains\n'
              '• Mr. White: Survive or guess the civilian word correctly',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Got it'),
            ),
          ],
        );
      },
    );
  }

  void _showPlayerConfirmation(Player player) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Player Confirmation'),
          content: Text(
            'Are you ${player.name}? Confirm to see your secret word.',
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showPlayerSecretWord(player);
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void _showPlayerSecretWord(Player player) {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${player.name}\'s Secret'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: player.roleColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    player.role == PlayerRole.mrWhite ? 'W' : player.secretWord?.substring(0, 1).toUpperCase() ?? 'G',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: player.roleColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: player.roleColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  gameProvider.getPlayerDisplayText(player),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Just close the dialog, don't change amnesy mode
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}