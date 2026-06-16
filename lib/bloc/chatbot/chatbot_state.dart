import 'package:e_comm_user/models/chatbot_response_model.dart';

abstract class ChatbotState {}

class ChatbotInitialState extends ChatbotState {}

class ChatbotLoadingState extends ChatbotState {}

class ChatbotLoadedState extends ChatbotState {
  final List<ChatMessageModel> messages;

  ChatbotLoadedState(this.messages );
}

class ChatbotErrorState extends ChatbotState {
  final String error;

  ChatbotErrorState(this.error);
}