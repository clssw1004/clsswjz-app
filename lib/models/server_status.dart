class ServerStatus {
  final String status;
  final String error;
  final String databaseStatus;
  final String memoryHeapUsed;
  final String memoryHeapTotal;

  const ServerStatus({
    required this.status,
    this.error = '',
    required this.databaseStatus,
    required this.memoryHeapUsed,
    required this.memoryHeapTotal,
  });

  factory ServerStatus.fromJson(Map<String, dynamic> json) {
    return ServerStatus(
      status: json['status'] as String,
      error: json['error'] as String? ?? '',
      databaseStatus: json['database']?['status'] as String? ?? 'unknown',
      memoryHeapUsed: json['memory']?['heapUsed'] as String? ?? '0',
      memoryHeapTotal: json['memory']?['heapTotal'] as String? ?? '0',
    );
  }

  factory ServerStatus.error(String errorMessage) {
    return ServerStatus(
      status: 'error',
      error: errorMessage,
      databaseStatus: 'unknown',
      memoryHeapUsed: '0',
      memoryHeapTotal: '0',
    );
  }
}
