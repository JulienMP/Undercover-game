import 'package:flutter/material.dart';
import '../models/game_model.dart';

class RoleDistributionWidget extends StatefulWidget {
  final GameConfiguration configuration;
  final Function(GameConfiguration) onConfigurationChanged;

  const RoleDistributionWidget({
    super.key,
    required this.configuration,
    required this.onConfigurationChanged,
  });

  @override
  State<RoleDistributionWidget> createState() => _RoleDistributionWidgetState();
}

class _RoleDistributionWidgetState extends State<RoleDistributionWidget> {
  late int _undercovers;
  late int _mrWhites;

  @override
  void initState() {
    super.initState();
    _undercovers = widget.configuration.undercovers;
    _mrWhites = widget.configuration.mrWhites;
  }

  @override
  void didUpdateWidget(RoleDistributionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.configuration != widget.configuration) {
      _undercovers = widget.configuration.undercovers;
      _mrWhites = widget.configuration.mrWhites;
    }
  }

  int get _civilians => widget.configuration.totalPlayers - _undercovers - _mrWhites;

  void _updateConfiguration() {
    // Ensure we have at least 1 impostor
    if (_undercovers + _mrWhites == 0) {
      return;
    }
    
    // Ensure civilians are not negative or zero
    if (_civilians <= 0) {
      return;
    }
    
    // Ensure civilians are at least equal to impostors (game balance)
    if (_civilians < (_undercovers + _mrWhites)) {
      return;
    }

    final newConfig = GameConfiguration(
      totalPlayers: widget.configuration.totalPlayers,
      civilians: _civilians,
      undercovers: _undercovers,
      mrWhites: _mrWhites,
    );
    
    widget.onConfigurationChanged(newConfig);
  }

  void _adjustRole(String role, int delta) {
    setState(() {
      switch (role) {
        case 'undercovers':
          int newUndercovers = (_undercovers + delta).clamp(0, widget.configuration.totalPlayers - 1);
          int newCivilians = widget.configuration.totalPlayers - newUndercovers - _mrWhites;
          
          // Check if the new configuration is valid
          if (newCivilians > 0 && newCivilians >= (newUndercovers + _mrWhites) && (newUndercovers + _mrWhites) > 0) {
            _undercovers = newUndercovers;
          }
          break;
          
        case 'mrWhites':
          int newMrWhites = (_mrWhites + delta).clamp(0, widget.configuration.totalPlayers - 1);
          int newCivilians = widget.configuration.totalPlayers - _undercovers - newMrWhites;
          
          // Check if the new configuration is valid
          if (newCivilians > 0 && newCivilians >= (_undercovers + newMrWhites) && (_undercovers + newMrWhites) > 0) {
            _mrWhites = newMrWhites;
          }
          break;
      }
      
      _updateConfiguration();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isValid = _civilians > 0 && 
                   _civilians >= (_undercovers + _mrWhites) &&
                   (_undercovers + _mrWhites) > 0;

    return Column(
      children: [
        // Role counters display
        Row(
          children: [
            const Text(
              'Remaining Roles:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                'Civilians: $_civilians',
                style: const TextStyle(fontSize: 12),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                'Impostors: ${_undercovers + _mrWhites}',
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 20),
        
        // Special Roles Section
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        
        const SizedBox(height: 20),
        
        // Role Distribution Cards
        Expanded(
          child: Column(
            children: [
              // Civilians (read-only)
              _buildRoleCard(
                'Civilians',
                _civilians,
                Colors.blue,
                Icons.people,
                null, // No decrease button
                null, // No increase button
                isReadOnly: true,
              ),
              const SizedBox(height: 15),
              _buildRoleCard(
                'Undercovers',
                _undercovers,
                Colors.red,
                Icons.person,
                () => _adjustRole('undercovers', -1),
                () => _adjustRole('undercovers', 1),
              ),
              const SizedBox(height: 15),
              _buildRoleCard(
                'Mr. White',
                _mrWhites,
                Colors.grey,
                Icons.person_outline,
                () => _adjustRole('mrWhites', -1),
                () => _adjustRole('mrWhites', 1),
              ),
            ],
          ),
        ),
        
        // Validation message
        if (!isValid)
          Container(
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(5),
            ),
            child: const Text(
              'Invalid configuration! Ensure civilians ≥ impostors and at least 1 impostor.',
              style: TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }

  Widget _buildRoleCard(
    String title,
    int count,
    Color color,
    IconData icon,
    VoidCallback? onDecrease,
    VoidCallback? onIncrease, {
    bool isReadOnly = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ),
          if (!isReadOnly) ...[
            IconButton(
              onPressed: onDecrease,
              icon: const Icon(Icons.remove_circle_outline),
              color: color,
            ),
          ] else ...[
            const SizedBox(width: 48), // Placeholder space for alignment
          ],
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                count.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          if (!isReadOnly) ...[
            IconButton(
              onPressed: onIncrease,
              icon: const Icon(Icons.add_circle_outline),
              color: color,
            ),
          ] else ...[
            const SizedBox(width: 48), // Placeholder space for alignment
          ],
        ],
      ),
    );
  }
}