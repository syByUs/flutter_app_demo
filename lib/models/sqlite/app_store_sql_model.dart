import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_app_demo/models/application_model.dart';
import 'package:lpinyin/lpinyin.dart';

mixin JsonProtocol {
  Map<String, dynamic> toJson();
}

class AppStoreSqlModel with JsonProtocol {
  final String id; //唯一标识
  final String name; //应用名
  final String namePinyin;//name的拼音
  final String summary; //应用描述
  final String artist; //开发者信息
  final String content;
  AppStoreSqlModel(this.id, this.name, this.namePinyin, this.summary, this.artist, this.content);

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': this.id,
        'name': this.name,
        'namePinyin': this.namePinyin,
        'summary': this.summary,
        'artist': this.artist,
        'content': this.content,
      };

  factory AppStoreSqlModel.fromApplicationModel(ApplicationModel applicationModel) {
    String? id = applicationModel.id.attributes?['im:id'];
    String? name = applicationModel.name.label;
    String? summary = applicationModel.summary.label;
    String? artist = applicationModel.artist.label;
    String? content = json.encode(applicationModel.toJson());
    String namePinyin = name ?? '';
    if (name != null && ChineseHelper.isChinese(name)) {
      namePinyin = "${PinyinHelper.getShortPinyin(name)}|${PinyinHelper.getFirstWordPinyin(name)}";
    }

    if (id == null || name == null || summary == null || artist == null || content == null) {
      throw PlatformException(
        code: 'value-error',
        message: 'value is null',
      );
    }
    return AppStoreSqlModel(
      id,
      name,
      namePinyin,
      summary,
      artist,
      content,
    );
  }
}
