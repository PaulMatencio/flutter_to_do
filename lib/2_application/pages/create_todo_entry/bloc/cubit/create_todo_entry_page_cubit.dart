import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todo_app/1_domain/entities/todo_entry.dart';
import 'package:todo_app/1_domain/entities/unique_id.dart';
import 'package:todo_app/1_domain/use_cases/create_todo_entry.dart';
import 'package:todo_app/2_application/core/widgets/success_dialog.dart';
import 'package:todo_app/core/use_case.dart';

part 'create_todo_entry_page_state.dart';

class CreateToDoEntryPageCubit extends Cubit<CreateToDoEntryPageState> {
  CreateToDoEntryPageCubit(
      {required this.createToDoEntry, required this.collectionId})
      : super(CreateToDoEntryPageState(collectionId: collectionId));

  final CreateToDoEntry createToDoEntry;
  final CollectionId collectionId;

  void descriptionChanged(String description) {
    emit(state.copyWith(description: description));
  }

  void collectionIdChanged(CollectionId collectionId) {
    emit(state.copyWith(collectionId: collectionId));
  }

  Future<void> submit() async {
    final todoEntry = ToDoEntry.empty()
        .copyWith(description: state.description, isDone: false);
    await createToDoEntry
        .call(ToDoEntryParams(
            entry: todoEntry, collectionId: state.collectionId ?? collectionId))
        .then((entryId) => entryId.fold(
            (left) => null,
            (right) => print('ToDoEntry id: ${right.value} is saved')));
  }
}
