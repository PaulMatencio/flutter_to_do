//
//!   test/1_domain/use_case/load_todo_collections_test.dart
//


import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_app/1_domain/entities/todo_collection.dart';
import 'package:todo_app/1_domain/entities/todo_color.dart';
import 'package:todo_app/1_domain/entities/unique_id.dart';
import 'package:todo_app/1_domain/failures/failures.dart' as failure;
import 'package:todo_app/1_domain/failures/failures.dart';
import 'package:todo_app/1_domain/repositories/todo_repository.dart';
import 'package:todo_app/1_domain/use_cases/load_todo_collections.dart';
import 'package:todo_app/core/use_case.dart';


class ToDoRepositoryMock extends Mock implements ToDoRepository {}


//
//!
//
final toDoCollections = List<ToDoCollection>.generate(
  20,
      (index) => ToDoCollection(
    id: CollectionId.fromUniqueString(index.toString()),
    title: 'title $index',
    color: ToDoColor(
      colorIndex: index % ToDoColor.predefinedColors.length,
    ),
  ),
);

void main() {

  final toDoRepository = ToDoRepositoryMock();

  group('ToDoUseCase test:', () {
    final toDoUseCaseUnderTest =
    LoadToDoCollections(toDoRepository: toDoRepository);  // mock

    group('Should return ToDoCollection', () {
      test('when ToDoRepository returns ToDoModel', () async {

        final fakeCollections = Right<failure.Failure, List<ToDoCollection>>(toDoCollections);  //! ==  List<ToDoCollections>
        //read ToDoCollection
        when(() => toDoRepository.readToDoCollections())
            .thenAnswer((_) => Future.value(fakeCollections));

        //  call(NoParams params)
        final result = await toDoUseCaseUnderTest.call(NoParams());

        expect(result.isLeft, false);
        expect(result.isRight, true);
        expect(result, fakeCollections);  //!   fakeCollections

        verify(() => toDoRepository.readToDoCollections()).called(1);

        verifyNoMoreInteractions(toDoRepository);
      });
    });

    group('Should return Failure', () {
      test('when TodoRepository returns Failure', () async {

        final failures = Left<failure.Failure, List<ToDoCollection>>(ServerFailure()); //! failure

        when(() => toDoRepository.readToDoCollections())
            .thenAnswer((realInvocation) => Future.value(failures));

        final result = await toDoUseCaseUnderTest.call(NoParams());

        expect(result.isLeft, true);
        expect(result.isRight, false);
        expect(result, failures);  //!  ServerFailure()
        verify(() => toDoRepository.readToDoCollections()).called(1);
        verifyNoMoreInteractions(toDoRepository);
      });
    });
  });
}