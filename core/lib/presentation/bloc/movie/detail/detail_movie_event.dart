part of 'detail_movie_bloc.dart';

@immutable
abstract class DetailMovieEvent extends Equatable {
  const DetailMovieEvent();

  @override
  List<Object> get props => [];
}

final class DetailMovieFetched extends DetailMovieEvent {
  final int id;

  const DetailMovieFetched(this.id);

  @override
  List<Object> get props => [id];
}

final class AddToWatchlist extends DetailMovieEvent {
  final MovieDetail movieDetail;

  const AddToWatchlist(this.movieDetail);

  @override
  List<Object> get props => [movieDetail];
}

final class RemoveFromWatchlist extends DetailMovieEvent {
  final MovieDetail movieDetail;

  const RemoveFromWatchlist(this.movieDetail);

  @override
  List<Object> get props => [movieDetail];
}
