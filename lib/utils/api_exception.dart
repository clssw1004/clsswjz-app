class ApiException implements Exception {
  final int? statusCode;
  final String? body;
  final String message;

  ApiException({
    this.statusCode,
    this.body,
    required this.message,
  });

  @override
  String toString() {
    return '''
API Error:
Status Code: ${statusCode ?? 'N/A'}
Message: $message
Response Body: ${body ?? 'N/A'}
''';
  }
}
