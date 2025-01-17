
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/1_domain/entities/todo_entry.dart';
import 'package:todo_app/1_domain/entities/unique_id.dart';
import 'package:todo_app/1_domain/repositories/todo_repository.dart';
import 'package:todo_app/1_domain/use_cases/modify_todo_entry.dart';
import 'package:todo_app/2_application/core/form_value.dart';
import 'package:todo_app/2_application/core/page_config.dart';
import 'package:todo_app/2_application/pages/modify_todo_entry/bloc/cubit/modify_todo_entry_page_cubit.dart';

//  callback function
typedef ToDoEntryItemModifiedCallback = Function();

class ModifyToDoEntryPageExtra {
  final CollectionId collectionId;
  final ToDoEntry toDoEntry;
  final ToDoEntryItemModifiedCallback toDoEntryItemModifiedCallback;

  ModifyToDoEntryPageExtra({
    required this.collectionId,
    required this.toDoEntry,
    required this.toDoEntryItemModifiedCallback,
  });
}

class ModifyToDoEntryPageProvider extends StatelessWidget {
  const ModifyToDoEntryPageProvider({
    super.key,
    required this.collectionId,
    required this.todoEntry,
    required this.toDoEntryItemModifiedCallback,
  });

  final CollectionId collectionId;
  final ToDoEntry todoEntry;
  final ToDoEntryItemModifiedCallback toDoEntryItemModifiedCallback;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ModifyToDoEntryPageCubit>(
        create: (context) => ModifyToDoEntryPageCubit(
              collectionId: collectionId,
              toDoEntry: todoEntry,
              modifyToDoEntry: ModifyToDoEntry(
                toDoRepository: RepositoryProvider.of<ToDoRepository>(context),
              ),
            ),
        child: ModifyToDoEntryPage(toDoEntryItemModifiedCallback: toDoEntryItemModifiedCallback, toDoEntry: todoEntry));
  }
}

class ModifyToDoEntryPage extends StatefulWidget {
  const ModifyToDoEntryPage({
    super.key,
    required this.toDoEntry,
    required this.toDoEntryItemModifiedCallback,
  });

  final ToDoEntry toDoEntry;
  final ToDoEntryItemModifiedCallback toDoEntryItemModifiedCallback;

  static const pageConfig = PageConfig(icon: Icons.update_rounded, name: 'modify_todo_entry', child: Placeholder());

  @override
  State<ModifyToDoEntryPage> createState() => _ModifyToDoEntryPageState();
}

class _ModifyToDoEntryPageState extends State<ModifyToDoEntryPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
          key: _formKey,
          child: Column(children: [
            SizedBox(
              height: 20,
            ),
            _EntryDescriptionField(
              toDoEntry: widget.toDoEntry,
            ),
            SizedBox(
              height: 20,
            ),
            _SubmissionButton(
              formKey: _formKey,
              toDoEntryItemModifiedCallback: widget.toDoEntryItemModifiedCallback,
            )
          ])),
    );
  }
}

class _EntryDescriptionField extends StatelessWidget {
  const _EntryDescriptionField({required this.toDoEntry});

  final ToDoEntry toDoEntry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<ModifyToDoEntryPageCubit, ModifyToDoEntryPageState>(
      builder: (context, state) {
        return TextFormField(
            initialValue: toDoEntry.description,
            decoration: InputDecoration(
              icon: const Icon(Icons.description),
              enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.0, color: theme.colorScheme.primary)),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1.0, color: theme.colorScheme.inversePrimary),
              ),
              labelText: context.tr('todo_description'),
              helperText: context.tr('todo_description_helper_text'),
            ),
            onChanged: (value) => context.read<ModifyToDoEntryPageCubit>().descriptionChanged(description: value),
            validator: (value) {
              final currentValidationState =
                  context.read<ModifyToDoEntryPageCubit>().state.description?.validationStatus ??
                      ValidationStatus.pending;
              switch (currentValidationState) {
                case ValidationStatus.error:
                  return context.tr('todo_description_validation_error');
                case ValidationStatus.success:
                  return null;
                case ValidationStatus.pending:
                  return context.tr('todo_description_validation_pending');
              }
            });
      },
    );
  }
}

class _SubmissionButton extends StatelessWidget {
  const _SubmissionButton(
      {required GlobalKey<FormState> formKey, required this.toDoEntryItemModifiedCallback})
      : _formKey = formKey;

  final GlobalKey<FormState> _formKey;
  final ToDoEntryItemModifiedCallback toDoEntryItemModifiedCallback;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll<Color>(theme.colorScheme.primary),
          foregroundColor: WidgetStatePropertyAll<Color>(theme.colorScheme.inversePrimary),
          textStyle: WidgetStatePropertyAll<TextStyle>(theme.textTheme.titleSmall!),
        ),
        onPressed: () async {
          final isValid = _formKey.currentState?.validate();
          if (isValid == true) {
            context.read<ModifyToDoEntryPageCubit>().submit();
            //debugPrint('calling  toDoEntryItemModifiedCallback.  ');
            toDoEntryItemModifiedCallback.call();
            context.pop();
          }
        },
        child: Text('todo_save'.tr()));
  }
}
