import 'package:json_annotation/json_annotation.dart';

part 'show.g.dart';

@JsonSerializable()
class ImageData {
  final String medium;
  final String original;

  ImageData({required this.medium, required this.original});

  factory ImageData.fromJson(Map<String, dynamic> json) {
    return ImageData(
      medium: json['medium'] ?? '',
      original: json['original'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'medium': medium,
        'original': original,
      };
}

@JsonSerializable()
class Schedule {
  final List<String>? days;
  final String? time;

  Schedule({this.days, this.time});

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      days: (json['days'] as List<dynamic>?)?.cast<String>(),
      time: json['time'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'days': days,
        'time': time,
      };
}

@JsonSerializable()
class Show {
  final int id;
  final String name;
  final ImageData? image;

  Show({
    required this.id,
    required this.name,
    this.image,
  });

  factory Show.fromJson(Map<String, dynamic> json) => _$ShowFromJson(json);
  Map<String, dynamic> toJson() => _$ShowToJson(this);
}

@JsonSerializable()
class ShowDetails {
  final String name;
  final ImageData? image;
  final List<String>? genres;
  final String? summary;
  final Schedule? schedule;

  ShowDetails({
    required this.name,
    this.image,
    this.genres,
    this.summary,
    this.schedule,
  });

  factory ShowDetails.fromJson(Map<String, dynamic> json) =>
      _$ShowDetailsFromJson(json);
  Map<String, dynamic> toJson() => _$ShowDetailsToJson(this);
}

@JsonSerializable()
class Episode {
  final int id;
  final String name;
  final int season;
  final int number;

  Episode({
    required this.id,
    required this.name,
    required this.season,
    required this.number,
  });

  factory Episode.fromJson(Map<String, dynamic> json) =>
      _$EpisodeFromJson(json);
  Map<String, dynamic> toJson() => _$EpisodeToJson(this);
}

@JsonSerializable()
class EpisodeDetails {
  final int id;
  final int season;
  final int number;
  final String name;
  final String? summary;
  final ImageData? image;

  EpisodeDetails({
    required this.id,
    required this.name,
    required this.season,
    required this.number,
    required this.summary,
    required this.image,
  });

  factory EpisodeDetails.fromJson(Map<String, dynamic> json) =>
      _$EpisodeDetailsFromJson(json);
  Map<String, dynamic> toJson() => _$EpisodeDetailsToJson(this);
}
