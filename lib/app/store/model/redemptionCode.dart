import 'package:data_plugin/bmob/table/bmob_object.dart';
import 'package:json_annotation/json_annotation.dart';

part 'redemptionCode.g.dart';

@JsonSerializable()
class RedemptionCode extends BmobObject {
  String code;
  String userUid;
  String username;
  String description;
  String expire;
  String avatarUrl;
  RedemptionCode();

  factory RedemptionCode.fromJson(Map<String, dynamic> json) =>
      _$RedemptionCodeFromJson(json);

  //此处与类名一致，由指令自动生成代码 生成个屁 手写的
  Map<String, dynamic> toJson() => _$RedemptionCodeToJson(this);

  @override
  Map getParams() {
    return toJson();
  }
}
