part of 'detail_movie_bloc.dart';

@immutable
abstract class DetailMovieState extends Equatable {
  const DetailMovieState();

  @override
  List<Object> get props => [];
}

class DetailMovieInitial extends DetailMovieState {}

class DetailMovieLoading extends DetailMovieState {}

class DetailMovieError extends DetailMovieState {
  final String message;

  const DetailMovieError(this.message);

  @override
  List<Object> get props => [message];
}

class DetailMovieHasData extends DetailMovieState {
  final MovieDetail result;
  final bool status;

  const DetailMovieHasData(this.result, this.status);

  @override
  List<Object> get props => [result];
}

class DetailMovieMessage extends DetailMovieState {
  final String status;

  const DetailMovieMessage(this.status);

  @override
  List<Object> get props => [status];
}
