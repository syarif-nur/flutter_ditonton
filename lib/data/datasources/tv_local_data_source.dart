// import 'package:ditonton/common/exception.dart';
// import 'package:ditonton/data/datasources/db/database_helper.dart';
// import 'package:ditonton/data/models/movie_table.dart';
// import 'package:ditonton/data/models/tv_table.dart';
//
// abstract class TvLocalDataSource {
//   Future<String> insertWatchlist(TvTable tv);
//
//   Future<String> removeWatchlist(TvTable tv);
//
//   Future<TvTable?> getTvById(int id);
//
//   Future<List<TvTable>> getWatchlistTv();
//
//   Future<void> cacheNowPlayingTv(List<TvTable> tv);
//
//   Future<List<TvTable>> getCachedNowPlayingTv();
// }
//
// class TvLocalDataSourceImpl implements TvLocalDataSource {
//   final DatabaseHelper databaseHelper;
//
//   TvLocalDataSourceImpl({required this.databaseHelper});
//
//   @override
//   Future<void> cacheNowPlayingTv(List<TvTable> tv) async {
//     await databaseHelper.clearCache('now playing');
//     // await databaseHelper.insertCacheTransaction(tv, 'now playing');
//   }
//
//   @override
//   Future<List<TvTable>> getCachedNowPlayingTv() async {
//     // // final result = await databaseHelper.getCacheTv('now playing');
//     // if (result.length > 0) {
//     //   return result.map((data) => TvTable.fromMap(data)).toList();
//     // } else {
//     //   throw CacheException("Can't get the data :(");
//     // }
//   }
//
//   @override
//   Future<TvTable?> getTvById(int id) {
//     // TODO: implement getTvById
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<List<TvTable>> getWatchlistTv() {
//     // TODO: implement getWatchlistTv
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<String> insertWatchlist(TvTable tv) {
//     // TODO: implement insertWatchlist
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<String> removeWatchlist(TvTable tv) {
//     // TODO: implement removeWatchlist
//     throw UnimplementedError();
//   }
// }
