


import 'package:json_annotation/json_annotation.dart';

part 'label_map_model.g.dart';

@JsonSerializable()
class LabelMapModel {

//  @JsonKey(name: '')
  final String? label;
  final Map<String ,dynamic>? attributes;

  LabelMapModel(this.label, this.attributes);

  factory LabelMapModel.fromJson(Map<String, dynamic> json) => _$LabelMapModelFromJson(json);

  Map<String, dynamic> toJson() => _$LabelMapModelToJson(this);
}