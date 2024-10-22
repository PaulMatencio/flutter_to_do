//
//!   lib/test/2_application/pages/overview/view_states/todo_overview_loaded_test.dart
//

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/1_domain/entities/todo_collection.dart';
import 'package:todo_app/1_domain/entities/todo_color.dart';
import 'package:todo_app/1_domain/entities/unique_id.dart';
import 'package:todo_app/2_application/pages/overview/view_states/todo_overview_loaded.dart';

void main() {
  Widget widgetUnderTest({required List<ToDoCollection> collections}) {
    return MaterialApp(
        home: Scaffold(
            body: ToDoOverviewLoaded(
      collections: collections,
    )));
  }


    group('ToDoOverviewLoaded test', () {
      group('When a todo collections list was given ', () {
        testWidgets('Should rendered correctly', (widgetTester) async {
          final List<ToDoCollection> collections = [
            ToDoCollection(
              id: CollectionId.fromUniqueString(1.toString()),
              title: 'ToDoOverviewLoaded test #1',
              color: ToDoColor(
                colorIndex: 2,
              ),
            ),
            ToDoCollection(
              id: CollectionId.fromUniqueString(2.toString()),
              title: 'ToDoOverviewLoaded test #2',
              color: ToDoColor(
                colorIndex: 5,
              ),
            ),
          ];
          await widgetTester
              .pumpWidget(widgetUnderTest(collections: collections));
          await widgetTester.pumpAndSettle();
          //  find the listView   widget
          expect(find.byType(ListView), findsOneWidget);
          expect(find.byType(ListTile), findsNWidgets(collections.length));
          expect(find.text(collections[1].title), findsOneWidget);
        });
      });
    });
}
