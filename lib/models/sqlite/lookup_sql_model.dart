import 'package:flutter_app_demo/models/lookup_model.dart';

import 'app_store_sql_model.dart';

class LookupSqlModel with JsonProtocol {
  final String id;

  final double averageUserRatingForCurrentVersion;

  final int userRatingCountForCurrentVersion;

  LookupSqlModel(this.id, this.averageUserRatingForCurrentVersion, this.userRatingCountForCurrentVersion);

  factory LookupSqlModel.fromLookupModel(LookupModel lookupModel) {
    return LookupSqlModel(
      lookupModel.trackId.toString(),
      lookupModel.averageUserRatingForCurrentVersion,
      lookupModel.userRatingCountForCurrentVersion,
    );
  }

  factory LookupSqlModel.fromJson(Map<String, dynamic> json) => LookupSqlModel(
        json['id'] as String,
        (json['averageUserRatingForCurrentVersion'] as num).toDouble(),
        json['userRatingCountForCurrentVersion'] as int,
      );

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': this.id,
        'averageUserRatingForCurrentVersion': this.averageUserRatingForCurrentVersion,
        'userRatingCountForCurrentVersion': this.userRatingCountForCurrentVersion,
      };
}

extension Helper on LookupSqlModel {
  LookupModel get model => LookupModel(
        this.averageUserRatingForCurrentVersion,
        this.userRatingCountForCurrentVersion,
        int.parse(this.id),
      );
}
