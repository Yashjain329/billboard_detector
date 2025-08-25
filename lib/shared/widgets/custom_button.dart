import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final Color? backgroundColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.backgroundColor,
    this.borderRadius = 12,
    this.padding = const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? Theme.of(context).primaryColor;

    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(borderRadius),
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadius),
        onTap: onPressed,
        splashColor: Colors.white24,
        highlightColor: Colors.white10,
        child: Container(
          padding: padding,
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