import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String id;
  String signName;
  int signPhone;
  String signEmail;
  bool block;
  int v;

  UserModel({
    required this.id,
    required this.signName,
    required this.signPhone,
    required this.signEmail,
    required this.block,
    required this.v,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["_id"],
        signName: json["signName"],
        signPhone: json["signPhone"],
        signEmail: json["signEmail"],
        block: json["block"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "signName": signName,
        "signPhone": signPhone,
        "signEmail": signEmail,
        "block": block,
        "__v": v,
      };
}
