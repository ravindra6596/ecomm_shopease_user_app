import 'package:json_annotation/json_annotation.dart';
part 'chatbot_response_model.g.dart';

@JsonSerializable()
class ChatbotResponseModel {

  final bool? status;
  final int? statusCode;
  final String? error;
  final String? message;
  final ChatResponseData? data;

  ChatbotResponseModel({
    this.status,
    this.statusCode,
    this.error,
    this.message,
    this.data,
  });

  factory ChatbotResponseModel.fromJson(
      Map<String, dynamic> json,
      ) =>
      _$ChatbotResponseModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ChatbotResponseModelToJson(this);
}
@JsonSerializable()
class ChatResponseData {

  @JsonKey(name: 'conversation_id')
  final int? conversationId;

  final List<ChatApiMessage>? messages;
  @JsonKey(name: 'bot_response')
  final BotResponseModel? botResponse;
  ChatResponseData({
    this.conversationId,
    this.messages,
    this.botResponse,
  });

  factory ChatResponseData.fromJson(
      Map<String, dynamic> json,
      ) =>
      _$ChatResponseDataFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ChatResponseDataToJson(this);
}
@JsonSerializable()
class ChatApiMessage {

  final int? id;

  final String? sender;

  final String? message;

  @JsonKey(name: 'created_at')
  final String? createdAt;
  List<ProductModel>? products;
  ChatApiMessage({
    this.id,
    this.sender,
    this.message,
    this.createdAt,
    this.products,
  });

  factory ChatApiMessage.fromJson(
      Map<String, dynamic> json,
      ) =>
      _$ChatApiMessageFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ChatApiMessageToJson(this);
}
class ChatMessageModel {

  final String message;
  final bool isUser;
  final bool isTyping;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  final List<ProductModel>? products;
  ChatMessageModel({
    required this.message,
    required this.isUser,
    this.isTyping = false,
    this.createdAt,
    this.products,
  });
}
@JsonSerializable()
class ChatbotHistoryResponseModel {

  final bool? status;
  final int? statusCode;
  final String? error;
  final String? message;
  final List<ChatHistoryData>? data;

  ChatbotHistoryResponseModel({
    this.status,
    this.statusCode,
    this.error,
    this.message,
    this.data,
  });

  factory ChatbotHistoryResponseModel.fromJson(
      Map<String, dynamic> json,
      ) =>
      _$ChatbotHistoryResponseModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ChatbotHistoryResponseModelToJson(this);
}
@JsonSerializable()
class ChatHistoryData {

  @JsonKey(name: 'conversation_id')
  final int? conversationId;

  final List<ChatHistoryMessage>? messages;

  ChatHistoryData({
    this.conversationId,
    this.messages,
  });

  factory ChatHistoryData.fromJson(
      Map<String, dynamic> json,
      ) =>
      _$ChatHistoryDataFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ChatHistoryDataToJson(this);
}
@JsonSerializable()
class ChatHistoryMessage {

  final int? id;
  final String? sender;
  final String? message;
  final List<ProductModel>? products;
  @JsonKey(name: 'created_at')
  final String? createdAt;

  ChatHistoryMessage({
    this.id,
    this.sender,
    this.message,
    this.createdAt,
    this.products,
  });

  factory ChatHistoryMessage.fromJson(
      Map<String, dynamic> json,
      ) =>
      _$ChatHistoryMessageFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ChatHistoryMessageToJson(this);
}

@JsonSerializable()
class BotResponseModel {

  final String? reply;
  final List<ProductModel>? products;

  BotResponseModel({
    this.reply,
    this.products,
  });

  factory BotResponseModel.fromJson(Map<String, dynamic> json) =>
      _$BotResponseModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$BotResponseModelToJson(this);
}
@JsonSerializable()
class ProductModel {

  final String? name;
  final int? price;

  ProductModel({
    this.name,
    this.price,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ProductModelToJson(this);
}