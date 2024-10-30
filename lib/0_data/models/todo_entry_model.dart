import 'package:equatable/equatable.dart';

class ToDoEntryModel extends Equatable {
  final String description;
  final bool isDone;
  final String id;

  const ToDoEntryModel(
      {required this.description, required this.isDone, required this.id});

  factory ToDoEntryModel.fromJson(Map<String, dynamic> json) => ToDoEntryModel(
      description: json['description'], isDone: json['isDone'], id: json['id']);

  Map<String, dynamic> toJson(ToDoEntryModel entry) => {
        'id': entry.id,
        'description': entry.description,
        'isDone': entry.isDone
      };

  @override
  List<Object?> get props => [description, isDone, id];
}
