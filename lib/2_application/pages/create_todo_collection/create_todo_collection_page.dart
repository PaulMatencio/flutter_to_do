import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/1_domain/entities/todo_color.dart';
import 'package:todo_app/1_domain/repositories/todo_repository.dart';
import 'package:todo_app/1_domain/use_cases/create_todo_collection.dart';
import 'package:todo_app/2_application/core/page_config.dart';
import 'package:todo_app/2_application/pages/create_todo_collection/bloc/cubit/create_todo_collection_page_cubit.dart';

class CreateToDoCollectionPageProvider extends StatelessWidget {
  const CreateToDoCollectionPageProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CreateToDoCollectionPageCubit>(
      create: (context) => CreateToDoCollectionPageCubit(
        createToDoCollection: CreateToDoCollection(
          toDoRepository: RepositoryProvider.of<ToDoRepository>(context),
        ),
      ),
      child: const CreateToDoCollectionPage(),
    );
  }
}

class CreateToDoCollectionPage extends StatefulWidget {
  const CreateToDoCollectionPage({super.key});

  static const pageConfig = PageConfig(
      icon: Icons.add_task_rounded, name: 'create_todo_collection', child: CreateToDoCollectionPageProvider());

  @override
  State<CreateToDoCollectionPage> createState() => _CreateToDoCollectionPageState();
}

class _CreateToDoCollectionPageState extends State<CreateToDoCollectionPage> {
  final _formKey = GlobalKey<FormState>();
  final defaultColor = ToDoColor.predefinedColors[0];
  late Color selectedColor;

  @override
  void initState() {
    super.initState();
    selectedColor = defaultColor;

    /// default color from a ToDoColor tablet
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final int maxColorIndex = ToDoColor.predefinedColors.length - 1;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Form(
          key: _formKey,
          child: Column(children: [
            SizedBox(
              height: 20,
            ),
            TextFormField(
                initialValue: '',
                decoration: InputDecoration(
                  icon: const Icon(Icons.title_outlined),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1.0, color: theme.colorScheme.primary),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1.0, color: theme.colorScheme.inversePrimary),
                  ),
                  labelText: 'Title',
                  helperText: 'Title should not be empty',
                ),
                onChanged: (value) {
                  context.read<CreateToDoCollectionPageCubit>().titleChanged(value);
                },
                validator: (value) {
                  return (value == null || value.isEmpty) ? 'Please enter a title' : null;
                }),
            SizedBox(
              height: 20,
            ),
            TextFormField(
                controller: TextEditingController(text: selectedColor.value.toRadixString(16)),
                decoration: InputDecoration(
                    icon: const Icon(Icons.color_lens),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1.0, color: theme.colorScheme.primary),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1.0, color: theme.colorScheme.inversePrimary),
                    ),
                    labelText: 'color assignment',
                    helperText: 'should be a valid color value->  FF.... ',
                    suffixIcon: IconButton(
                        onPressed: () => _openColorPicker(context),
                        icon: Tooltip(
                            message: 'color selector',
                            child: Icon(
                              Icons.color_lens,
                              color: selectedColor,
                              size: 40,
                            )))),
                onChanged: (value) {
                  _openColorPicker(context);
                  // context.read<CreateToDoCollectionPageCubit>().colorChanged(value);
                },
                validator: (value) {
                  String invalidColor = 'Please enter valid color';
                  if (value != null && value.isNotEmpty) {
                    if (checkColor(value)) {
                      return null;
                    } else {
                      return invalidColor;
                    }
                  } else {
                    return invalidColor;
                  }
                }),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll<Color>(theme.colorScheme.primary),
                  foregroundColor: WidgetStatePropertyAll<Color>(theme.colorScheme.inversePrimary),
                  textStyle: WidgetStatePropertyAll<TextStyle>(theme.textTheme.titleSmall!),
                ),
                onPressed: () {
                  final isValid = _formKey.currentState?.validate();
                  if (isValid == true) {
                    context
                        .read<CreateToDoCollectionPageCubit>()
                        .submit(selectedColor.value)
                        .then((_) => context.pop(true));
                  }
                },
                child: Text('Save Collection')),
          ])),
    );
  }

  Future<void> _openColorPicker(BuildContext context) async {
    final Map<ColorSwatch<Object>, String> colorsNameMap = {
      for (final color in ToDoColor.predefinedColors.map(
        (color) => ColorTools.createPrimarySwatch(color),
      ))
        color: color.toString()
    };
    bool pickedColor = await ColorPicker(
      color: selectedColor,
      width: 40,
      height: 40,
      borderRadius: 20,
      spacing: 10,
      runSpacing: 10,
      heading: const Text('Pick a color'),
      subheading: const Text('This is your Selected color'),
      wheelDiameter: 200,
      wheelWidth: 20,
      customColorSwatchesAndNames: colorsNameMap,
      onColorChanged: (Color value) {
        setState(() {
          selectedColor = value;
        });
      },
    ).showPickerDialog(
      context,
      actionsPadding: const EdgeInsets.all(16),
      constraints: const BoxConstraints(minHeight: 480, minWidth: 300, maxWidth: 320),
    );
    if (pickedColor) {
      final colorValue = selectedColor.value;
      final value = colorValue.toRadixString(16);
      context.read<CreateToDoCollectionPageCubit>().colorChanged(value);
    } else {
      setState(() {
        selectedColor = defaultColor;
      });
    }
  }
}

///
///  check color
///

bool checkColor(String color) {
  try {
    Color(int.parse(color, radix: 16));
    return true;
  } on Exception catch (_) {
    return false;
  }
}
