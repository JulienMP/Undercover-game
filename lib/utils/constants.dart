import 'package:flutter/material.dart';

class AppConstants {
  // App Info
  static const String appName = 'Undercover Game';
  static const String appVersion = '1.0.0';
  
  // Game Settings
  static const int minPlayers = 3;
  static const int maxPlayers = 20;
  static const int defaultPlayers = 5;
  
  // Colors
  static const Color primaryColor = Color(0xFF6C63FF);
  static const Color secondaryColor = Color(0xFF4CAF50);
  static const Color accentColor = Color(0xFFFFEB3B);
  static const Color warningColor = Color(0xFFFF5722);
  
  static const Color civilianColor = Colors.blue;
  static const Color undercoverColor = Colors.red;
  static const Color mrWhiteColor = Colors.grey;
  
  // Text Styles
  static const TextStyle titleStyle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
  
  static const TextStyle subtitleStyle = TextStyle(
    fontSize: 18,
    color: Colors.white70,
  );
  
  static const TextStyle bodyStyle = TextStyle(
    fontSize: 16,
    color: Colors.black87,
  );
  
  static const TextStyle buttonStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
  
  // Gradients
  static const LinearGradient appGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF6C63FF),
      Color(0xFF4CAF50),
      Color(0xFFFFEB3B),
      Color(0xFFFF5722),
    ],
  );
  
  static const LinearGradient orangeGradient = LinearGradient(
    colors: [Colors.orange, Colors.pink],
  );
  
  static const LinearGradient redGradient = LinearGradient(
    colors: [Colors.orange, Colors.red],
  );
  
  // Dimensions
  static const double defaultPadding = 20.0;
  static const double smallPadding = 10.0;
  static const double largePadding = 30.0;
  
  static const double defaultRadius = 15.0;
  static const double smallRadius = 8.0;
  static const double largeRadius = 25.0;
  
  static const double cardElevation = 5.0;
  static const double buttonHeight = 50.0;
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 300);
  static const Duration mediumAnimation = Duration(milliseconds: 500);
  static const Duration longAnimation = Duration(milliseconds: 1000);
  
  // Game Rules Text
  static const String gameRulesText = '''
OBJECTIVE:
• Civilians: Find and eliminate all impostors
• Undercovers: Survive until only 1 civilian remains  
• Mr. White: Survive or guess the civilian word correctly

SETUP:
• Each player gets a secret word (except Mr. White)
• Civilians share the same word
• Undercovers get a similar but different word
• Mr. White gets no word and must improvise

GAMEPLAY PHASES:

1. DESCRIPTION PHASE
• Players take turns describing their word with one word/phrase
• Use clues to identify allies and enemies
• Mr. White must improvise without knowing the word

2. DISCUSSION PHASE  
• Debate who you think are the impostors
• Gather more information and build alliances
• Don't expose yourself too early!

3. VOTING PHASE
• All players vote to eliminate one player
• Player with most votes is eliminated
• If Mr. White is voted out, they get to guess the civilian word

WINNING CONDITIONS:
• Civilians win by eliminating all impostors
• Impostors win when they equal/outnumber civilians
• Mr. White wins by correctly guessing the civilian word
''';

  static const String amnesyModeDescription = 
    'Amnesy Mode hides secret words and shows only player names. '
    'Click player names to reveal their secret words.';
}

// Helper class for commonly used decorations
class AppDecorations {
  static BoxDecoration get cardDecoration => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 10,
        offset: const Offset(0, 5),
      ),
    ],
  );
  
  static BoxDecoration get gradientCardDecoration => BoxDecoration(
    gradient: AppConstants.appGradient,
    borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 10,
        offset: const Offset(0, 5),
      ),
    ],
  );
  
  static BoxDecoration roleCardDecoration(Color color) => BoxDecoration(
    color: color.withOpacity(0.1),
    borderRadius: BorderRadius.circular(AppConstants.smallRadius),
    border: Border.all(color: color.withOpacity(0.3)),
  );
}