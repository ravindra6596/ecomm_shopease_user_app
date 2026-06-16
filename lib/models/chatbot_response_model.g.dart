// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chatbot_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatbotResponseModel _$ChatbotResponseModelFromJson(
        Map<String, dynamic> json) =>
    ChatbotResponseModel(
      status: json['status'] as bool?,
      statusCode: (json['statusCode'] as num?)?.toInt(),
      error: json['error'] as String?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : ChatResponseData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ChatbotResponseModelToJson(
        ChatbotResponseModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'statusCode': instance.statusCode,
      'error': instance.error,
      'message': instance.message,
      'data': instance.data,
    };

ChatResponseData _$ChatResponseDataFromJson(Map<String, dynamic> json) =>
    ChatResponseData(
      conversationId: (json['conversation_id'] as num?)?.toInt(),
      messages: (json['messages'] as List<dynamic>?)
          ?.map((e) => ChatApiMessage.fromJson(e as Map<String, dynamic>))
          .toList(),
      botResponse: json['bot_response'] == null
          ? null
          : BotResponseModel.fromJson(
              json['bot_response'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ChatResponseDataToJson(ChatResponseData instance) =>
    <String, dynamic>{
      'conversation_id': instance.conversationId,
      'messages': instance.messages,
      'bot_response': instance.botResponse,
    };

ChatApiMessage _$ChatApiMessageFromJson(Map<String, dynamic> json) =>
    ChatApiMessage(
      id: (json['id'] as num?)?.toInt(),
      sender: json['sender'] as String?,
      message: json['message'] as String?,
      createdAt: json['created_at'] as String?,
      products: (json['products'] as List<dynamic>?)
          ?.map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ChatApiMessageToJson(ChatApiMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sender': instance.sender,
      'message': instance.message,
      'created_at': instance.createdAt,
      'products': instance.products,
    };

ChatbotHistoryResponseModel _$ChatbotHistoryResponseModelFromJson(
        Map<String, dynamic> json) =>
    ChatbotHistoryResponseModel(
      status: json['status'] as bool?,
      statusCode: (json['statusCode'] as num?)?.toInt(),
      error: json['error'] as String?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => ChatHistoryData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ChatbotHistoryResponseModelToJson(
        ChatbotHistoryResponseModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'statusCode': instance.statusCode,
      'error': instance.error,
      'message': instance.message,
      'data': instance.data,
    };

ChatHistoryData _$ChatHistoryDataFromJson(Map<String, dynamic> json) =>
    ChatHistoryData(
      conversationId: (json['conversation_id'] as num?)?.toInt(),
      messages: (json['messages'] as List<dynamic>?)
          ?.map((e) => ChatHistoryMessage.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ChatHistoryDataToJson(ChatHistoryData instance) =>
    <String, dynamic>{
      'conversation_id': instance.conversationId,
      'messages': instance.messages,
    };

ChatHistoryMessage _$ChatHistoryMessageFromJson(Map<String, dynamic> json) =>
    ChatHistoryMessage(
      id: (json['id'] as num?)?.toInt(),
      sender: json['sender'] as String?,
      message: json['message'] as String?,
      createdAt: json['created_at'] as String?,
      products: (json['products'] as List<dynamic>?)
          ?.map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ChatHistoryMessageToJson(ChatHistoryMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sender': instance.sender,
      'message': instance.message,
      'products': instance.products,
      'created_at': instance.createdAt,
    };

BotResponseModel _$BotResponseModelFromJson(Map<String, dynamic> json) =>
    BotResponseModel(
      reply: json['reply'] as String?,
      products: (json['products'] as List<dynamic>?)
          ?.map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BotResponseModelToJson(BotResponseModel instance) =>
    <String, dynamic>{
      'reply': instance.reply,
      'products': instance.products,
    };

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) => ProductModel(
      name: json['name'] as String?,
      price: (json['price'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'price': instance.price,
    };
