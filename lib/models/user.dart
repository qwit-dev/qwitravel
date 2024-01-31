import 'dart:convert';
import 'package:qwitravel/api/endpoints.dart';
import 'package:uuid/uuid.dart';

class UserBKK {
  late String id;
  String email;
  bool emailVerified;
  String familyName;
  String givenName;
  String locale;
  String name;
  String preferredUsername;
  String sub;
  String nickname;

  String get displayName => nickname != ''
      ? nickname
      : (givenName != '' ? givenName : preferredUsername);

  UserBKK({
    String? id,
    required this.email,
    required this.emailVerified,
    required this.familyName,
    required this.givenName,
    required this.locale,
    required this.name,
    required this.preferredUsername,
    required this.sub,
    this.nickname = "",
  }) {
    if (id != null) {
      this.id = id;
    } else {
      this.id = const Uuid().v4();
    }
  }

  factory UserBKK.fromMap(Map map) {
    return UserBKK(
      id: map["id"],
      email: map["email"],
      emailVerified: int.parse(map["email_verified"]) == 1 ? true : false,
      familyName: map["family_name"],
      givenName: map["given_name"],
      locale: map["locale"],
      name: map["name"],
      preferredUsername: map["preferred_username"],
      sub: map["sub"],
      nickname: map["nickname"] ?? "",
    );
  }

  Map<String, Object?> toMap() {
    return {
      "id": id,
      "email": email,
      "email_verified": emailVerified ? 1 : 0,
      "family_name": familyName,
      "given_name": givenName,
      "locale": locale,
      "name": name,
      "preferred_username": preferredUsername,
      "sub": sub,
      "nickname": nickname,
    };
  }

  @override
  String toString() => jsonEncode(toMap());

  static Map<String, Object?> refreshBody({
    required String refreshToken,
  }) {
    return {
      "refresh_token": refreshToken,
      "client_id": BKKAPI.clientId,
      "grant_type": "refresh_token",
    };
  }
}
