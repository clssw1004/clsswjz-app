class ApiException implements Exception {
  final int? statusCode;
  final String message;
  final String? body;

  ApiException({
    this.statusCode,
    required this.message,
    this.body,
  });

  @override
  String toString() => message;
}
