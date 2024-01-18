import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../domain/entities/tv.dart';
import '../../../../domain/usecases/get_top_rated_tv.dart';

part 'top_rated_tv_event.dart';
part 'top_rated_tv_state.dart';

class TopRatedTvBloc extends Bloc<TopRatedTvEvent, TopRatedTvState> {
  final GetTopRatedTv _getTopRatedTv;

  TopRatedTvBloc(this._getTopRatedTv) : super(TopRatedTvInitial()) {
    on<TopRatedTvFetched>((event, emit) async {
      emit(TopRatedTvLoading());
      final result = await _getTopRatedTv.execute();

      result.fold(
        (failure) => emit(TopRatedTvError(failure.message)),
        (data) => emit(TopRatedTvHasData(data)),
      );
    });
  }
}
