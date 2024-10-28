
// import 'package:equatable/equatable.dart';
part of 'create_todo_entry_page_cubit.dart';

class CreateToDoEntryPageState extends Equatable {

  final CollectionId ?  collectionId;
  final String ? description ;


  const CreateToDoEntryPageState({this.collectionId, this.description});

  //methods
  CreateToDoEntryPageState copyWith({CollectionId ? collectionId, String ?  description,bool ? isDone}) {
   return CreateToDoEntryPageState(
   collectionId: collectionId ??  this.collectionId,
   description: description ??  this.description  ,
   );
  }

  @override
  List<Object?> get props => [collectionId, description];
}