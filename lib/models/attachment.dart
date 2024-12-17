class Attachment {
  final String id;
  final String originName;
  final int fileLength;
  final String extension;
  final String contentType;
  final String businessCode;
  final String businessId;
  final String? createdAt;
  final String? updatedAt;

  const Attachment({
    required this.id,
    required this.originName,
    required this.fileLength,
    required this.extension,
    required this.contentType,
    required this.businessCode,
    required this.businessId,
    this.createdAt,
    this.updatedAt,
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
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
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
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };
}
