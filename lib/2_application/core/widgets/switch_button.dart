//
//   lib/2_application/core/widgets/switch_button/switch_button.dart
//


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/2_application/core/services/theme_service.dart';




class SwitchButton extends StatefulWidget {
  const SwitchButton({super.key});
  @override
  State<SwitchButton> createState() => _SwitchButtonState();
}

class _SwitchButtonState extends State<SwitchButton> {
  void onChanged(bool value) {
    //  Toggle the theme
    Provider.of<ThemeService>(context, listen: false).toggleTheme();
  }

  @override
  Widget build(BuildContext context) {
    //  Listen to the SwitchState change notification
    return Consumer<ThemeService>(builder: ((context, themeService, child) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Switch(
            value: themeService.getTheme(),
            splashRadius: 40,
            activeColor: Theme.of(context).colorScheme.inversePrimary,
            thumbIcon: const WidgetStatePropertyAll(Icon(Icons.play_arrow)),
            inactiveThumbColor: Theme.of(context).colorScheme.primary,
            onChanged: (value) => onChanged(value)),
      );
    }));
  }
}