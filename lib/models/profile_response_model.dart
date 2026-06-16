import 'package:json_annotation/json_annotation.dart';
part 'profile_response_model.g.dart';
@JsonSerializable()
class ProfileResponseModel {
  final bool? status;
  final int? statusCode;
  final String? error;
  final String? message;
  final ProfileData? data;

  ProfileResponseModel({
    this.status,
    this.statusCode,
    this.error,
    this.message,
    this.data,
  });

  factory ProfileResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileResponseModelToJson(this);
}
 
@JsonSerializable()
class ProfileData {
  final int? id;
  final String? name;
  final String? email;
  final bool? is_active;
  final String? role;
  final String? created_at;
  final String? updated_at;

  ProfileData({
    this.id,
    this.name,
    this.email,
    this.is_active,
    this.role,
    this.created_at,
    this.updated_at,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) =>
      _$ProfileDataFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileDataToJson(this);
}
@JsonSerializable()
class UpdateProfileRequestModel {
  String? name;
  String? email;

  UpdateProfileRequestModel({
    this.name,
    this.email,
  });

  factory UpdateProfileRequestModel.fromJson(Map<String, dynamic> json) =>
      _$UpdateProfileRequestModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$UpdateProfileRequestModelToJson(this);
}