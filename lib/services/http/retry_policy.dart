class RetryPolicy {
  final int maxAttempts;
  final Duration delay;

  const RetryPolicy({
    this.maxAttempts = 3,
    this.delay = const Duration(seconds: 1),
  });

  Future<T> retry<T>(Future<T> Function() operation) async {
    int attempts = 0;
    while (true) {
      try {
        attempts++;
        return await operation();
      } catch (e) {
        if (attempts >= maxAttempts) {
          rethrow;
        }
        await Future.delayed(delay * attempts);
      }
    }
  }
}
