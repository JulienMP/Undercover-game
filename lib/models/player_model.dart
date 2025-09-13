import 'package:flutter/material.dart';

enum PlayerRole { civilian, undercover, mrWhite }

class Player {
  final int id;
  String name;
  PlayerRole role;
  String? secretWord;
  bool isEliminated;
  bool hasVoted;
  int votesReceived;

  Player({
    required this.id,
    required this.name,
    this.role = PlayerRole.civilian,
    this.secretWord,
    this.isEliminated = false,
    this.hasVoted = false,
    this.votesReceived = 0,
  });

  Player copyWith({
    int? id,
    String? name,
    PlayerRole? role,
    String? secretWord,
    bool? isEliminated,
    bool? hasVoted,
    int? votesReceived,
  }) {
    return Player(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      secretWord: secretWord ?? this.secretWord,
      isEliminated: isEliminated ?? this.isEliminated,
      hasVoted: hasVoted ?? this.hasVoted,
      votesReceived: votesReceived ?? this.votesReceived,
    );
  }

  bool get isAlive => !isEliminated;
  
  String get roleDisplayName {
    switch (role) {
      case PlayerRole.civilian:
        return 'Civilian';
      case PlayerRole.undercover:
        return 'Undercover';
      case PlayerRole.mrWhite:
        return 'Mr. White';
    }
  }

  Color get roleColor {
    switch (role) {
      case PlayerRole.civilian:
        return Colors.blue;
      case PlayerRole.undercover:
        return Colors.red;
      case PlayerRole.mrWhite:
        return Colors.grey;
    }
  }
}