import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/1_domain/entities/todo_color.dart';

class ColorPickerDemo extends StatefulWidget {
  const ColorPickerDemo({super.key});
  @override
  State<ColorPickerDemo> createState() => _ColorPickerDemoState();
}

class _ColorPickerDemoState extends State<ColorPickerDemo> {
  Color selectedColor = ToDoColor.predefinedColors[0]; // Initial color

  final Map<ColorSwatch<Object>, String> colorsNameMap = {
    for (final color in ToDoColor.predefinedColors.map(
      (color) => ColorTools.createPrimarySwatch(color),
    ))
      color: color.toString()
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 30,
              height: 30,
              /*
              decoration: const BoxDecoration(
                shape: BoxShape.circle,

              ),
              
               */
              color: selectedColor,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _openColorPicker,
              child: const Text('Pick a Color'),
            ),
          ],
        ),
      ),
    );
  }

  // Function to open the color picker dialog
  Future<void> _openColorPicker() async {
    final Map<ColorSwatch<Object>, String> colorsNameMap = {
      for (final color in ToDoColor.predefinedColors.map(
            (color) => ColorTools.createPrimarySwatch(color),
      ))
        color: color.toString()
    };
    bool pickedColor = await ColorPicker(
      color: selectedColor,
      onColorChanged: (Color newColor) {
        setState(() {
          selectedColor = newColor;
        });
      },
      width: 40,
      height: 40,
      borderRadius: 20,
      spacing: 10,
      runSpacing: 10,
      heading: const Text('Pick a color'),
      subheading: const Text('Selected color'),
      wheelDiameter: 200,
      wheelWidth: 20,
      customColorSwatchesAndNames: colorsNameMap,
    ).showPickerDialog(
      context,
      actionsPadding: const EdgeInsets.all(16),
      constraints:
          const BoxConstraints(minHeight: 480, minWidth: 300, maxWidth: 320),
    );
    print(pickedColor);
    if (pickedColor) {
      final colorValue = selectedColor.value;
      print(selectedColor);
      String colorString = colorValue.toString();
      int newValue = int.parse(colorString);
      Color newColor = Color(newValue);
      print(newColor);
    }
  }
}
