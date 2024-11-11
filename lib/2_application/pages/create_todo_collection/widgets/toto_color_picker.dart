


import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/1_domain/entities/todo_color.dart';
import 'package:todo_app/2_application/pages/create_todo_collection/bloc/cubit/create_todo_collection_page_cubit.dart';

class ToDoColorPicker extends StatefulWidget {
  const ToDoColorPicker({super.key});
  @override
  State<ToDoColorPicker> createState() => _ToDoColorPickerState();
}

class _ToDoColorPickerState extends State<ToDoColorPicker> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //scrollBehavior: AppScrollBehavior(),
      title: 'ColorPicker',
      theme: ThemeData(useMaterial3: true),
      home: const ToDoColorPickerPage(),
    );
  }
}

class ToDoColorPickerPage extends StatefulWidget {
  const ToDoColorPickerPage({super.key});
  @override
  State<ToDoColorPickerPage> createState() => _ColorPickerPageState();
}



class _ColorPickerPageState extends State<ToDoColorPickerPage> {
  late Color  selectedColor; //
  final Map<ColorSwatch<Object>, String> customSwatches =
  <ColorSwatch<Object>, String>{
    const MaterialColor(0xFFfae738, <int, Color>{
      50: Color(0xFFfffee9),
      100: Color(0xFFfff9c6),
      200: Color(0xFFfff59f),
      300: Color(0xFFfff178),
      400: Color(0xFFfdec59),
      500: Color(0xFFfae738),
      600: Color(0xFFf3dd3d),
      700: Color(0xFFdfc735),
      800: Color(0xFFcbb02f),
      900: Color(0xFFab8923),
    }): 'Alpine',
    ColorTools.createPrimarySwatch(const Color(0xFFBC350F)): 'Rust',
    ColorTools.createAccentSwatch(const Color(0xFFB062DB)): 'Lavender',
  };
  //
  //
  //
  final Map<ColorSwatch<Object>, String> colorsNameMap = {
    for (final color in ToDoColor.predefinedColors.map(
          (color) => ColorTools.createPrimarySwatch(color),
    ))
      color: color.toString()
  };

  @override
  void initState() {
    selectedColor = ToDoColor.predefinedColors[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Pick a color'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        children: <Widget>[
          const SizedBox(height: 16),

          // Show the color picker in sized box in a raised card.
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Card(
                elevation: 2,
                child: ColorPicker(
                  // Use the screenPickerColor as color.
                  color: selectedColor,
                  // Update the screenPickerColor using the callback.
                  onColorChanged: (Color color) {
                    setState(() => selectedColor = color);
                    context
                        .read<CreateToDoCollectionPageCubit>()
                        .colorChanged(color as String);
                    },

                  width: 44,
                  height: 44,
                  borderRadius: 22,
                  heading: Text(
                    'Select color',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  customColorSwatchesAndNames: colorsNameMap,
                )
              ),
            ),
          ),

        ],
      ),
    );
  }
}
