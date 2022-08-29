import 'package:flutter_app_demo/models/sqlite/lookup_sql_model.dart';
import 'package:json_annotation/json_annotation.dart';

import 'sqlite/app_store_sql_model.dart';

part 'lookup_model.g.dart';

@JsonSerializable()
class LookupModel {
  final int trackId;

  final double averageUserRatingForCurrentVersion;

  final int userRatingCountForCurrentVersion;

  LookupModel(this.averageUserRatingForCurrentVersion, this.userRatingCountForCurrentVersion, this.trackId);

  factory LookupModel.fromJson(Map<String, dynamic> json) => _$LookupModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$LookupModelToJson(this);
}


extension Helper on LookupModel {
  LookupSqlModel get sqlModel => LookupSqlModel.fromLookupModel(this);
}