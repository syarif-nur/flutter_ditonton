import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:equatable/equatable.dart';

import '../../../../domain/usecases/get_popular_tv.dart';

part 'popular_tv_event.dart';

part 'popular_tv_state.dart';

class PopularTvBloc extends Bloc<PopularTvEvent, PopularTvState> {
  final GetPopularTv _getPopularTv;

  PopularTvBloc(this._getPopularTv) : super(PopularTvInitial()) {
    on<PopularTvFetched>((event, emit) async {
      emit(PopularTvLoading());
      final result = await _getPopularTv.execute();

      result.fold(
        (failure) => emit(PopularTvError(failure.message)),
        (data) => emit(PopularTvHasData(data)),
      );
    });
  }
}
