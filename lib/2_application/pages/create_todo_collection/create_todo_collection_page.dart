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
      icon: Icons.add_task_rounded,
      name: 'create_todo_collection',
      child: CreateToDoCollectionPageProvider());

  @override
  State<CreateToDoCollectionPage> createState() =>
      _CreateToDoCollectionPageState();
}

class _CreateToDoCollectionPageState extends State<CreateToDoCollectionPage> {

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final int maxColorIndex = ToDoColor.predefinedColors.length -1;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Form(
          key: _formKey,
          child: Column(children: [
            SizedBox(
              height: 20,
            ),
            _CollectionTitleField(),
            SizedBox(
              height: 20,
            ),
            _CollectionColorField(maxColorIndex: maxColorIndex),
            SizedBox(
              height: 20,
            ),
            _SubmissionButton(formKey: _formKey,text:'save collection')
          ])),
    );
  }
}


class _SubmissionButton extends StatelessWidget {
  const _SubmissionButton({
    super.key,
    required GlobalKey<FormState> formKey,
    required this.text
  }) : _formKey = formKey;

  final GlobalKey<FormState> _formKey;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll<Color>(theme.colorScheme.primary),
          foregroundColor: WidgetStatePropertyAll<Color>(theme.colorScheme.inversePrimary),
          textStyle: WidgetStatePropertyAll<TextStyle>(theme.textTheme.titleSmall!),
        ),
        onPressed: () {
          final isValid = _formKey.currentState?.validate();
          if (isValid == true) {
            context.read<CreateToDoCollectionPageCubit>().submit();
            context.pop();
          }
        },
        child: Text('Save Collection'));
  }
}


class _CollectionColorField extends StatelessWidget {
  const _CollectionColorField({
    super.key,
    required this.maxColorIndex,
  });

  final int maxColorIndex;

  @override
  Widget build(BuildContext context) {
    final  theme = Theme.of(context);
    return TextFormField(
        initialValue: '',
        decoration: InputDecoration(
          icon: const Icon(Icons.color_lens),
          enabledBorder:  OutlineInputBorder(
            borderSide: BorderSide(width: 1.0,color:theme.colorScheme.primary),
          ),
          focusedBorder:  OutlineInputBorder(
            borderSide: BorderSide(width: 1.0, color:theme.colorScheme.inversePrimary),
          ),
          labelText: 'color',
          helperText: 'should  be a number between 0 and $maxColorIndex',
        ),
        onChanged: (value) =>
            context.read<CreateToDoCollectionPageCubit>().colorChanged(value),
        validator: (value) {
          String invalidIndex =
              'Please enter a number between 0 and $maxColorIndex';
          if (value != null && value.isNotEmpty) {
            final int ? parsedColorIndex = int.tryParse(value);
            if (parsedColorIndex  == null) {
              return invalidIndex;
            }
            if (parsedColorIndex < 0 || parsedColorIndex > maxColorIndex) {
              return invalidIndex;
            }
            return null;
          } else {
            return invalidIndex;
          }
        });
  }
}

class _CollectionTitleField extends StatelessWidget {
  const _CollectionTitleField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final  theme = Theme.of(context);
    return TextFormField(
        initialValue: '',
        decoration: InputDecoration(
          icon: const Icon(Icons.title_outlined),
          enabledBorder:  OutlineInputBorder(
            borderSide: BorderSide(width: 1.0, color:theme.colorScheme.primary),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1.0, color:theme.colorScheme.inversePrimary),
          ),
          labelText: 'Title',
          helperText: 'Title should not be empty',
        ),
        onChanged: (value) {
          context.read<CreateToDoCollectionPageCubit>().titleChanged(value);
        },
        validator: (value) {
          return (value == null || value.isEmpty)
              ? 'Please enter a title'
              : null;
        });
  }
}
