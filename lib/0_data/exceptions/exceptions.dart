class ServerException implements Exception {
  final String  ? stackTrace;
  ServerException({required this.stackTrace});
}

class CacheExceptions implements Exception {}

class DataExceptions implements Exception{
  final String stackTrace;
  DataExceptions({required this.stackTrace});
}