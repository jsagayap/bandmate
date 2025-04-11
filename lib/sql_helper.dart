import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  // Create database tables
  static Future<void> createTables(sql.Database database) async {
    // Create band table
    await database.execute("""CREATE TABLE bands(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      name TEXT,
      genre TEXT,
      createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    )
    """);
    // Create band members table
    await database.execute("""CREATE TABLE members(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      name TEXT,
      instrument TEXT,
      band_id INTEGER,
      createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    )
    """);
    // Create songs table
    await database.execute("""CREATE TABLE songs(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      name TEXT,
      year TEXT,
      band_id INTEGER,
      createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    )
    """);
  }

  // Open the database
  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'db_bands.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // Bands: Create a band
  static Future<int> createBand(
    String name,
    String genre
  ) async {
    final db = await SQLHelper.db();

    final data = {
      'name': name,
      'genre': genre,
    };
    final id = await db.insert(
      'bands',
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace
    );
    return id;
  }

  // Bands: Get list of bands
  static Future<List<Map<String, dynamic>>> getBands() async {
    final db = await SQLHelper.db();
    return db.query('bands', orderBy: 'id');
  }

  // Bands: Get a specific band
  static Future<List<Map<String, dynamic>>> getBand(int id) async {
    final db = await SQLHelper.db();
    return db.query('bands', where: 'id = ?', whereArgs: [id], limit: 1);
  }

  // Bands: Update a band
  static Future<int> updateBand(
    int? id,
    String name,
    String genre,
  ) async {
    final db = await SQLHelper.db();

    final data = {
      'name': name,
      'genre': genre,
      'createdAt': DateTime.now().toString()
    };

    final result = await db.update(
      'bands', data, where: 'id = ?', whereArgs: [id]
    );
    return result;
  }

  // Bands: Delete a band
  static Future<void> deleteBand(int id) async {
    final db = await SQLHelper.db();

    try {
      await db.delete('bands', where: 'id = ?', whereArgs: [id]);
      await db.delete('members', where: 'band_id = ?', whereArgs: [id]);
      await db.delete('songs', where: 'band_id = ?', whereArgs: [id]);
    }
    catch (e) {
      debugPrint('An error occured while processing your request');
    }
  }

  // Members: Create a member
  static Future<int> createMember(
    String name,
    String instrument,
    int bandId
  ) async {
    final db = await SQLHelper.db();

    final data = {
      'name': name,
      'instrument': instrument,
      'band_id': bandId,
    };
    final id = await db.insert(
      'members',
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace
    );
    return id;
  }

  // Members: Get list of members
  static Future<List<Map<String, dynamic>>> getAllMembers() async {
    final db = await SQLHelper.db();
    return db.query('members', orderBy: 'id');
  }

  // Members: Get list of members from a band
  static Future<List<Map<String, dynamic>>> getMembers(id) async {
    final db = await SQLHelper.db();
    return db.query(
      'members',
      where: 'band_id = ?',
      whereArgs: [id],
      orderBy: 'id'
    );
  }

  // Members: Get a specific member
  static Future<List<Map<String, dynamic>>> getMember(int id) async {
    final db = await SQLHelper.db();
    return db.query('members', where: 'id = ?', whereArgs: [id], limit: 1);
  }

  // Members: Update a member
  static Future<int> updateMember(
    int? id,
    String name,
    String instrument,
  ) async {
    final db = await SQLHelper.db();

    final data = {
      'name': name,
      'instrument': instrument,
      'createdAt': DateTime.now().toString()
    };

    final result = await db.update(
      'members', data, where: 'id = ?', whereArgs: [id]
    );
    return result;
  }

  // Members: Delete a member
  static Future<void> deleteMember(int id) async {
    final db = await SQLHelper.db();

    try {
      await db.delete('members', where: 'id = ?', whereArgs: [id]);
    }
    catch (e) {
      debugPrint('An error occured while processing your request');
    }
  }

  // Songs: Create a song
  static Future<int> createSong(
    String name,
    String year,
    int bandId
  ) async {
    final db = await SQLHelper.db();

    final data = {
      'name': name,
      'year': year,
      'band_id': bandId,
    };
    final id = await db.insert(
      'songs',
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace
    );
    return id;
  }

  // Songs: Get list of songs
  static Future<List<Map<String, dynamic>>> getAllSongs() async {
    final db = await SQLHelper.db();
    return db.query('songs', orderBy: 'id');
  }

  // Songs: Get list of songs from a band
  static Future<List<Map<String, dynamic>>> getSongs(id) async {
    final db = await SQLHelper.db();
    return db.query(
      'songs',
      where: 'band_id = ?',
      whereArgs: [id],
      orderBy: 'id'
    );
  }

  // Songs: Get a specific song
  static Future<List<Map<String, dynamic>>> getSong(int id) async {
    final db = await SQLHelper.db();
    return db.query('songs', where: 'id = ?', whereArgs: [id], limit: 1);
  }

  // Songs: Update a song
  static Future<int> updateSong(
    int? id,
    String name,
    String year,
  ) async {
    final db = await SQLHelper.db();

    final data = {
      'name': name,
      'year': year,
      'createdAt': DateTime.now().toString()
    };

    final result = await db.update(
      'songs', data, where: 'id = ?', whereArgs: [id]
    );
    return result;
  }

  // Songs: Delete a song
  static Future<void> deleteSong(int id) async {
    final db = await SQLHelper.db();

    try {
      await db.delete('songs', where: 'id = ?', whereArgs: [id]);
    }
    catch (e) {
      debugPrint('An error occured while processing your request');
    }
  }
}