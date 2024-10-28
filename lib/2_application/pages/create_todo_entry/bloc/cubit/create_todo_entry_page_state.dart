
part of 'create_todo_entry_page_cubit.dart';

class CreateToDoEntryPageState extends Equatable {

  /*
  final String ? description ;
  const CreateToDoEntryPageState({ this.description});

  //methods
  CreateToDoEntryPageState copyWith({CollectionId ? collectionId, String ?  description,bool ? isDone}) {
   return CreateToDoEntryPageState(
   // collectionId: collectionId ??  this.collectionId,
   description: description ??  this.description  ,
   );
  }
   */
  const CreateToDoEntryPageState({ this.description});
  final FormValue<String?>? description;

  CreateToDoEntryPageState copyWith({FormValue<String?>? description}) {
    return CreateToDoEntryPageState(
      description: description ?? this.description,
    );
  }

  @override
  List<Object?> get props => [ description];
}