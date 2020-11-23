part of 'redemptionCode.dart';

RedemptionCode _$RedemptionCodeFromJson(Map<String, dynamic> json) {
  return RedemptionCode()
    ..code = json['code'] as String
    ..userUid = json['userUid'] as String
    ..username = json['username'] as String
    ..description = json['description'] as String
    ..expire = json['timestamp'] as String
    ..avatarUrl = json['avatarUrl'] as String;
}

Map<String, dynamic> _$RedemptionCodeToJson(RedemptionCode instance) =>
    <String, dynamic>{
      'code': instance.code,
      'userUid': instance.userUid,
      'username': instance.username,
      'description': instance.description,
      'expire': instance.expire,
      'avatarUrl': instance.avatarUrl,
    };
