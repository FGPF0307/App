import 'package:flutter/material.dart';

const Color _cream = Color(0xFFE1E2D6);
const Color _green = Color(0xFFCFE99F);
const Color _black = Color(0xFF111111);

/// Dialog informasi (1 tombol). Estetika app: sudut siku (radius 0),
/// tanpa border (stroke 0), latar cream.
Future<void> showFitInfoDialog(
  BuildContext context, {
  required String title,
  required String message,
  String buttonText = 'OK',
}) {
  return showDialog<void>(
    context: context,
    builder: (ctx) => _FitDialog(
      title: title,
      message: message,
      actions: [
        _FitDialogButton(
          label: buttonText,
          filled: true,
          onTap: () => Navigator.pop(ctx),
        ),
      ],
    ),
  );
}

/// Dialog konfirmasi (YES / NO). Mengembalikan true bila user menekan YES.
Future<bool> showFitConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  String yesText = 'YES',
  String noText = 'NO',
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => _FitDialog(
      title: title,
      message: message,
      actions: [
        _FitDialogButton(
          label: noText,
          filled: false,
          onTap: () => Navigator.pop(ctx, false),
        ),
        _FitDialogButton(
          label: yesText,
          filled: true,
          onTap: () => Navigator.pop(ctx, true),
        ),
      ],
    ),
  );
  return result ?? false;
}

class _FitDialog extends StatelessWidget {
  final String title;
  final String message;
  final List<Widget> actions;
  const _FitDialog({
    required this.title,
    required this.message,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: _cream,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'BebasNeue',
                fontSize: 28,
                letterSpacing: 1.0,
                color: _black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: const TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 14,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                for (int i = 0; i < actions.length; i++) ...[
                  if (i > 0) const SizedBox(width: 12),
                  Expanded(child: actions[i]),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FitDialogButton extends StatelessWidget {
  final String label;
  final bool filled;
  final VoidCallback onTap;
  const _FitDialogButton({
    required this.label,
    required this.filled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        alignment: Alignment.center,
        color: filled ? _black : Colors.white,
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'BebasNeue',
            fontSize: 22,
            letterSpacing: 1.0,
            color: filled ? _green : _black,
          ),
        ),
      ),
    );
  }
}
