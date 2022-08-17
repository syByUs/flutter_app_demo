


import 'package:flutter_app_demo/models/sqlite/app_store_sql_model.dart';
import 'package:json_annotation/json_annotation.dart';

import 'label_map_model.dart';

part 'application_model.g.dart';

@JsonSerializable()
class ApplicationModel {

  @JsonKey(name: 'im:name')
  final LabelMapModel name;

  @JsonKey(name: 'im:image')
  final List<LabelMapModel> images;

  final LabelMapModel summary;

  @JsonKey(name: 'im:price')
  final LabelMapModel price;

  @JsonKey(name: 'im:contentType')
  final LabelMapModel contentType;

  final LabelMapModel rights;

  final LabelMapModel title;

  //link 暂时忽略

  final LabelMapModel id;

  @JsonKey(name: 'im:artist')
  final LabelMapModel artist;

  final LabelMapModel category;

  @JsonKey(name: 'im:releaseDate')
  final LabelMapModel releaseDate;

  ApplicationModel(this.name, this.images, this.summary, this.price, this.contentType, this.rights, this.title, this.id, this.artist, this.category, this.releaseDate);

  factory ApplicationModel.fromJson(Map<String, dynamic> json) => _$ApplicationModelFromJson(json);

  Map<String, dynamic> toJson() => _$ApplicationModelToJson(this);
}
