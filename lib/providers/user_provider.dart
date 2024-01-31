import 'package:qwitravel/models/settings.dart';
import 'package:qwitravel/models/user.dart';
import 'package:flutter/foundation.dart';

class UserProvider with ChangeNotifier {
  final Map<String, UserBKK> _users = {};
  String? _selectedUserId;
  UserBKK? get user => _users[_selectedUserId];

  // _user properties
  String? get id => user?.id;
  String? get name => user?.name;
  String? get email => user?.email;
  bool? get emailVerified => user?.emailVerified;
  String? get nickname => user?.nickname;
  String? get displayName => user?.displayName;
  String? get familyName => user?.familyName;
  String? get givenName => user?.givenName;
  String? get locale => user?.locale;
  String? get sub => user?.sub;
  String? get preferredUsername => user?.preferredUsername;

  final SettingsProvider _settings;

  UserProvider({required SettingsProvider settings}) : _settings = settings;

  void setUser(String userId) async {
    _selectedUserId = userId;
    await _settings.update(lastAccountId: userId);
    notifyListeners();
  }

  void addUser(UserBKK user) {
    _users[user.id] = user;
    if (kDebugMode) {
      print("DEBUG: Added User: ${user.id}");
    }
  }

  void removeUser(String userId) async {
    _users.removeWhere((key, value) => key == userId);
    if (_users.isNotEmpty) {
      setUser(_users.keys.first);
    } else {
      await _settings.update(lastAccountId: "");
    }
    notifyListeners();
  }

  UserBKK getUser(String userId) {
    return _users[userId]!;
  }

  List<UserBKK> getUsers() {
    return _users.values.toList();
  }

  void refresh() {
    notifyListeners();
  }
}
