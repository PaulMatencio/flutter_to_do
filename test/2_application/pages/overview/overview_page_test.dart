//
//!  lib/test/2_application/pages/overview/overview_page_test.dart
//


import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/2_application/pages/overview/view_states/todo_overview_error.dart';


void main() {
  Widget widgetUnderTest() {
    return const MaterialApp(
      home: Scaffold(
        body: ToDoOverviewError(),
      ),
    );
  }
  group('ToDoOverviewError test:', () {
    final errorMessage = 'ERROR, please try again';
    testWidgets(
      'Should rendered correctly',
          (widgetTester) async {
        await widgetTester.pumpWidget(widgetUnderTest());
        await widgetTester.pumpAndSettle();
        expect(find.byType(Card), findsOneWidget);
        expect(find.text(errorMessage), findsOneWidget);
      },
    );
  });

}

