part of 'now_playing_movie_bloc.dart';

@immutable
abstract class NowPlayingMovieEvent extends Equatable {
  const NowPlayingMovieEvent();

  @override
  List<Object> get props => [];
}

final class NowPlayingMovieFetched extends NowPlayingMovieEvent {}
