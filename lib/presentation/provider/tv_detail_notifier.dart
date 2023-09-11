import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:flutter/material.dart';

import '../../common/state_enum.dart';
import '../../domain/usecases/get_tv_detail.dart';

class TvDetailNotifier extends ChangeNotifier {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetTvDetail getTvDetail;

  // final GetWatchListStatus getWatchListStatus;
  // final SaveWatchlist saveWatchlist;
  // final RemoveWatchlist removeWatchlist;

  TvDetailNotifier({
    required this.getTvDetail,
  });

  late TvDetail _tv;

  TvDetail get tv => _tv;

  RequestState _tvState = RequestState.Empty;

  RequestState get tvState => _tvState;

  String _message = '';

  String get message => _message;

  Future<void> fetchMovieDetail(int id) async {
    _tvState = RequestState.Loading;
    notifyListeners();
    final detailResult = await getTvDetail.execute(id);
    // final recommendationResult = await getMovieRecommendations.execute(id);
    detailResult.fold(
      (failure) {
        _tvState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tv) {
        // _recommendationState = RequestState.Loading;
        _tv = tv;
        notifyListeners();
        // recommendationResult.fold(
        //       (failure) {
        //     _recommendationState = RequestState.Error;
        //     _message = failure.message;
        //   },
        //       (tv) {
        //     _recommendationState = RequestState.Loaded;
        //     _movieRecommendations = tv;
        //   },
        // );
        _tvState = RequestState.Loaded;
        notifyListeners();
      },
    );
  }
}
