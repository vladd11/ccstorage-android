// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemCount _$ItemCountFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['name', 'displayName', 'count'],
  );
  return ItemCount(
    json['name'] as String,
    json['displayName'] as String,
    json['count'] as int,
  );
}

Map<String, dynamic> _$ItemCountToJson(ItemCount instance) => <String, dynamic>{
      'name': instance.name,
      'displayName': instance.displayName,
      'count': instance.count,
    };

Robot _$RobotFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['isAdvanced', 'name', 'isConnected'],
  );
  return Robot(
    json['isAdvanced'] as bool,
    json['name'] as String,
    json['isConnected'] as bool,
  );
}

Map<String, dynamic> _$RobotToJson(Robot instance) => <String, dynamic>{
      'isAdvanced': instance.isAdvanced,
      'name': instance.name,
      'isConnected': instance.isConnected,
    };
