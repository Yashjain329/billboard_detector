import 'package:flutter/material.dart';

class PasswordStrengthIndicator extends StatelessWidget {
  final String password;

  const PasswordStrengthIndicator({super.key, required this.password});

  @override
  Widget build(BuildContext context) {
    final strength = _calculateStrength(password);
    final strengthText = _strengthText(strength);
    final strengthColor = _strengthColor(strength);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgressIndicator(
          value: strength / 4,
          minHeight: 5,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation(strengthColor),
        ),
        const SizedBox(height: 4),
        Text(
          'Strength: $strengthText',
          style: TextStyle(
            color: strengthColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
      ],
    );
  }

  int _calculateStrength(String pwd) {
    int strength = 0;
    if (pwd.length >= 8) strength++;
    if (RegExp(r'[A-Z]').hasMatch(pwd)) strength++;
    if (RegExp(r'[0-9]').hasMatch(pwd)) strength++;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(pwd)) strength++;
    return strength;
  }

  String _strengthText(int strength) {
    switch (strength) {
      case 0:
      case 1:
        return 'Weak';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Strong';
      default:
        return '';
    }
  }

  Color _strengthColor(int strength) {
    switch (strength) {
      case 0:
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.blue;
      case 4:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}