import 'package:flutter/material.dart';

class AnimatedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;

  const AnimatedButton({super.key, required this.onPressed, required this.child});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onPressed,
        splashColor: Colors.white24,
        highlightColor: Colors.white10,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          alignment: Alignment.center,
          child: DefaultTextStyle(
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            child: child,
          ),
        ),
      ),
    );
  }
}