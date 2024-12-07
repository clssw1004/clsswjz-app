import 'package:flutter/foundation.dart';

enum ServerType {
  selfHosted('自托管服务器'),
  clsswjzCloud('云服务'),
  localStorage('本地存储');

  final String label;
  const ServerType(this.label);
}

@immutable
class ServerConfig {
  final String id;
  final String name;
  final ServerType type;
  final String? serverUrl;
  final String? savedUsername;
  final String? savedPassword;

  const ServerConfig({
    required this.id,
    required this.name,
    required this.type,
    this.serverUrl,
    this.savedUsername,
    this.savedPassword,
  });

  factory ServerConfig.fromJson(Map<String, dynamic> json) {
    return ServerConfig(
      id: json['id'] as String,
      name: json['name'] as String,
      type: ServerType.values.byName(json['type'] as String),
      serverUrl: json['serverUrl'] as String?,
      savedUsername: json['savedUsername'] as String?,
      savedPassword: json['savedPassword'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.name,
      'serverUrl': serverUrl,
      'savedUsername': savedUsername,
      'savedPassword': savedPassword,
    };
  }

  ServerConfig copyWith({
    String? name,
    ServerType? type,
    String? serverUrl,
    String? savedUsername,
    String? savedPassword,
  }) {
    return ServerConfig(
      id: id,
      name: name ?? this.name,
      type: type ?? this.type,
      serverUrl: serverUrl ?? this.serverUrl,
      savedUsername: savedUsername ?? this.savedUsername,
      savedPassword: savedPassword ?? this.savedPassword,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServerConfig &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          type == other.type &&
          serverUrl == other.serverUrl &&
          savedUsername == other.savedUsername &&
          savedPassword == other.savedPassword;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      type.hashCode ^
      serverUrl.hashCode ^
      savedUsername.hashCode ^
      savedPassword.hashCode;
} 