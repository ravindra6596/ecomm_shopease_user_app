import 'package:json_annotation/json_annotation.dart';
part 'logout_response_model.g.dart';
@JsonSerializable()
class LogoutResponseModel {
  final bool? status;
  final int? statusCode;
  final String? error;
  final String? message;
  final Map<String, dynamic>? data;

  LogoutResponseModel({
    this.status,
    this.statusCode,
    this.error,
    this.message,
    this.data,
  });

  factory LogoutResponseModel.fromJson(Map<String, dynamic> json) =>
      _$LogoutResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$LogoutResponseModelToJson(this);
}