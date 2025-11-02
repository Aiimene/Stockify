import 'package:flutter/material.dart';
import 'Colors.dart';
import 'Styles.dart';

// ===========================================================
// PRIMARY BUTTON
// ===========================================================
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const PrimaryButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: accentColor,
        foregroundColor: white1Color,
        textStyle: button1TextStyle,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 28.0),
      ),
      onPressed: onPressed,
      child: Text(label),
    );
  }
}

// ===========================================================
// SECONDARY BUTTON (Outlined)
// ===========================================================
class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const SecondaryButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: accentColor, width: 2),
        foregroundColor: accentColor,
        textStyle: button1TextStyle.copyWith(fontSize: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 28.0),
      ),
      onPressed: onPressed,
      child: Text(label),
    );
  }
}

// ===========================================================
// DESTRUCTIVE BUTTON
// ===========================================================
class DestructiveButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const DestructiveButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: errorColor, width: 1.5),
        foregroundColor: errorColor,
        textStyle: destructiveTextStyle,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 28.0),
      ),
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
