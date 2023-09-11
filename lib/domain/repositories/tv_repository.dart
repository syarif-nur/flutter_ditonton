import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';

import '../../common/failure.dart';
import '../entities/tv.dart';

abstract class TvRepository{
  Future<Either<Failure, List<Tv>>> getNowPlayingTv();
  Future<Either<Failure, TvDetail>> getTvDetail(int id);

}