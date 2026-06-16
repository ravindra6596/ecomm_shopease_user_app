import 'package:e_comm_user/core/api_client.dart';
import 'package:e_comm_user/core/exception_handler.dart';
import 'package:e_comm_user/models/chatbot_response_model.dart';
import 'package:e_comm_user/utils/functions.dart';
import 'package:injectable/injectable.dart';

abstract class ChatBotRepository {
  Future<Result<ChatbotResponseModel, Exception>> chatBot(String message);
  Future<Result<ChatbotHistoryResponseModel, Exception>> getChatHistory( );

}
@Injectable(as: ChatBotRepository)
class ChatBotRepositoryImpl implements ChatBotRepository {
  ChatBotRepositoryImpl(this.apiClient);

  final ApiClient apiClient;

  @override
  Future<Result<ChatbotResponseModel, Exception>> chatBot(String message) async {
    try {
      final chatResponse = await apiClient.chatBot(
        {"message": message});
      if (chatResponse.statusCode == 200) {
        return Success(chatResponse);
      } else {
        return Failure(chatResponse.message ?? '');
      }
    } on Exception catch (e) {
      dynamic res = Functions.getErrorResponse(e);
      if ((res['message']) != null && res['message'].toString().isNotEmpty) {
        return Failure(res['message']);
      } else {
        return Failure(e.toString());
      }
    }
  }
  @override
  Future<Result<ChatbotHistoryResponseModel, Exception>> getChatHistory( ) async {
    try {
      final response = await apiClient.getChatHistory();
      if (response.statusCode == 200) {
        return Success(response);
      } else {
        return Failure(response.message ?? '');
      }
    } on Exception catch (e) {
      dynamic res = Functions.getErrorResponse(e);
      if ((res['message']) != null && res['message'].toString().isNotEmpty) {
        return Failure(res['message']);
      } else {
        return Failure(e.toString());
      }
    }
  }
}