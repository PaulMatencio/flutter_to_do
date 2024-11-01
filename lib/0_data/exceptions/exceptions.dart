class ServerException implements Exception {
  final String  ? stackTrace;
  ServerException({required this.stackTrace});
}

class CacheException implements Exception {
  final String ? stackTrace;
  CacheException({this.stackTrace});
}

class CollectionNotFoundException  implements  Exception{
  final String ? stackTrace;
  CollectionNotFoundException({this.stackTrace});
}

class EntryNotFoundException  implements  Exception{
  final String ? stackTrace;
  EntryNotFoundException({this.stackTrace});
}

class GeneralException  implements  Exception{
  final String ? stackTrace;
  GeneralException({this.stackTrace});
}

class DataException implements Exception{
  final String stackTrace;
  DataException({required this.stackTrace});
}