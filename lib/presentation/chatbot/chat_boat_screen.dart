import 'package:auto_route/annotations.dart';
import 'package:e_comm_user/bloc/chatbot/chatbot_bloc.dart';
import 'package:e_comm_user/bloc/chatbot/chatbot_event.dart';
import 'package:e_comm_user/bloc/chatbot/chatbot_state.dart';
import 'package:e_comm_user/di/configure.dart';
import 'package:e_comm_user/models/chatbot_response_model.dart';
import 'package:e_comm_user/utils/colors.dart';
import 'package:e_comm_user/utils/functions.dart';
import 'package:e_comm_user/utils/strings.dart';
import 'package:e_comm_user/widgets/custom_text.dart';
import 'package:e_comm_user/widgets/date_seprator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

@RoutePage()
class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController controller = TextEditingController();

  final ScrollController scrollController = ScrollController();
  ChatbotBloc chatbotBloc = getIt<ChatbotBloc>();
  void scrollToBottom() {
    Future.delayed(
      const Duration(milliseconds: 100),
          () {
        if (scrollController.hasClients) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      },
    );
  }
  @override
  void initState() {
    super.initState();

    chatbotBloc = getIt<ChatbotBloc>();

    chatbotBloc.add(
      LoadChatHistoryEvent(), // your conversation id
    );
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: chatbotBloc,
      child: Scaffold(
        backgroundColor: whiteColor,
        /// ---------------- APPBAR
        appBar: AppBar(
          elevation: 0,
          backgroundColor: whiteColor,
          surfaceTintColor: whiteColor,
          titleSpacing: 0,
          title: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: primaryColor.withValues(alpha: .1),
                child: Icon(
                  Icons.support_agent,
                  color: primaryColor,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text:helpCenter,
                    fontSize: 16.px,
                    style: CustomTextStyle.semiBold,
                    color: blackColor,
                  ),
                  CustomText(
                    text: online,
                    fontSize: 12.px,
                    style: CustomTextStyle.regular,
                    color: successColor,
                  ),
                ],
              )
            ],
          ),
        ),

        /// ---------------- BODY
        body: Column(
          children: [
            /// QUICK ACTIONS
            Visibility(
              visible: false,
              child: SizedBox(
                height: 55,
                child: ListView(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  scrollDirection: Axis.horizontal,
                  children: [
                    quickButton('Track Order'),
                    quickButton('Return'),
                    quickButton('Refund'),
                    quickButton('Cancel'),
                    quickButton('Payment'),
                  ],
                ),
              ),
            ),

            /// CHAT LIST
            Expanded(
              child: BlocConsumer<ChatbotBloc, ChatbotState>(
                listener: (context, state) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    scrollToBottom();
                  });
                },
                builder: (context, state) {

                  if (state is ChatbotLoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if(state is ChatbotLoadedState){
                    final messages = state.messages;

                    if (messages.isEmpty) {
                      return const Center(
                        child: Text("No chats yet"),
                      );
                    }

                    return ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.only(top: 12, bottom: 12),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final item = messages[index];
                        bool showDate = false;

                        if (index == 0) {
                          showDate = true;
                        } else {
                          final previous = messages[index - 1];
                          showDate = !DateUtils.isSameDay(
                            item.createdAt,
                            previous.createdAt,
                          );
                        }
                        // return ChatBubble(message: item);
                        return Column(
                          children: [
                            if (showDate)
                              DateSeparator(
                                date: Functions.formatDateTime(item.createdAt.toString(),format: 'dd MMM yyyy'),
                              ),

                            ChatBubble(message: item),
                          ],
                        );
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),

            /// INPUT
            SafeArea(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        minLines: 1,
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintText: askSomething,
                          filled: true,
                          fillColor: const Color(0xffF5F7FB),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    BlocBuilder<ChatbotBloc, ChatbotState>(
                      builder: (context, state) {
                        return GestureDetector(
                          onTap: () {
                            if (controller.text.trim().isEmpty) {
                              return;
                            }

                            chatbotBloc.add(
                              SendMessageEvent(
                                controller.text.trim(),
                              ),
                            );

                            controller.clear();
                          },
                          child: Container(
                            height: 52,
                            width: 52,
                            decoration: BoxDecoration(
                              color: primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.send,
                              color: whiteColor,
                            ),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget quickButton(String title) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: Colors.grey.shade300,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

/// ----------------------------
/// CHAT BUBBLE
/// ----------------------------
class ChatBubble extends StatelessWidget {
  final ChatMessageModel message;

  const ChatBubble({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment:
      message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          left: message.isUser ? 70 : 12,
          right: message.isUser ? 12 : 70,
          bottom: 10,
        ),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: message.isUser
              ? primaryColor.withValues(alpha: .7)
              : successColor.withValues(alpha: .2),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(2.h),
            topRight: Radius.circular(2.h),
            bottomLeft: Radius.circular(
              message.isUser ? 2.h : .1.h,
            ),
            bottomRight: Radius.circular(
              message.isUser ? .1.h : 2.h,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: blackColor.withValues(alpha: .03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: message.isTyping
            ? const TypingWidget()
            : Column(
          crossAxisAlignment:  CrossAxisAlignment.start,
          children: [
            CustomText(
              text:message.message,
                color: message.isUser
                    ? whiteColor
                    : blackColor.withValues(alpha: .87),
                fontSize: 15,
                height: 1.4,
            ),
            SizedBox(height: 1.h),
            if (message.products != null && message.products?.isNotEmpty == true) ...[
              SizedBox(height: 1.h),

              ...message.products!.map((p) {
                return Container(
                  margin: EdgeInsets.only(top: 1.h),
                  padding: EdgeInsets.all(1.h),
                  decoration: BoxDecoration(
                    color: successColor.withValues(alpha: .1),
                    borderRadius: BorderRadius.circular(1.h),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(p.name ?? '')),
                      CustomText(text:"₹${Functions.formatPrice(p.price ?? 0)}"),
                    ],
                  ),
                );
              }),
            ],
            Align(
              alignment: Alignment.bottomRight,
              child: CustomText(
                text: Functions.formatDateTime(DateFormat('hh:mm a').format(message.createdAt?.toLocal() ?? DateTime.now())),
                  color: message.isUser
                      ? whiteColor
                      : greyColor,
                  fontSize: 11,
              ),
            )
          ],
        ),
      ),
    );
  }

}

/// ----------------------------
/// TYPING WIDGET
/// ----------------------------
class TypingWidget extends StatelessWidget {
  const TypingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        dot(),
        const SizedBox(width: 4),
        dot(),
        const SizedBox(width: 4),
        dot(),
      ],
    );
  }

  Widget dot() {
    return Container(
      height: 8,
      width: 8,
      decoration: const BoxDecoration(
        color: Colors.grey,
        shape: BoxShape.circle,
      ),
    );
  }
}
