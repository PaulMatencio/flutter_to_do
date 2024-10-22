//
//!  lib/test/2_application/pages/overview/view_states/todo_overview_loading_test.dart
//

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/2_application/pages/overview/view_states/todo_overview_loading.dart';

void main() {
  Widget widgetUnderTest() {
    return MaterialApp(home: ToDoOverviewLoading());
  }

  group('TodoOverviewLoading test', () {
    testWidgets('Should show the CircularProgressIndicator widget',
        (widgetTester) async {
      await widgetTester.pumpWidget(widgetUnderTest());
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
