import 'package:equatable/equatable.dart';

class ToDoEntryModel extends Equatable {
  final String description;
  final bool isDone;
  final String id;

  const ToDoEntryModel(
      {required this.description, required this.isDone, required this.id});

  factory ToDoEntryModel.fromJson(Map<String, dynamic> json) => ToDoEntryModel(
      description: json['description'], isDone: json['isDone'], id: json['id']);

  factory ToDoEntryModel.empty() {
    return ToDoEntryModel(
      id: '',
      description: '',
      isDone: false,
    );
  }

  Map<String, dynamic> toJson(ToDoEntryModel entry) => {
        'id': entry.id,
        'description': entry.description,
        'isDone': entry.isDone
      };

  ToDoEntryModel copyWith({String? description, bool? isDone}) {
    return ToDoEntryModel(
        description: description ?? this.description,
        isDone: isDone ?? this.isDone,
        id: id);
  }

  @override
  List<Object?> get props => [description, isDone, id];


}
