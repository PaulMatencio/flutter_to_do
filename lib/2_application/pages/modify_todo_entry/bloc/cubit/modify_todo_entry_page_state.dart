

part of 'modify_todo_entry_page_cubit.dart';

class ModifyToDoEntryPageState extends Equatable {

  const ModifyToDoEntryPageState({ this.description});
  final FormValue<String?>? description;

  ModifyToDoEntryPageState copyWith({FormValue<String?>? description}) {
    return ModifyToDoEntryPageState(
      description: description ?? this.description,
    );
  }


  @override
  List<Object?> get props => [ description];
}