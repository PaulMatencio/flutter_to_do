import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/1_domain/failures/failures.dart';
import 'package:todo_app/1_domain/repositories/todo_repository.dart';
import 'package:todo_app/core/use_case.dart';



class DeleteUserCollections implements UseCase<bool, NoParams> {
  DeleteUserCollections({required this.toDoRepository});
  // final collection toDoCollection;
  final ToDoRepository toDoRepository;
  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    debugPrint('deleteUserCollections');
    try {
      final result = await toDoRepository.deleteUserCollections();
      return result.fold(
            (left) => Left(left),
            (right) => Right(true),
      );
    } on Exception catch (e) {
      return Left(ServerFailure(stackTrace: e.toString()));
    }
  }
}

