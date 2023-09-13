import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/db/database_helper.dart';
import 'package:ditonton/data/models/movie_table.dart';
import 'package:ditonton/data/models/tv_table.dart';

abstract class TvLocalDataSource {
  Future<String> insertWatchlist(TvTable tv);

  Future<String> removeWatchlist(TvTable tv);

  Future<TvTable?> getTvById(int id);

  Future<List<TvTable>> getWatchlistTv();

  Future<void> cacheNowPlayingTv(List<TvTable> tv);

  Future<List<TvTable>> getCachedNowPlayingTv();
}

class TvLocalDataSourceImpl implements TvLocalDataSource {
  final DatabaseHelper databaseHelper;

  TvLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<void> cacheNowPlayingTv(List<TvTable> tv) async {
    await databaseHelper.clearCache('now playing');
    // await databaseHelper.insertCacheTransaction(tv, 'now playing');
  }

  @override
  Future<List<TvTable>> getCachedNowPlayingTv() async {
    throw UnimplementedError();
  }

  @override
  Future<TvTable?> getTvById(int id) async {
    final result = await databaseHelper.getMovieById(id);
    if (result != null) {
      return TvTable.fromMap(result);
    } else {
      return null;
    }
  }

  @override
  Future<List<TvTable>> getWatchlistTv() {
    // TODO: implement getWatchlistTv
    throw UnimplementedError();
  }

  @override
  Future<String> insertWatchlist(TvTable tv) async {
    try {
      await databaseHelper.insertWatchlistTv(tv);
      return 'Added to Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> removeWatchlist(TvTable tv) async {
    try {
      await databaseHelper.removeWatchlistTv(tv);
      return 'Removed from Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }
}
