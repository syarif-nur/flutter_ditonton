import 'package:ditonton/data/models/tv_model.dart';

abstract class TvRemoteDataSource{
  Future<List<TvModel>> getNowPlayingTvSeries();
}

class TvRemoteDataSourceImpl extends TvRemoteDataSource{
  @override
  Future<List<TvModel>> getNowPlayingTvSeries() {
    // TODO: implement getNowPlayingTvSeries
    throw UnimplementedError();
  }

}