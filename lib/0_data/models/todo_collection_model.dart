import 'package:equatable/equatable.dart';

class ToDoCollectionModel extends Equatable {
  final int colorIndex;
  final String title;
  final String id;

  const ToDoCollectionModel({required this.colorIndex, required this.title, required this.id});

  factory ToDoCollectionModel.fromJson(Map<String, dynamic> json) =>
      ToDoCollectionModel(id: json['id'], title: json['title'], colorIndex: json['colorIndex']);

  Map<String, dynamic> toJson() => <String, dynamic>{'id': id, 'title': title, 'colorIndex': colorIndex};

  @override
  List<Object?> get props => [colorIndex, title, id];
}
