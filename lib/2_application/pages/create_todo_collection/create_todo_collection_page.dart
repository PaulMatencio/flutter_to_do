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
    final int maxColorIndex = ToDoColor.predefinedColors.length + 1;
    return Form(
        key: _formKey,
        child: Column(children: [
          SizedBox(
            height: 16,
          ),
          _CollectionTitleField(),
          SizedBox(
            height: 16,
          ),
          _CollectionColorField(maxColorIndex: maxColorIndex),
          SizedBox(
            height: 16,
          ),
          _SubmissionButton(formKey: _formKey)
        ]));
  }
}


class _SubmissionButton extends StatelessWidget {
  const _SubmissionButton({
    super.key,
    required GlobalKey<FormState> formKey,
  }) : _formKey = formKey;

  final GlobalKey<FormState> _formKey;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
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
    return TextFormField(
        initialValue: '',
        decoration: InputDecoration(
          icon: const Icon(Icons.color_lens),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 1.0, color: Colors.black),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 1.0, color: Colors.white),
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
            final int parsedColorIndex = int.parse(value);
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
    return TextFormField(
        initialValue: '',
        decoration: InputDecoration(
          icon: const Icon(Icons.title_outlined),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 1.0, color: Colors.black),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 1.0, color: Colors.white),
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
