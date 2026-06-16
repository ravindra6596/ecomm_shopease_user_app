import 'package:e_comm_user/core/exception_handler.dart';
import 'package:e_comm_user/models/chatbot_response_model.dart';
import 'package:e_comm_user/repository/chatbot_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'chatbot_event.dart';
import 'chatbot_state.dart';

@injectable
class ChatbotBloc extends Bloc<ChatbotEvent, ChatbotState> {

  final ChatBotRepository repository;

  ChatbotBloc(this.repository)
      : super(ChatbotInitialState()) {

    on<SendMessageEvent>(sendMessage);
    on<LoadChatHistoryEvent>(loadChatHistory);
  }

  /// Messages List
  List<ChatMessageModel> messages = [];

  Future<void> sendMessage(
      SendMessageEvent event,
      Emitter<ChatbotState> emit,
      ) async {

    try {

      /// -----------------------------------
      /// ADD USER MESSAGE
      /// -----------------------------------
      messages.add(
        ChatMessageModel(
          message: event.message,
          isUser: true,
          createdAt: DateTime.now(),
          products: null,
        ),
      );

      emit(
        ChatbotLoadedState(
          List.from(messages),
        ),
      );

      /// -----------------------------------
      /// ADD TYPING
      /// -----------------------------------
      messages.add(
        ChatMessageModel(
          message: '',
          isUser: false,
          isTyping: true,
          createdAt: DateTime.now(),
          products: null,
        ),
      );

      emit(
        ChatbotLoadedState(
          List.from(messages),
        ),
      );

      /// -----------------------------------
      /// API CALL
      /// -----------------------------------
      final result =
      await repository.chatBot(
        event.message,
      );

      /// -----------------------------------
      /// REMOVE TYPING
      /// -----------------------------------
      if (messages.isNotEmpty &&
          messages.last.isTyping) {

        messages.removeLast();
      }

      switch (result) {

      /// ===================================
      /// SUCCESS
      /// ===================================
        case Success<ChatbotResponseModel, Exception>():

          final response = result.data;
          final apiMessages = response.data?.messages ?? [];
          final botResponse = response.data?.botResponse;
          final products = botResponse?.products;

          /// REMOVE LOCAL USER MESSAGE
          /// because backend already returns it
          if (messages.isNotEmpty && messages.last.isUser) {
            messages.removeLast();
          }

          /// ADD API MESSAGES
          for (final item in apiMessages) {
            messages.add(
              ChatMessageModel(
                message: item.message ?? '',
                isUser:  item.sender == "user",
                createdAt: DateTime.tryParse(item.createdAt ?? ''),
                products: null,
              ),
            );

          }

          if (botResponse != null && messages.isNotEmpty) {

            final lastIndex = messages.lastIndexWhere((m) => !m.isUser);

            if (lastIndex != -1) {
              final old = messages[lastIndex];

              messages[lastIndex] = ChatMessageModel(
                message: botResponse.reply ?? old.message,
                isUser: false,
                createdAt: old.createdAt,
                products: botResponse.products,
              );
            }
          }
          emit(
            ChatbotLoadedState(
              List.from(messages),
            ),
          );

      /// ===================================
      /// FAILURE
      /// ===================================
        case Failure<
            ChatbotResponseModel, Exception>():
          messages.add(
            ChatMessageModel(
              message:result.error.toString(),
              isUser: false,
              createdAt: DateTime.now(),
              products: null,
            ),
          );

          emit(
            ChatbotLoadedState(
              List.from(messages),
            ),
          );
      }

    } catch (e) {

      /// REMOVE TYPING
      if (messages.isNotEmpty &&
          messages.last.isTyping) {

        messages.removeLast();
      }

      emit(
        ChatbotErrorState(
          e.toString(),
        ),
      );
    }
  }

  loadChatHistory(LoadChatHistoryEvent event,emit) async {
    emit(ChatbotLoadingState());

    try {
      final result =  await repository.getChatHistory();
      switch (result) {
        case Success<ChatbotHistoryResponseModel, Exception>():
          final response = result.data;
          final apiMessages = response.data ?? [];
          messages.clear();
          for (final conversation in apiMessages) {
            for (final item in conversation.messages ?? []) {
              messages.add(
                ChatMessageModel(
                  message: item.message ?? '',
                  isUser: item.sender == 'user',
                  createdAt: DateTime.tryParse(item.createdAt ?? ''),
                  products: item.products,
                ),
              );
            }
          }
          // Sort messages by createdAt
          messages.sort(
                (a, b) => (a.createdAt ?? DateTime(0))
                .compareTo(b.createdAt ?? DateTime(0)),
          );
          emit(ChatbotLoadedState(List.from(messages)));

        case Failure<ChatbotHistoryResponseModel, Exception>():

          emit(ChatbotErrorState(
            result.error.toString(),
          ));
      }
    } catch (e) {
      emit(ChatbotErrorState(e.toString()));
    }
  }
}