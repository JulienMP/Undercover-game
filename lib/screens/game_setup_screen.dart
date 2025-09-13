import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_model.dart';
import '../providers/game_provider.dart';
import '../widgets/role_distribution_widget.dart';
import 'role_reveal_screen.dart';

class GameSetupScreen extends StatefulWidget {
  const GameSetupScreen({super.key});

  @override
  State<GameSetupScreen> createState() => _GameSetupScreenState();
}

class _GameSetupScreenState extends State<GameSetupScreen> {
  int _playerCount = 5;
  late GameConfiguration _configuration;

  @override
  void initState() {
    super.initState();
    _configuration = GameConfiguration.getRecommendedConfiguration(_playerCount);
  }

  void _updatePlayerCount(int count) {
    setState(() {
      _playerCount = count;
      _configuration = GameConfiguration.getRecommendedConfiguration(count);
    });
  }

  void _updateConfiguration(GameConfiguration config) {
    setState(() {
      _configuration = config;
    });
  }

  void _startGame() {
    if (_configuration.isValid) {
      final gameProvider = Provider.of<GameProvider>(context, listen: false);
      gameProvider.initializeGame(_configuration);
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const RoleRevealScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    const Expanded(
                      child: Text(
                        'Undercover Setup',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48), // Balance the back button
                  ],
                ),
                
                const SizedBox(height: 40),
                
                // Game Setup Card
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // Players Count
                        Text(
                          'Players: $_playerCount',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Player Count Slider
                        Slider(
                          value: _playerCount.toDouble(),
                          min: 3,
                          max: 20,
                          divisions: 17,
                          label: _playerCount.toString(),
                          onChanged: (value) {
                            _updatePlayerCount(value.round());
                          },
                        ),
                        
                        const SizedBox(height: 30),
                        
                        // Role Distribution
                        Expanded(
                          child: RoleDistributionWidget(
                            configuration: _configuration,
                            onConfigurationChanged: _updateConfiguration,
                          ),
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Game Rules Info
                        Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'Standard Mode: Use just one word or phrase to describe your secret word.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        
                        const SizedBox(height: 30),
                        
                        // Start Game Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _configuration.isValid ? _startGame : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              elevation: 5,
                            ),
                            child: const Text(
                              'START GAME',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}