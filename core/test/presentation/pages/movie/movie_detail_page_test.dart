import 'dart:async';

import 'package:core/domain/entities/movie.dart';
import 'package:core/presentation/bloc/movie/detail/detail_movie_bloc.dart';
import 'package:core/presentation/bloc/movie/recommendation/recommendation_movie_bloc.dart';
import 'package:core/presentation/pages/movie/movie_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'movie_detail_page_test.mocks.dart';

@GenerateMocks([DetailMovieBloc, RecommendationMovieBloc])
void main() {
  late MockDetailMovieBloc mockDetailMovieBloc;
  late MockRecommendationMovieBloc mockRecommendationMovieBloc;

  setUp(() {
    mockDetailMovieBloc = MockDetailMovieBloc();
    mockRecommendationMovieBloc = MockRecommendationMovieBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<DetailMovieBloc>.value(value: mockDetailMovieBloc),
        BlocProvider<RecommendationMovieBloc>.value(
            value: mockRecommendationMovieBloc),
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets(
      'Watchlist button should display add icon when movie not added to watchlist',
      (WidgetTester tester) async {
    when(mockDetailMovieBloc.stream)
        .thenAnswer((_) => StreamController<DetailMovieState>().stream);
    when(mockRecommendationMovieBloc.stream)
        .thenAnswer((_) => StreamController<RecommendationMovieState>().stream);

    when(mockDetailMovieBloc.state).thenAnswer(
      (_) => DetailMovieHasData(testMovieDetail, false),
    );
    when(mockRecommendationMovieBloc.state).thenAnswer(
      (_) => const RecommendationMovieHasData(<Movie>[]),
    );

    final watchlistButtonIcon = find.byIcon(Icons.add);
    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display check icon when movie is added to watchlist',
      (WidgetTester tester) async {
    when(mockDetailMovieBloc.stream)
        .thenAnswer((_) => StreamController<DetailMovieState>().stream);
    when(mockRecommendationMovieBloc.stream)
        .thenAnswer((_) => StreamController<RecommendationMovieState>().stream);

    when(mockDetailMovieBloc.state).thenAnswer(
      (_) => DetailMovieHasData(testMovieDetail, true),
    );
    when(mockRecommendationMovieBloc.state).thenAnswer(
      (_) => const RecommendationMovieHasData(<Movie>[]),
    );

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  // testWidgets(
  //     'Watchlist button should display Snackbar when added to watchlist',
  //     (WidgetTester tester) async {
  //   when(mockDetailMovieBloc.stream)
  //       .thenAnswer((_) => StreamController<DetailMovieState>().stream);
  //   when(mockRecommendationMovieBloc.stream)
  //       .thenAnswer((_) => StreamController<RecommendationMovieState>().stream);
  //
  //   when(mockDetailMovieBloc.state).thenAnswer(
  //     (_) => DetailMovieHasData(testMovieDetail, false),
  //   );
  //   when(mockRecommendationMovieBloc.state).thenAnswer(
  //     (_) => const RecommendationMovieHasData(<Movie>[]),
  //   );
  //
  //   when(mockDetailMovieBloc.add(AddToWatchlist(testMovieDetail)))
  //       .thenAnswer((_) async {});
  //
  //   when(mockDetailMovieBloc.add(DetailMovieFetched(testMovieDetail.id)))
  //       .thenAnswer((_) async {});
  //
  //   final watchlistButton = find.byType(ElevatedButton);
  //
  //   await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));
  //
  //   // Verify the initial state
  //   expect(find.byIcon(Icons.add), findsOneWidget);
  //
  //   // Tap the watchlist button
  //   await tester.tap(watchlistButton);
  //   await tester.pump();
  //
  //   // Verify that the BLoC add method was called
  //   verify(mockDetailMovieBloc.add(AddToWatchlist(testMovieDetail))).called(1);
  //
  //   // Verify the presence of the SnackBar
  //   expect(find.byType(SnackBar), findsOneWidget);
  //   expect(find.text('Added to Watchlist'), findsOneWidget);
  // });

  // testWidgets(
  //     'Watchlist button should display AlertDialog when add to watchlist failed',
  //     (WidgetTester tester) async {
  //   when(mockDetailMovieBloc.stream)
  //       .thenAnswer((_) => StreamController<DetailMovieState>().stream);
  //   when(mockRecommendationMovieBloc.stream)
  //       .thenAnswer((_) => StreamController<RecommendationMovieState>().stream);
  //
  //   when(mockDetailMovieBloc.state).thenAnswer(
  //     (_) => DetailMovieHasData(testMovieDetail, false),
  //   );
  //   when(mockRecommendationMovieBloc.state).thenAnswer(
  //     (_) => const RecommendationMovieHasData(<Movie>[]),
  //   );
  //   when(mockDetailMovieBloc.add(AddToWatchlist(testMovieDetail)))
  //       .thenAnswer((_) => const DetailMovieError("Failed"));
  //
  //   when(mockDetailMovieBloc.emit(const DetailMovieMessage("Failed")))
  //       .thenReturn('Failed');
  //
  //   final watchlistButton = find.byType(ElevatedButton);
  //
  //   await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));
  //
  //   expect(find.byIcon(Icons.add), findsOneWidget);
  //
  //   await tester.tap(watchlistButton);
  //   await tester.pump();
  //
  //   expect(find.byType(AlertDialog), findsOneWidget);
  //   expect(find.text('Failed'), findsOneWidget);
  // });
}
