// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lookup_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LookupModel _$LookupModelFromJson(Map<String, dynamic> json) => LookupModel(
      (json['averageUserRatingForCurrentVersion'] as num).toDouble(),
      json['userRatingCountForCurrentVersion'] as int,
      json['trackId'] as int,
    );

Map<String, dynamic> _$LookupModelToJson(LookupModel instance) =>
    <String, dynamic>{
      'trackId': instance.trackId,
      'averageUserRatingForCurrentVersion':
          instance.averageUserRatingForCurrentVersion,
      'userRatingCountForCurrentVersion':
          instance.userRatingCountForCurrentVersion,
    };
