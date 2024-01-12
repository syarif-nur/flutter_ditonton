part of 'watchlist_movie_bloc.dart';

@immutable
abstract class WatchlistMovieEvent extends Equatable {
  const WatchlistMovieEvent();

  @override
  List<Object> get props => [];
}

final class WatchlistMovieFetched extends WatchlistMovieEvent {}

