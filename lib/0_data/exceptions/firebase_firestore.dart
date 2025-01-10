
import 'package:todo_app/0_data/exceptions/exceptions.dart';

class FirebaseFireStoreException  implements  Exception {
  final String? stackTrace;
  FirebaseFireStoreException({required this.stackTrace});
}

class FireStoreCollectionNotFoundException implements ServerException {
  @override
  final String stackTrace ;
  FireStoreCollectionNotFoundException({required this.stackTrace});
}

class FireStoreEntryNotFoundException implements ServerException {
  @override
  final String stackTrace ;
  FireStoreEntryNotFoundException({required this.stackTrace});
}
