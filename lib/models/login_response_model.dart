import 'package:json_annotation/json_annotation.dart';
part 'login_response_model.g.dart';

@JsonSerializable()
class LoginResponseModel {
  final bool? status;
  final int? statusCode;
  final String? error;
  final String? message;
  final LoginData? data;

  LoginResponseModel({
    this.status,
    this.statusCode,
    this.error,
    this.message,
    this.data,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseModelToJson(this);
}

@JsonSerializable()
class LoginData {
  final String? access_token;
  final String? refresh_token;
  final String? token_type;
  final User? user;

  LoginData({
    this.access_token,
    this.refresh_token,
    this.token_type,
    this.user,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) =>
      _$LoginDataFromJson(json);

  Map<String, dynamic> toJson() => _$LoginDataToJson(this);
}

@JsonSerializable()
class User {
  final int? id;
  final String? email;
  final bool? is_active;
  final String? role;
  final String? created_at;
  final String? updated_at;

  User({
    this.id,
    this.email,
    this.is_active,
    this.role,
    this.created_at,
    this.updated_at,
  });

  factory User.fromJson(Map<String, dynamic> json) =>
      _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
