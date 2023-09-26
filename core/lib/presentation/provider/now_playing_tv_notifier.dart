
import 'package:flutter/material.dart';

import '../../domain/entities/tv.dart';
import '../../domain/usecases/get_now_playing_tv.dart';
import '../../utils/state_enum.dart';


class NowPlayingTvNotifier extends ChangeNotifier{
  final GetNowPlayingTv getNowPlayingTv;

  NowPlayingTvNotifier({required this.getNowPlayingTv});

  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  List<Tv> _tv = [];
  List<Tv> get tv => _tv;

  String _message = '';
  String get message => _message;

  Future<void> fetchNowPlayingTv() async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await getNowPlayingTv.execute();

    result.fold(
          (failure) {
        _message = failure.message;
        _state = RequestState.Error;
        notifyListeners();
      },
          (tvData) {
        _tv = tvData;
        _state = RequestState.Loaded;
        notifyListeners();
      },
    );
  }
}