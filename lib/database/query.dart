// ignore: depend_on_referenced_packages
import 'package:qwitravel/providers/database_provider.dart';
import 'package:qwitravel/providers/user_provider.dart';
import 'package:sqflite_common/sqlite_api.dart';

// Models
import 'package:qwitravel/models/settings.dart';
import 'package:qwitravel/models/user.dart';

class DatabaseQuery {
  DatabaseQuery({required this.db});

  final Database db;

  Future<SettingsProvider> getSettings(DatabaseProvider database) async {
    Map settingsMap = (await db.query("settings")).elementAt(0);
    SettingsProvider settings =
        SettingsProvider.fromMap(settingsMap, database: database);
    return settings;
  }

  Future<UserProvider> getUsers(SettingsProvider settings) async {
    var userProvider = UserProvider(settings: settings);
    List<Map> usersMap = await db.query("users");
    for (var user in usersMap) {
      userProvider.addUser(UserBKK.fromMap(user));
    }
    if (userProvider
        .getUsers()
        .map((e) => e.id)
        .contains(settings.lastAccountId)) {
      userProvider.setUser(settings.lastAccountId);
    } else {
      if (usersMap.isNotEmpty) {
        userProvider.setUser(userProvider.getUsers().first.id);
        settings.update(lastAccountId: userProvider.id);
      }
    }
    return userProvider;
  }
}

class UserDatabaseQuery {
  UserDatabaseQuery({required this.db});

  final Database db;
}
