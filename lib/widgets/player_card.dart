import 'package:flutter/material.dart';
import '../models/player_model.dart';
import '../providers/game_provider.dart';

class PlayerCard extends StatelessWidget {
  final Player player;
  final bool isRevealed;
  final VoidCallback? onTap;
  final GameProvider gameProvider;
  final bool isClickable;
  final String? playerName;
  final bool showPlayerName;

  const PlayerCard({
    super.key,
    required this.player,
    this.isRevealed = false,
    this.onTap,
    required this.gameProvider,
    this.isClickable = true,
    this.playerName,
    this.showPlayerName = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isClickable ? onTap : null,
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
            color: isRevealed ? _getRevealedCardColor() : Colors.orange,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isRevealed) ...[
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
                        _getPlayerInitial(),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: player.roleColor,
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
                      _getDisplayText(),
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
                  if (showPlayerName && playerName != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      playerName!,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ] else ...[
                  // Hidden state
                  Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.help,
                      size: 30,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    '?',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getPlayerInitial() {
    if (player.role == PlayerRole.mrWhite) {
      return 'W';
    }
    return player.secretWord?.substring(0, 1).toUpperCase() ?? 'G';
  }

  String _getDisplayText() {
    return gameProvider.getPlayerDisplayText(player);
  }

  Color _getRevealedCardColor() {
    if (player.role == PlayerRole.mrWhite) {
      return Colors.grey;
    }
    return Colors.green;
  }
}

class VotingPlayerCard extends StatelessWidget {
  final Player player;
  final bool isSelected;
  final bool isEliminated;
  final VoidCallback? onTap;
  final int votesReceived;

  const VotingPlayerCard({
    super.key,
    required this.player,
    this.isSelected = false,
    this.isEliminated = false,
    this.onTap,
    this.votesReceived = 0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: !isEliminated ? onTap : null,
      child: Container(
        decoration: BoxDecoration(
          color: isEliminated 
              ? Colors.grey.withOpacity(0.5)
              : isSelected 
                  ? player.roleColor.withOpacity(0.8)
                  : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? player.roleColor : Colors.grey.withOpacity(0.3),
            width: isSelected ? 3 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Player number badge
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : player.roleColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${player.id + 1}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? player.roleColor : Colors.white,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Player name
              Text(
                player.name,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : Colors.black,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              
              // Vote count
              if (votesReceived > 0) ...[
                const SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$votesReceived vote${votesReceived > 1 ? 's' : ''}',
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
              
              // Eliminated overlay
              if (isEliminated)
                const Icon(
                  Icons.close,
                  color: Colors.red,
                  size: 30,
                ),
            ],
          ),
        ),
      ),
    );
  }
}