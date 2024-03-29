import 'package:core/data/models/tv_model.dart';
import 'package:equatable/equatable.dart';

class TvResponse extends Equatable {
  final List<TvModel> results;

  TvResponse({
    required this.results,
  });

  factory TvResponse.fromJson(Map<String, dynamic> json) => TvResponse(
        results: List<TvModel>.from((json["results"] as List)
            .map((x) => TvModel.fromJson(x))
            .where((element) =>
                element.posterPath != null && element.overview != "")),
      );

  Map<String, dynamic> toJson() => {
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
      };

  @override
  List<Object?> get props => [results];
}
