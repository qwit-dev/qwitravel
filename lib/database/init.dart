// ignore_for_file: avoid_print

import 'dart:io';

import 'package:qwitravel/providers/database_provider.dart';
import 'package:qwitravel/database/struct.dart';
import 'package:qwitravel/models/settings.dart';
// ignore: depend_on_referenced_packages
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

const settingsDB = DatabaseStruct("settings", {
  "language": String,
  "start_page": int,
  "theme": int,
  "accent_color": int,
  "news": int,
  "seen_news": String,
  "developer_mode": int,
  "config": String,
  "custom_accent_color": int,
  "x_qw_id": String,
  "last_account_id": String,
});

const usersDB = DatabaseStruct("users", {
  "id": String,
  "email": String,
  "emailVerified": int,
  "family_name": String,
  "given_name": String,
  "locale": String,
  "name": String,
  "preferred_username": String,
  "sub": String,
  "nickname": String,
});
const userDataDB = DatabaseStruct("user_data", {
  "id": String,
  // TODO: user data db
});

Future<void> createTable(Database db, DatabaseStruct struct) =>
    db.execute("CREATE TABLE IF NOT EXISTS ${struct.table} ($struct)");

Future<Database> initDB(DatabaseProvider database) async {
  Database db;

  if (Platform.isLinux || Platform.isWindows) {
    sqfliteFfiInit();
    db = await databaseFactoryFfi.openDatabase("app.db");
  } else {
    db = await openDatabase("app.db");
  }

  await createTable(db, settingsDB);
  await createTable(db, usersDB);
  await createTable(db, userDataDB);

  if ((await db.rawQuery("SELECT COUNT(*) FROM settings"))[0].values.first ==
      0) {
    // Set default values for table Settings
    await db.insert("settings",
        SettingsProvider.defaultSettings(database: database).toMap());
  }

  // Migrate Databases
  try {
    await migrateDB(
      db,
      struct: settingsDB,
      defaultValues:
          SettingsProvider.defaultSettings(database: database).toMap(),
    );
    await migrateDB(
      db,
      struct: usersDB,
      defaultValues: {"nickname": ""},
    );
    await migrateDB(db, struct: userDataDB, defaultValues: {
      // TODO: user data db
    });
  } catch (error) {
    print("ERROR: migrateDB: $error");
  }

  return db;
}

Future<void> migrateDB(
  Database db, {
  required DatabaseStruct struct,
  required Map<String, Object?> defaultValues,
}) async {
  var originalRows = await db.query(struct.table);

  if (originalRows.isEmpty) {
    await db.execute("drop table ${struct.table}");
    await createTable(db, struct);
    return;
  }

  List<Map<String, dynamic>> migrated = [];

  // go through each row and add missing keys or delete non existing keys
  await Future.forEach<Map<String, Object?>>(originalRows, (original) async {
    bool migrationRequired = struct.struct.keys.any(
            (key) => !original.containsKey(key) || original[key] == null) ||
        original.keys.any((key) => !struct.struct.containsKey(key));

    if (migrationRequired) {
      print("INFO: Migrating ${struct.table}");
      var copy = Map<String, Object?>.from(original);

      // Fill missing columns
      for (var key in struct.struct.keys) {
        if (!original.containsKey(key) || original[key] == null) {
          print("DEBUG: migrating $key");
          copy[key] = defaultValues[key];
        }
      }

      for (var key in original.keys) {
        if (!struct.struct.keys.contains(key)) {
          print("DEBUG: dropping $key");
          copy.remove(key);
        }
      }

      migrated.add(copy);
    }
  });

  // replace the old table with the migrated one
  if (migrated.isNotEmpty) {
    // Delete table
    await db.execute("drop table ${struct.table}");

    // Recreate table
    await createTable(db, struct);
    await Future.forEach(migrated, (Map<String, Object?> copy) async {
      await db.insert(struct.table, copy);
    });

    print("INFO: Database migrated");
  }
}
