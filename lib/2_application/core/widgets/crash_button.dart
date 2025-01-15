
import 'package:flutter/material.dart';
class CrashButton extends StatelessWidget {
  const CrashButton({super.key});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return
      TextButton(
          style: ButtonStyle(
            backgroundColor:
            WidgetStatePropertyAll<Color>(theme.colorScheme.onPrimary),
          ),
        onPressed: () => throw Exception(),
        child: const Text('crash test'));
      }
}
