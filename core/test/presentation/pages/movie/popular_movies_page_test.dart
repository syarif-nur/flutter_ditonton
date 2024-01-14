import 'package:core/presentation/bloc/movie/popular/popular_movie_bloc.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/presentation/pages/movie/popular_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'popular_movies_page_test.mocks.dart';

@GenerateMocks([PopularMovieBloc])
void main() {
  late MockPopularMovieBloc mockBloc;

  setUp(() {
    mockBloc = MockPopularMovieBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<PopularMovieBloc>.value(
      value: mockBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(mockBloc.stream)
        .thenAnswer((_) => Stream.value(PopularMovieLoading()));

    when(mockBloc.state).thenAnswer((_) => PopularMovieLoading());

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(makeTestableWidget(PopularMoviesPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(mockBloc.stream)
        .thenAnswer((_) => Stream.value(const PopularMovieHasData(<Movie>[])));
    when(mockBloc.state)
        .thenAnswer((_) => const PopularMovieHasData(<Movie>[]));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(makeTestableWidget(PopularMoviesPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(mockBloc.stream).thenAnswer(
        (_) => Stream.value(const PopularMovieError("Error message")));
    when(mockBloc.state)
        .thenAnswer((_) => const PopularMovieError("Error message"));

    final textFinder = find.byKey(Key('error_message'));

    await tester.pumpWidget(makeTestableWidget(PopularMoviesPage()));

    expect(textFinder, findsOneWidget);
  });
}
