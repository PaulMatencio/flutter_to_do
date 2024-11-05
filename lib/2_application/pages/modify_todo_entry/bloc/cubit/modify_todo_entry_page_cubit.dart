import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/1_domain/entities/todo_entry.dart';
import 'package:todo_app/1_domain/entities/unique_id.dart';
import 'package:todo_app/1_domain/use_cases/modify_todo_entry.dart';
import 'package:todo_app/2_application/core/form_value.dart';
import 'package:todo_app/core/use_case.dart';

part 'modify_todo_entry_page_state.dart';

class ModifyToDoEntryPageCubit extends Cubit<ModifyToDoEntryPageState> {
  ModifyToDoEntryPageCubit({
    required this.modifyToDoEntry,
    required this.collectionId,
    this.toDoEntry,
  }) : super(ModifyToDoEntryPageState());

  final ModifyToDoEntry modifyToDoEntry;
  final CollectionId collectionId;
  final ToDoEntry? toDoEntry;

  /*
  void descriptionChanged(String description) {
    emit(state.copyWith(description: description));
  }
   */
  void descriptionChanged({String? description}) {
    ValidationStatus currentStatus = ValidationStatus.pending;
    // could do more complex validation, like calling your backend and so on
    if (description == null || description.isEmpty || description.length < 2) {
      currentStatus = ValidationStatus.error;
    } else {
      currentStatus = ValidationStatus.success;
    }
    emit(
      state.copyWith(
        description: FormValue(
          value: description,
          validationStatus: currentStatus,
        ),
      ),
    );
  }

  Future<void> submit() async {
    final todoEntry =
        toDoEntry!.copyWith(description: state.description!.value);
    await modifyToDoEntry
        .call(ToDoEntryParams(entry: todoEntry, collectionId: collectionId))
        .then((result) => result.fold((left) => null, (right) {
              return true;
            }));
  }
}
