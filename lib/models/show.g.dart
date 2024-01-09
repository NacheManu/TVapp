// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'show.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImageData _$ImageDataFromJson(Map<String, dynamic> json) => ImageData(
      medium: json['medium'] as String,
      original: json['original'] as String,
    );

Map<String, dynamic> _$ImageDataToJson(ImageData instance) => <String, dynamic>{
      'medium': instance.medium,
      'original': instance.original,
    };

Schedule _$ScheduleFromJson(Map<String, dynamic> json) => Schedule(
      days: (json['days'] as List<dynamic>?)?.map((e) => e as String).toList(),
      time: json['time'] as String?,
    );

Map<String, dynamic> _$ScheduleToJson(Schedule instance) => <String, dynamic>{
      'days': instance.days,
      'time': instance.time,
    };

Show _$ShowFromJson(Map<String, dynamic> json) => Show(
      id: json['id'] as int,
      name: json['name'] as String,
      image: json['image'] == null
          ? null
          : ImageData.fromJson(json['image'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ShowToJson(Show instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image': instance.image,
    };

ShowDetails _$ShowDetailsFromJson(Map<String, dynamic> json) => ShowDetails(
      name: json['name'] as String,
      image: json['image'] == null
          ? null
          : ImageData.fromJson(json['image'] as Map<String, dynamic>),
      genres:
          (json['genres'] as List<dynamic>?)?.map((e) => e as String).toList(),
      summary: json['summary'] as String?,
      schedule: json['schedule'] == null
          ? null
          : Schedule.fromJson(json['schedule'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ShowDetailsToJson(ShowDetails instance) =>
    <String, dynamic>{
      'name': instance.name,
      'image': instance.image,
      'genres': instance.genres,
      'summary': instance.summary,
      'schedule': instance.schedule,
    };

Episode _$EpisodeFromJson(Map<String, dynamic> json) => Episode(
      id: json['id'] as int,
      name: json['name'] as String,
      season: json['season'] as int,
      number: json['number'] as int,
    );

Map<String, dynamic> _$EpisodeToJson(Episode instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'season': instance.season,
      'number': instance.number,
    };

EpisodeDetails _$EpisodeDetailsFromJson(Map<String, dynamic> json) =>
    EpisodeDetails(
      id: json['id'] as int,
      name: json['name'] as String,
      season: json['season'] as int,
      number: json['number'] as int,
      summary: json['summary'] as String?,
      image: json['image'] == null
          ? null
          : ImageData.fromJson(json['image'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$EpisodeDetailsToJson(EpisodeDetails instance) =>
    <String, dynamic>{
      'id': instance.id,
      'season': instance.season,
      'number': instance.number,
      'name': instance.name,
      'summary': instance.summary,
      'image': instance.image,
    };
