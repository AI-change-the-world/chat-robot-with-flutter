part of 'chat_page_bloc.dart';

enum ChatPageStatus { initial, add }

class ChatPageState extends Equatable {
  const ChatPageState({
    this.status = ChatPageStatus.initial,
    this.widgets = const [],
  });

  final ChatPageStatus status;
  final List<Widget> widgets;

  @override
  List<Object> get props => [status, widgets];

  ChatPageState copyWith(ChatPageStatus? status, List<Widget>? widgets) {
    return ChatPageState(
      status: status ?? this.status,
      widgets: widgets ?? this.widgets,
    );
  }

  @override
  bool operator ==(Object other) {
    if (this.status == ChatPageStatus.add) {
      return false;
    }
    return identical(this, other) ||
        other is Equatable &&
            runtimeType == other.runtimeType &&
            qu_utils.equals(props, other.props);
  }

  @override
  int get hashCode => super.hashCode;
}
