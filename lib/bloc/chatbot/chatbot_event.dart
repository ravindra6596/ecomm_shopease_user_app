abstract class ChatbotEvent {}

class SendMessageEvent extends ChatbotEvent {
  final String message;

  SendMessageEvent(this.message);
}
class LoadChatHistoryEvent extends ChatbotEvent {


  LoadChatHistoryEvent( );
}