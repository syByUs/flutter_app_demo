// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApplicationModel _$ApplicationModelFromJson(Map<String, dynamic> json) =>
    ApplicationModel(
      LabelMapModel.fromJson(json['im:name'] as Map<String, dynamic>),
      (json['im:image'] as List<dynamic>)
          .map((e) => LabelMapModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      LabelMapModel.fromJson(json['summary'] as Map<String, dynamic>),
      LabelMapModel.fromJson(json['im:price'] as Map<String, dynamic>),
      LabelMapModel.fromJson(json['im:contentType'] as Map<String, dynamic>),
      LabelMapModel.fromJson(json['rights'] as Map<String, dynamic>),
      LabelMapModel.fromJson(json['title'] as Map<String, dynamic>),
      LabelMapModel.fromJson(json['id'] as Map<String, dynamic>),
      LabelMapModel.fromJson(json['im:artist'] as Map<String, dynamic>),
      LabelMapModel.fromJson(json['category'] as Map<String, dynamic>),
      LabelMapModel.fromJson(json['im:releaseDate'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ApplicationModelToJson(ApplicationModel instance) =>
    <String, dynamic>{
      'im:name': instance.name,
      'im:image': instance.images,
      'summary': instance.summary,
      'im:price': instance.price,
      'im:contentType': instance.contentType,
      'rights': instance.rights,
      'title': instance.title,
      'id': instance.id,
      'im:artist': instance.artist,
      'category': instance.category,
      'im:releaseDate': instance.releaseDate,
    };
