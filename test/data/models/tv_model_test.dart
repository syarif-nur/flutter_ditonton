import 'package:ditonton/data/models/tv_model.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){
  final tTvModel = TvModel(
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

  final tTv = Tv(
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

  test('should be a subclass of Tv entity', () async {
    final result = tTvModel.toEntity();
    expect(result, tTv);
  });
}