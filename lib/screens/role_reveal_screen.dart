import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../models/player_model.dart';
import '../widgets/player_card.dart';
import 'description_phase_screen.dart';

class RoleRevealScreen extends StatefulWidget {
  const RoleRevealScreen({super.key});

  @override
  State<RoleRevealScreen> createState() => _RoleRevealScreenState();
}

class _RoleRevealScreenState extends State<RoleRevealScreen> {
  int _currentPlayerIndex = 0;
  String _playerName = '';
  final TextEditingController _nameController = TextEditingController();
  List<bool> _cardsTaken = List.filled(5, false);
  int? _selectedCardIndex;
  bool _nameEntered = false;
  bool _cardSelected = false;

  void _submitName() {
    if (_playerName.trim().isNotEmpty) {
      setState(() {
        _nameEntered = true;
      });
    }
  }

  void _selectCard(int cardIndex) {
    if (_cardsTaken[cardIndex] || !_nameEntered) return;
    
    setState(() {
      _selectedCardIndex = cardIndex;
      _cardSelected = true;
      _cardsTaken[cardIndex] = true;
    });
  }

  void _nextPlayer() {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    final game = gameProvider.game!;
    
    // Save the current player's name
    game.players[_currentPlayerIndex].name = _playerName.isNotEmpty ? _playerName : 'Player ${_currentPlayerIndex + 1}';
    
    setState(() {
      _selectedCardIndex = null;
      _cardSelected = false;
      _nameEntered = false;
      _playerName = '';
      _nameController.clear();
      
      if (_currentPlayerIndex < game.players.length - 1) {
        _currentPlayerIndex++;
      } else {
        // All players have seen their roles, proceed to description phase
        gameProvider.proceedToDescription();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const DescriptionPhaseScreen(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        final game = gameProvider.game!;
        final currentPlayer = game.players[_currentPlayerIndex];
        
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
                    Text(
                      'Player ${_currentPlayerIndex + 1}',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    
                    Text(
                      _nameEntered ? 'Choose a card' : 'Enter your name first',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Name input (only show if name not entered)
                    if (!_nameEntered) ...[
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: TextField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            hintText: 'Enter your name',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(15),
                          ),
                          style: const TextStyle(fontSize: 16),
                          onChanged: (value) {
                            setState(() {
                              _playerName = value;
                            });
                          },
                          onSubmitted: (_) => _submitName(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _playerName.trim().isNotEmpty ? _submitName : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: const Text(
                            'CONFIRM NAME',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                    ],
                    
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
                          _buildRoleCounter('Civilians', game.civilians.length, Colors.white),
                          _buildRoleCounter('Undercovers', game.undercovers.length, Colors.black),
                          _buildRoleCounter('Mr. White', game.mrWhites.length, Colors.grey.shade400),
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
                          childAspectRatio: 0.8,
                        ),
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: _nameEntered && !_cardsTaken[index] ? () => _selectCard(index) : null,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Container(
                                  color: _cardsTaken[index] 
                                      ? Colors.grey 
                                      : (_selectedCardIndex == index 
                                          ? _getRevealedCardColor(currentPlayer) 
                                          : Colors.orange),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (_selectedCardIndex == index) ...[
                                        // Revealed state
                                        Container(
                                          width: 60,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.9),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Text(
                                              _getPlayerInitial(currentPlayer),
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                                color: currentPlayer.roleColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 15),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          child: Text(
                                            gameProvider.getPlayerDisplayText(currentPlayer),
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black,
                                            ),
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        if (_playerName.isNotEmpty) ...[
                                          const SizedBox(height: 8),
                                          Text(
                                            _playerName,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ] else if (_cardsTaken[index]) ...[
                                        // Taken card
                                        const Icon(
                                          Icons.check_circle,
                                          size: 40,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(height: 10),
                                        const Text(
                                          'TAKEN',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ] else ...[
                                        // Hidden state
                                        Container(
                                          width: 60,
                                          height: 60,
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.help,
                                            size: 30,
                                            color: _nameEntered ? Colors.orange : Colors.grey,
                                          ),
                                        ),
                                        const SizedBox(height: 15),
                                        Text(
                                          '?',
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: _nameEntered ? Colors.white : Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Next/Start button
                    Container(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _cardSelected ? _nextPlayer : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _cardSelected ? Colors.green : Colors.grey,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: Text(
                          _cardSelected
                              ? (_currentPlayerIndex < game.players.length - 1 
                                  ? 'NEXT PLAYER' 
                                  : 'START GAME')
                              : 'SELECT A CARD FIRST',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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

  String _getPlayerInitial(Player player) {
    if (player.role == PlayerRole.mrWhite) {
      return 'W';
    }
    return player.secretWord?.substring(0, 1).toUpperCase() ?? 'G';
  }

  Color _getRevealedCardColor(Player player) {
    if (player.role == PlayerRole.mrWhite) {
      return Colors.grey;
    }
    return Colors.green;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}