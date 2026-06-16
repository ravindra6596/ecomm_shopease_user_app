import 'package:e_comm_user/models/user_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_details_model.g.dart';

@JsonSerializable()
class UserDetailsModel {
  bool? status;
  int? statusCode;
  String? message;
  Users? data;

  UserDetailsModel({this.status, this.statusCode, this.message, this.data});

  factory UserDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$UserDetailsModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserDetailsModelToJson(this);
}
