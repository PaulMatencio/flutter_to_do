//
//!   lib/test/2_application/bloc/todo_overview_cubit_test.dart
//

import 'package:bloc_test/bloc_test.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_app/2_application/pages/overview/bloc/todo_overview_cubit.dart';
import 'package:todo_app/core/use_case.dart';
import 'package:todo_app/1_domain/entities/todo_collection.dart';
import 'package:todo_app/1_domain/entities/todo_color.dart';
import 'package:todo_app/1_domain/entities/unique_id.dart';
import 'package:todo_app/1_domain/failures/failures.dart';
import 'package:todo_app/1_domain/use_cases/load_todo_collections.dart';

class MockLoadToDoCollections extends Mock implements LoadToDoCollections {}

final List<ToDoCollection> toDoCollections = [
  ToDoCollection(
    id: CollectionId.fromUniqueString(1.toString()),
    title: 'test todoOverview cubit #1',
    color: ToDoColor(colorIndex: 1),
  ),
  ToDoCollection(
    id: CollectionId.fromUniqueString(2.toString()),
    title: 'test todoOverview cubit #2',
    color: ToDoColor(colorIndex: 1),
  )
];

void main() {
  group('ToDoOverviewCubit blocTest', () {
    final mockLoadToDoCollections = MockLoadToDoCollections();
    final expectedCollections = Right<Failure, List<ToDoCollection>>(toDoCollections);
    final expectedServerFailure =
        Left<Failure, List<ToDoCollection>>(ServerFailure());
    final expectedGeneralFailure = Left<Failure,List<ToDoCollection>>(GeneralFailure());
    blocTest<ToDoOverviewCubit, ToDoOverviewCubitState>(
      'emits [ToDoOverviewCubitLoadingState, ToDoOverviewCubitLoadedState] when ToDoOverview is called.',
      setUp: () {
        when(() => mockLoadToDoCollections(NoParams()))
            .thenAnswer((_) => Future.value(expectedCollections));
      },
      build: () => ToDoOverviewCubit(
        loadToDoCollections: mockLoadToDoCollections,
      ),
      act: (ToDoOverviewCubit bloc) => bloc.readToDoCollections(),
      expect: () => <ToDoOverviewCubitState>[
        ToDoOverviewCubitLoadingState(),
        ToDoOverviewCubitLoadedState(
            collections:
                expectedCollections.fold((_) => [], (collections) => collections))
      ],
    );

    blocTest<ToDoOverviewCubit, ToDoOverviewCubitState>(
      'emits [ToDoOverviewCubitLoadingState, ToDoOverviewCubitErrorState] when TodoUseCase is called and error occurred.',
      setUp: () {
        when(() => mockLoadToDoCollections(NoParams()))
            .thenAnswer((_) => Future.value(expectedGeneralFailure));
      },
      build: () => ToDoOverviewCubit(
        loadToDoCollections: mockLoadToDoCollections,
      ),
      act: (ToDoOverviewCubit bloc) => bloc.readToDoCollections(),
      expect: () => <ToDoOverviewCubitState>[
        ToDoOverviewCubitLoadingState(),
        ToDoOverviewCubitErrorState(message: 'Ups,something went wrong. Please try again')
      ],
    );

    blocTest<ToDoOverviewCubit, ToDoOverviewCubitState>(
      'emits [ToDoOverviewCubitLoadingState, ToDoOverviewCubitErrorState] when TodoUseCase is called and error occurred.',
      setUp: () {
        when(() => mockLoadToDoCollections(NoParams()))
            .thenAnswer((_) => Future.value(expectedServerFailure));
      },
      build: () => ToDoOverviewCubit(
        loadToDoCollections: mockLoadToDoCollections,
      ),
      act: (ToDoOverviewCubit bloc) => bloc.readToDoCollections(),
      expect: () => <ToDoOverviewCubitState>[
        ToDoOverviewCubitLoadingState(),
        ToDoOverviewCubitErrorState(message: 'Ups, Api error')
      ],
    );
  });
}
