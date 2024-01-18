import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/usecases/get_now_playing_tv.dart';
import 'package:core/presentation/bloc/tv/now_playing/now_playing_tv_bloc.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'now_playing_tv_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingTv])
void main() {
  late NowPlayingTvBloc bloc;
  late MockGetNowPlayingTv mockGetNowPlayingTv;

  setUp(() {
    mockGetNowPlayingTv = MockGetNowPlayingTv();
    bloc = NowPlayingTvBloc(mockGetNowPlayingTv);
  });

  final testTv = Tv(
    backdropPath: "/9In9QgVJx7PlFOAgVHCKKSbo605.jpg",
    genreIds: [16, 35, 10765, 10759],
    id: 60625,
    originalName: "Rick and Morty",
    overview:
        "Rick is a mentally-unbalanced but scientifically gifted old man who has recently reconnected with his family. He spends most of his time involving his young grandson Morty in dangerous, outlandish adventures throughout space and alternate universes. Compounded with Morty's already unstable family life, these events cause Morty much distress at home and school.",
    popularity: 1386.559,
    posterPath: "/cvhNj9eoRBe5SxjCbQTkh05UP5K.jpg",
    firstAirDate: "2013-12-02",
    name: "Rick and Morty",
    voteAverage: 8.701,
    voteCount: 8572,
    originCountry: ["US"],
    originalLanguage: "en",
  );

  final tTvList = <Tv>[testTv];

  group('now playing tv', () {
    test('initialState should be Empty', () {
      expect(bloc.state, NowPlayingTvInitial());
    });

    blocTest<NowPlayingTvBloc, NowPlayingTvState>(
      'Should emit [Loading, HasData] when data is gotten successfully',
      build: () {
        when(mockGetNowPlayingTv.execute())
            .thenAnswer((_) async => Right(tTvList));
        return bloc;
      },
      act: (bloc) => bloc.add(NowPlayingTvFetched()),
      expect: () => [
        NowPlayingTvLoading(),
        NowPlayingTvHasData(tTvList),
      ],
      verify: (bloc) {
        verify(mockGetNowPlayingTv.execute());
      },
    );

    blocTest<NowPlayingTvBloc, NowPlayingTvState>(
      'should change state to Loading when usecase is called',
      build: () {
        when(mockGetNowPlayingTv.execute())
            .thenAnswer((_) async => Right(tTvList));
        return bloc;
      },
      act: (bloc) => bloc.emit(NowPlayingTvLoading()),
      expect: () => [
        NowPlayingTvLoading(),
      ],
    );

    blocTest(
      'should emit [Loading, Error] when get search is unsuccessful',
      build: () {
        when(mockGetNowPlayingTv.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(NowPlayingTvFetched()),
      expect: () => [
        NowPlayingTvLoading(),
        const NowPlayingTvError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetNowPlayingTv.execute());
      },
    );
  });
}
