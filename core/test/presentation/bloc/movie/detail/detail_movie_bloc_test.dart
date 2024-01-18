import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/usecases/get_movie_detail.dart';
import 'package:core/domain/usecases/get_movie_recommendations.dart';
import 'package:core/domain/usecases/get_watchlist_status.dart';
import 'package:core/domain/usecases/remove_watchlist.dart';
import 'package:core/domain/usecases/save_watchlist.dart';
import 'package:core/presentation/bloc/movie/detail/detail_movie_bloc.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../dummy_data/dummy_objects.dart';
import 'detail_movie_bloc_test.mocks.dart';

@GenerateMocks([
  GetMovieDetail,
  GetMovieRecommendations,
  GetWatchListStatus,
  SaveWatchlist,
  RemoveWatchlist,
])
void main() {
  late DetailMovieBloc detailBloc;
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetWatchListStatus mockGetWatchlistStatus;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    mockGetWatchlistStatus = MockGetWatchListStatus();
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();
    detailBloc = DetailMovieBloc(
      mockGetMovieDetail,
      mockGetWatchlistStatus,
      mockSaveWatchlist,
      mockRemoveWatchlist,
    );
  });

  final tId = 1;

  final tMovie = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );
  final tMovies = <Movie>[tMovie];

  _arrangeUsecase() {
    when(mockGetMovieDetail.execute(tId))
        .thenAnswer((_) async => Right(testMovieDetail));
    when(mockGetWatchlistStatus.execute(any)).thenAnswer((_) async => false);
    return detailBloc;
  }

  group('Get Movie Detail', () {
    blocTest<DetailMovieBloc, DetailMovieState>(
      'Should emit [Loading, HasData] when data is gotten successfully',
      build: () => _arrangeUsecase(),
      act: (bloc) => bloc.add(DetailMovieFetched(tId)),
      expect: () => [
        DetailMovieLoading(),
        DetailMovieHasData(testMovieDetail, false),
      ],
      verify: (bloc) {
        verify(mockGetMovieDetail.execute(tId));
      },
    );


  });

  group('Watchlist', () {
    blocTest<DetailMovieBloc, DetailMovieState>(
      'should get the watchlist status',
      build: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => Right(testMovieDetail));
        when(mockGetWatchlistStatus.execute(tId)).thenAnswer((_) async => true);
        return detailBloc;
      },
      act: (bloc) => bloc.add(DetailMovieFetched(tId)),
      expect: () => [
        DetailMovieLoading(),
        DetailMovieHasData(testMovieDetail, true),
      ],
      verify: (bloc) {
        verify(mockGetMovieDetail.execute(tId));
      },
    );

    blocTest<DetailMovieBloc, DetailMovieState>(
      'should execute save watchlist when function called',
      build: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => Right(testMovieDetail));
        when(mockGetWatchlistStatus.execute(tId)).thenAnswer((_) async => true);
        when(mockSaveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => const Right('Success'));
        return detailBloc;
      },
      act: (bloc) => bloc.add(AddToWatchlist(testMovieDetail)),
      expect: () => [
        const DetailMovieMessage('Added to Watchlist'),
        DetailMovieLoading(),
        DetailMovieHasData(testMovieDetail, true)
      ],
      verify: (bloc) {
        verify(mockSaveWatchlist.execute(testMovieDetail));
      },
    );

    blocTest<DetailMovieBloc, DetailMovieState>(
      'should execute remove watchlist when function called',
      build: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => Right(testMovieDetail));
        when(mockGetWatchlistStatus.execute(tId))
            .thenAnswer((_) async => false);
        when(mockRemoveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => const Right('Success'));
        return detailBloc;
      },
      act: (bloc) => bloc.add(RemoveFromWatchlist(testMovieDetail)),
      expect: () => [
        const DetailMovieMessage('Removed from Watchlist'),
        DetailMovieLoading(),
        DetailMovieHasData(testMovieDetail, false)
      ],
      verify: (bloc) {
        verify(mockRemoveWatchlist.execute(testMovieDetail));
      },
    );


    blocTest<DetailMovieBloc, DetailMovieState>(
      'should update watchlist status when add watchlist success',
      build: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => Right(testMovieDetail));
        when(mockGetWatchlistStatus.execute(tId)).thenAnswer((_) async => true);
        when(mockSaveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => const Right('Success'));
        return detailBloc;
      },
      act: (bloc) => bloc.add(AddToWatchlist(testMovieDetail)),
      expect: () => [
        const DetailMovieMessage('Added to Watchlist'),
        DetailMovieLoading(),
        DetailMovieHasData(testMovieDetail, true)
      ],
      verify: (bloc) {
        verify(mockSaveWatchlist.execute(testMovieDetail));
      },
    );



    blocTest<DetailMovieBloc, DetailMovieState>(
      'should update watchlist status when add watchlist faild',
      build: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => Left(DatabaseFailure("Failed")));
        when(mockGetWatchlistStatus.execute(tId))
            .thenAnswer((_) async => false);
        when(mockSaveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => Left(DatabaseFailure("Failed")));
        return detailBloc;
      },
      act: (bloc) => bloc.add(AddToWatchlist(testMovieDetail)),
      expect: () => [
        const DetailMovieError('Failed'),
      ],
      verify: (bloc) {
        verify(mockSaveWatchlist.execute(testMovieDetail));
      },
    );
  });

  group('on Error', () {
    blocTest<DetailMovieBloc, DetailMovieState>(
      'should emit [Loading, Error] when get search is unsuccessful',
      build: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        when(mockGetWatchlistStatus.execute(tId))
            .thenAnswer((_) async => false);
        return detailBloc;
      },
      act: (bloc) => bloc.add(DetailMovieFetched(tId)),
      expect: () => [
        DetailMovieLoading(),
        const DetailMovieError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetMovieDetail.execute(tId));
      },
    );
  });
}
