part of 'chat_page_bloc.dart';

abstract class ChatPageEvent extends Equatable {
  const ChatPageEvent();

  @override
  List<Object> get props => [];
}

class InitChatPageEvent extends ChatPageEvent {}

class AddChatMessageEvent extends ChatPageEvent {
  final Widget widget;
  const AddChatMessageEvent({required this.widget});
}

class AddChatMessageEventV2 extends ChatPageEvent {
  final Widget widget;
  const AddChatMessageEventV2({required this.widget});
}

class ReplaceChatMessageEvent extends ChatPageEvent {
  final Widget widget;
  const ReplaceChatMessageEvent({required this.widget});
}
