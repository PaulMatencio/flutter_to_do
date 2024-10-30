class ServerException implements Exception {
  final String  ? stackTrace;
  ServerException({required this.stackTrace});
}

class CacheException implements Exception {}

class DataException implements Exception{
  final String stackTrace;
  DataException({required this.stackTrace});
}