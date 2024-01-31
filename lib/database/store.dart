// ignore: depend_on_referenced_packages
import 'package:sqflite_common/sqlite_api.dart';

// Models
import 'package:qwitravel/models/settings.dart';
import 'package:qwitravel/models/user.dart';

class DatabaseStore {
  DatabaseStore({required this.db});

  final Database db;

  Future<void> storeSettings(SettingsProvider settings) async {
    await db.update("settings", settings.toMap());
  }

  Future<void> storeUser(UserBKK user) async {
    List userRes =
        await db.query("users", where: "id = ?", whereArgs: [user.id]);
    if (userRes.isNotEmpty) {
      await db
          .update("users", user.toMap(), where: "id = ?", whereArgs: [user.id]);
    } else {
      await db.insert("users", user.toMap());
      await db.insert("user_data", {"id": user.id});
    }
  }

  Future<void> removeUser(String userId) async {
    await db.delete("users", where: "id = ?", whereArgs: [userId]);
    await db.delete("user_data", where: "id = ?", whereArgs: [userId]);
  }
}

class UserDatabaseStore {
  UserDatabaseStore({required this.db});

  final Database db;
}
