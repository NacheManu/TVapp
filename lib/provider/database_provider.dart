import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';
import 'package:sqflite/sqflite.dart' as sql;

Future<Database> _getDatabase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, 'tvapp.db'),
    onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE user(id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT, password TEXT)');
    },
    version: 1,
  );
  return db;
}

class UserAuthNotifier extends StateNotifier<List<User>> {
  UserAuthNotifier() : super([]);

  Future<User?> authenticateUser(String username, String password) async {
    final db = await _getDatabase();

    final result = await db.query('user',
        where: 'username = ? AND password = ?',
        whereArgs: [username, password]);

    if (result.isNotEmpty) {
      final userData = result.first;
      final foundUsername = userData['username'] as String? ?? '';
      final foundPassword = userData['password'] as String? ?? '';
      return User(username: foundUsername, password: foundPassword);
    }

    return null;
  }

  Future<bool> addUser(String username, String password) async {
    final db = await _getDatabase();

    final existingUser =
        await db.query('user', where: 'username = ?', whereArgs: [username]);

    if (existingUser.isNotEmpty) {
      return false;
    } else {
      await db.insert('user', {'username': username, 'password': password});

      state = [User(username: username, password: password), ...state];
      return true;
    }
  }
}

class User {
  final String username;
  final String password;

  User({required this.username, required this.password});
}

final userAuthNotifierProvider = Provider<UserAuthNotifier>((ref) {
  return UserAuthNotifier();
});

final userAuthProvider = Provider<UserAuthNotifier>((ref) {
  return ref.watch(userAuthNotifierProvider);
});
