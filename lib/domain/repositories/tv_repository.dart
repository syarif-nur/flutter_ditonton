import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';

import '../../common/failure.dart';
import '../entities/tv.dart';

abstract class TvRepository{
  Future<Either<Failure, List<Tv>>> getNowPlayingTv();
  Future<Either<Failure, TvDetail>> getTvDetail(int id);
  Future<Either<Failure, String>> saveWatchlistTv(TvDetail tv);
  Future<Either<Failure, String>> removeWatchlistTv(TvDetail tv);
  Future<bool> isAddedToWatchlistTv(int id);

}