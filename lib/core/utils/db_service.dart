// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:lms_system/features/shared/model/shared_user.dart';
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';

// class DatabaseService {
//   static final DatabaseService _instance = DatabaseService._internal();
//   late Database _database;

//   factory DatabaseService() {
//     return _instance;
//   }

//   DatabaseService._internal() {
//     _initDatabase();
//   }

//   Future<void> deleteUser(int id) async {
//     await _database.delete(
//       'users',
//       where: 'id = ?',
//       whereArgs: [id],
//     );
//   }

//   Future<User?> getUserFromDatabase() async {
//     final List<Map<String, Object?>> userMaps = await _database.query(
//       'users',
//       limit: 1,
//     );

//     if (userMaps.isNotEmpty) {
//       final {
//         'id': id as int,
//         'name': name as String,
//         'email': email as String,
//         'password': password as String,
//         'token': token as String,
//         'bio': bio as String,
//         'image': image as String,
//       } = userMaps.first;
//       final user = User(
//         id: id,
//         name: name,
//         email: email,
//         password: password,
//         token: token,
//         bio: bio,
//         image: image,
//       );
//       user.bio = bio;
//       user.image = image;
//     }

//     return null;
//   }

//   Future<void> saveUserToDatabase(User user) async {
//     await _database.insert(
//       'users',
//       user.toMap(),
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//   }

//   Future<void> updateUserBioAndPfp(
//       User user, String bio, String imagePath) async {
//     try {
//       await _database.update(
//         'users', // Table name
//         {'bio': bio, 'image': imagePath}, // New values
//         where: 'id = ?',
//         whereArgs: [user.id], // Make sure userId is correctly assigned
//       );
//       user.bio = bio;
//       user.image = imagePath;
//     } on DatabaseException catch (e) {
//       debugPrint(e.toString());
//     }
//   }

//   Future<void> updateUserInDatabase(User user) async {
//     try {
//       await _database.update(
//         'users',
//         user.toMap(),
//         where: 'id = ?',
//         whereArgs: [user.id],
//       );
//     } on DatabaseException catch (e) {
//       debugPrint(e.toString());
//     }
//   }

//   Future<void> _initDatabase() async {
//     WidgetsFlutterBinding.ensureInitialized();
//     _database = await openDatabase(
//       join(await getDatabasesPath(), 'user_data.db'),
//       onCreate: (db, version) {
//         db.execute(
//           'CREATE TABLE users(id INTEGER PRIMARY KEY, name TEXT, email TEXT, password TEXT, token TEXT, bio TEXT, image TEXT)',
//         );
//       },
//       version: 1,
//     );
//   }

//   getUserFromStorage() {}
// }
