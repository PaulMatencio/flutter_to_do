import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:todo_app/0_data/models/todo_collection_model.dart';
import 'package:todo_app/0_data/models/todo_entry_model.dart';
import 'package:todo_app/0_data/data_sources/local/hive_local_data_source.dart';

void main() {
  late HiveLocalDataSource  hiveLocalDataSource;
  late Directory tempDir;
  const  int colorIndex = 0xFF42A5F5;


  setUpAll(() {
    tempDir = Directory.systemTemp.createTempSync();
    Hive.init(tempDir.path);
  });

  setUp(() async{
    tempDir = Directory.systemTemp.createTempSync();
    Hive.init(tempDir.path);
    hiveLocalDataSource = HiveLocalDataSource();
    await hiveLocalDataSource.init();
  });

  tearDownAll(() async {
    tempDir.deleteSync(recursive: true);
  });

  testWidgets('Test initialization', (WidgetTester tester) async {

    final todoCollection = const ToDoCollectionModel(
        id: '1', title: 'Test Collection', colorIndex: colorIndex);
    final todoEntry =
    const ToDoEntryModel(id: '1', description: 'Test Entry', isDone: false);
    await hiveLocalDataSource.createToDoCollection(collection: todoCollection);
    await hiveLocalDataSource.createToDoEntry(
        collectionId: todoCollection.id, entryModel: todoEntry);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(builder: (BuildContext context) {
            final retrievedEntryFuture = hiveLocalDataSource.getToDoEntry(
                collectionId: todoCollection.id, entryId: todoEntry.id);

            return FutureBuilder(
                future: retrievedEntryFuture,
                builder: (BuildContext context,
                    AsyncSnapshot<ToDoEntryModel> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return Text(snapshot.data!.description);
                  }
                });
          }),
        ),
      ),
    );
  });
}