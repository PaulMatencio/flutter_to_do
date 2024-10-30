import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todo_app/1_domain/entities/todo_entry.dart';
import 'package:todo_app/1_domain/entities/unique_id.dart';
import 'package:todo_app/1_domain/use_cases/create_todo_entry.dart';
import 'package:todo_app/2_application/core/form_value.dart';
import 'package:todo_app/core/use_case.dart';

part 'create_todo_entry_page_state.dart';

class CreateToDoEntryPageCubit extends Cubit<CreateToDoEntryPageState> {
  CreateToDoEntryPageCubit(
      {required this.createToDoEntry, required this.collectionId})
      : super(CreateToDoEntryPageState());

  final CreateToDoEntry createToDoEntry;
  final CollectionId collectionId;

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
    final todoEntry = ToDoEntry.empty()
        .copyWith(description: state.description!.value, isDone: false);
    await createToDoEntry
        .call(ToDoEntryParams(entry: todoEntry, collectionId: collectionId))
        .then((entryId) => entryId.fold((left) => null, (right) => true));
  }

  /*
  void submit() {}

   */
}
