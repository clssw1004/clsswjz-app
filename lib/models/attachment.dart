class Attachment {
  final String id;
  final String originName;
  final int fileLength;
  final String extension;
  final String contentType;
  final String businessCode;
  final String businessId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Attachment({
    required this.id,
    required this.originName,
    required this.fileLength,
    required this.extension,
    required this.contentType,
    required this.businessCode,
    required this.businessId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) {
    return Attachment(
      id: json['id'] as String,
      originName: json['originName'] as String,
      fileLength: json['fileLength'] as int,
      extension: json['extension'] as String,
      contentType: json['contentType'] as String,
      businessCode: json['businessCode'] as String,
      businessId: json['businessId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'originName': originName,
    'fileLength': fileLength,
    'extension': extension,
    'contentType': contentType,
    'businessCode': businessCode,
    'businessId': businessId,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };
} 