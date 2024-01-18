import 'dart:async';

import 'package:core/common/encrypt.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import '../../models/movie_table.dart';
import '../../models/tv_table.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;

  DatabaseHelper._instance() {
    _databaseHelper = this;
  }

  factory DatabaseHelper() => _databaseHelper ?? DatabaseHelper._instance();

  static Database? _database;

  Future<Database?> get database async {
    _database ??= await _initDb();
    return _database;
  }

  static const String _tblWatchlist = 'watchlist';
  static const String _tblCache = 'cache';

  Future<Database> _initDb() async {
    final path = await getDatabasesPath();
    final databasePath = '$path/ditonton.db';

    if (kDebugMode) {
      print(databasePath);
    }

    var db = await openDatabase(
      databasePath,
      version: 1,
      onCreate: _onCreate,
      password: encrypt('Your secure password...'),
    );

    return db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE  $_tblWatchlist (
        id INTEGER PRIMARY KEY,
        title TEXT,
        overview TEXT,
        posterPath TEXT,
        type INTEGER
      );
    ''');

    await db.execute('''
      CREATE TABLE  $_tblCache (
        id INTEGER PRIMARY KEY,
        title TEXT,
        overview TEXT,
        posterPath TEXT,
        category TEXT,
        type INTEGER
      );
    ''');
  }

  Future<int> insertWatchlist(MovieTable movie) async {
    final movieJson = movie.toJson();
    movieJson['type'] = 1;
    final db = await database;
    return await db!.insert(_tblWatchlist, movieJson);
  }

  Future<int> insertWatchlistTv(TvTable tv) async {
    final tvJson = tv.toJson();
    tvJson['type'] = 2;
    tvJson['title'] = tv.name;
    tvJson.remove("name");
    final db = await database;
    return await db!.insert(_tblWatchlist, tvJson);
  }

  Future<int> removeWatchlist(MovieTable movie) async {
    final db = await database;
    return await db!.delete(
      _tblWatchlist,
      where: 'id = ?',
      whereArgs: [movie.id],
    );
  }

  Future<int> removeWatchlistTv(TvTable tv) async {
    final db = await database;
    return await db!.delete(
      _tblWatchlist,
      where: 'id = ?',
      whereArgs: [tv.id],
    );
  }

  Future<Map<String, dynamic>?> getDataById(int id) async {
    final db = await database;
    final results = await db!.query(
      _tblWatchlist,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getWatchlistMovies() async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db!.query(
      _tblWatchlist,
      where: 'type = 1',
    );
    return results;
  }

  Future<List<Map<String, dynamic>>> getWatchListTv() async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db!.query(
      _tblWatchlist,
      where: 'type = 2',
    );
    return results;
  }

  Future<void> insertCacheTransaction(
      List<MovieTable> movies, String category) async {
    final db = await database;
    db!.transaction((txn) async {
      for (final movie in movies) {
        final movieJson = movie.toJson();
        movieJson['category'] = category;
        movieJson['type'] = 1;
        txn.insert(_tblCache, movieJson);
      }
    });
  }

  Future<void> insertCacheTransactionTv(
      List<TvTable> tv, String category) async {
    final db = await database;
    db!.transaction((txn) async {
      for (final tvSeries in tv) {
        final tvJson = tvSeries.toJson();
        tvJson['category'] = category;
        tvJson['type'] = 2;
        tvJson['title'] = tvSeries.name;
        tvJson.remove("name");
        txn.insert(_tblCache, tvJson);
      }
    });
  }

  Future<List<Map<String, dynamic>>> getCacheMovies(String category) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db!.query(
      _tblCache,
      where: 'category = ? AND type = 1',
      whereArgs: [category],
    );
    return results;
  }

  Future<List<Map<String, dynamic>>> getCacheTv(String category) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db!.query(
      _tblCache,
      where: 'category = ? AND type = 2',
      whereArgs: [category],
    );
    return results;
  }

  Future<int> clearCache(String category) async {
    final db = await database;
    return await db!.delete(
      _tblCache,
      where: 'category = ? AND type = 1',
      whereArgs: [category],
    );
  }

  Future<int> clearCacheTv(String category) async {
    final db = await database;
    return await db!.delete(
      _tblCache,
      where: 'category = ? AND type = 2',
      whereArgs: [category],
    );
  }
}
