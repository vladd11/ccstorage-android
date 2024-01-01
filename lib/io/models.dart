import 'package:json_annotation/json_annotation.dart';
part 'models.g.dart';

@JsonSerializable()
class ItemCount {
  ItemCount(this.name, this.displayName, this.count);

  @JsonKey(required: true)
  String name;

  @JsonKey(required: true)
  String displayName;

  @JsonKey(required: true)
  int count;

  factory ItemCount.fromJson(Map<String, dynamic> json) => _$ItemCountFromJson(json);
  Map<String, dynamic> toJson() => _$ItemCountToJson(this);
}

@JsonSerializable()
class Robot {
  Robot(this.isAdvanced, this.name, this.isConnected);

  @JsonKey(required: true)
  bool isAdvanced;

  @JsonKey(required: true)
  String name;

  @JsonKey(required: true)
  bool isConnected;

  factory Robot.fromJson(Map<String, dynamic> json) => _$RobotFromJson(json);
  Map<String, dynamic> toJson() => _$RobotToJson(this);
}