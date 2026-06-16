// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddressRequestModel _$AddressRequestModelFromJson(Map<String, dynamic> json) =>
    AddressRequestModel(
      full_name: json['full_name'] as String?,
      phone: json['phone'] as String?,
      address_line: json['address_line'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      country: json['country'] as String?,
      pincode: json['pincode'] as String?,
      is_default: json['is_default'] as bool? ?? false,
      address_type: json['address_type'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$AddressRequestModelToJson(
        AddressRequestModel instance) =>
    <String, dynamic>{
      if (instance.full_name case final value?) 'full_name': value,
      if (instance.phone case final value?) 'phone': value,
      if (instance.address_line case final value?) 'address_line': value,
      if (instance.city case final value?) 'city': value,
      if (instance.state case final value?) 'state': value,
      if (instance.country case final value?) 'country': value,
      if (instance.pincode case final value?) 'pincode': value,
      if (instance.is_default case final value?) 'is_default': value,
      if (instance.address_type case final value?) 'address_type': value,
      if (instance.latitude case final value?) 'latitude': value,
      if (instance.longitude case final value?) 'longitude': value,
    };

UpdateOrderAddressRequest _$UpdateOrderAddressRequestFromJson(
        Map<String, dynamic> json) =>
    UpdateOrderAddressRequest(
      address_id: (json['address_id'] as num).toInt(),
    );

Map<String, dynamic> _$UpdateOrderAddressRequestToJson(
        UpdateOrderAddressRequest instance) =>
    <String, dynamic>{
      'address_id': instance.address_id,
    };
