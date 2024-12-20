import 'package:flutter/material.dart';
import '../constants/language.dart';
import '../constants/timezone.dart';
import 'models.dart';

class UserInfoState {
  final User? userInfo;
  final TextEditingController nicknameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final String? inviteCode;
  final Language language;
  final String timezone;
  final bool isLoading;

  UserInfoState({
    this.userInfo,
    required this.nicknameController,
    required this.emailController,
    required this.phoneController,
    this.inviteCode,
    this.language = Language.ZH_CN,
    String? timezone,
    this.isLoading = true,
  }) : timezone = timezone ?? TimeZone.getDefaultTimeZone();

  factory UserInfoState.initial() {
    return UserInfoState(
      nicknameController: TextEditingController(),
      emailController: TextEditingController(),
      phoneController: TextEditingController(),
    );
  }

  UserInfoState copyWith({
    User? Function()? userInfo,
    TextEditingController? nicknameController,
    TextEditingController? emailController,
    TextEditingController? phoneController,
    String? Function()? inviteCode,
    Language? language,
    String? timezone,
    bool? isLoading,
  }) {
    return UserInfoState(
      userInfo: userInfo != null ? userInfo() : this.userInfo,
      nicknameController: nicknameController ?? this.nicknameController,
      emailController: emailController ?? this.emailController,
      phoneController: phoneController ?? this.phoneController,
      inviteCode: inviteCode != null ? inviteCode() : this.inviteCode,
      language: language ?? this.language,
      timezone: timezone ?? this.timezone,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  void updateFromUser(User user) {
    nicknameController.text = user.nickname ?? '';
    emailController.text = user.email ?? '';
    phoneController.text = user.phone ?? '';
  }

  void dispose() {
    nicknameController.dispose();
    emailController.dispose();
    phoneController.dispose();
  }

  bool get hasChanges {
    if (userInfo == null) return false;
    return nicknameController.text != (userInfo?.nickname ?? '') ||
        emailController.text != (userInfo?.email ?? '') ||
        phoneController.text != (userInfo?.phone ?? '');
  }
} 