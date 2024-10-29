import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/1_domain/entities/unique_id.dart';
import 'package:todo_app/1_domain/repositories/todo_repository.dart';
import 'package:todo_app/1_domain/use_cases/create_todo_entry.dart';
import 'package:todo_app/2_application/core/form_value.dart';
import 'package:todo_app/2_application/core/page_config.dart';
import 'package:todo_app/2_application/pages/create_todo_entry/bloc/cubit/create_todo_entry_page_cubit.dart';

class CreateToDoEntryPageProvider extends StatelessWidget {
  const CreateToDoEntryPageProvider({super.key, required this.collectionId});
  final CollectionId collectionId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CreateToDoEntryPageCubit>(
        create: (context) => CreateToDoEntryPageCubit(
              collectionId: collectionId,
              createToDoEntry: CreateToDoEntry(
                toDoRepository: RepositoryProvider.of<ToDoRepository>(context),
              ),
            ),
        child: CreateToDoEntryPage());
  }
}

class CreateToDoEntryPage extends StatefulWidget {
  const CreateToDoEntryPage({super.key});

  static const pageConfig = PageConfig(
      icon: Icons.add_task_rounded,
      name: 'create_todo_entry',
      child: CreateToDoEntryPage());

  @override
  State<CreateToDoEntryPage> createState() => _CreateToDoEntryPageState();
}

class _CreateToDoEntryPageState extends State<CreateToDoEntryPage> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(children: [
          SizedBox(
            height: 16,
          ),
          _EntryDescriptionField(),
          SizedBox(
            height: 16,
          ),
          _SubmissionButton(formKey: _formKey)
        ]));
  }
}

class _EntryDescriptionField extends StatelessWidget {
  const _EntryDescriptionField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextFormField(
        initialValue: '',
        decoration: InputDecoration(
          icon: const Icon(Icons.description),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1.0, color:theme.colorScheme.primary)
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1.0, color: theme.colorScheme.inversePrimary),
          ),
          labelText: 'description',
          helperText: 'any non empty text',
        ),
        onChanged: (value) =>
            context.read<CreateToDoEntryPageCubit>().descriptionChanged(description: value),
        validator: (value) {
          /*
          if (value != null && value.isNotEmpty) {
            return null;
          } else {
            return 'Please enter some description';
          }
           */
          final currentValidationState = context
                  .read<CreateToDoEntryPageCubit>()
                  .state
                  .description
                  ?.validationStatus ??
              ValidationStatus.pending;
          switch (currentValidationState) {
            case ValidationStatus.error:
              return 'This field needs at least two characters to be valid';
            case ValidationStatus.success:
              return null;
            case ValidationStatus.pending:
              return  'This  field is empty';
          }
        });
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
            context.read<CreateToDoEntryPageCubit>().submit();
            context.pop();
          }
        },
        child: Text('Save entry'));
  }
}
