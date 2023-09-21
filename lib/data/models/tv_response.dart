import 'dart:convert';

import 'package:ditonton/data/models/tv_model.dart';
import 'package:equatable/equatable.dart';

class TvResponse extends Equatable {
  final int page;
  final List<TvModel> results;
  final int totalPages;
  final int totalResults;

  TvResponse({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory TvResponse.fromRawJson(String str) =>
      TvResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TvResponse.fromJson(Map<String, dynamic> json) => TvResponse(
        page: json["page"],
        results: List<TvModel>.from((json["results"] as List)
            .map((x) => TvModel.fromJson(x))
            .where((element) => element.posterPath != null && element.overview != "")),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
      );

  Map<String, dynamic> toJson() => {
        "page": page,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
        "total_pages": totalPages,
        "total_results": totalResults,
      };

  @override
  List<Object?> get props => [page, results, totalPages, totalResults];
}
