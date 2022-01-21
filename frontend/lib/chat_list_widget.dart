import 'package:flutter/material.dart';
import 'package:zhixiaoxia_extra/bloc/chat_page_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class ChatListWidget extends StatefulWidget {
  ChatListWidget({Key? key, required this.scrollController}) : super(key: key);
  ScrollController scrollController;

  @override
  _ChatListWidgetState createState() => _ChatListWidgetState();
}

class _ChatListWidgetState extends State<ChatListWidget> {
  late ChatPageBloc _chatPageBloc;
  // ScrollController _scrollController = ScrollController();
  // late List<Widget> ws;

  @override
  void initState() {
    super.initState();
    _chatPageBloc = context.read<ChatPageBloc>();
    // ws = _chatPageBloc.state.widgets;
  }

  @override
  void dispose() {
    // _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: ListView.builder(
        // reverse: true,
        shrinkWrap: true,
        padding: EdgeInsets.only(top: 27),
        itemBuilder: (context, index) {
          return _chatPageBloc.state.widgets[index];
        },
        itemCount: _chatPageBloc.state.widgets.length,
        physics: const AlwaysScrollableScrollPhysics(),
        controller: widget.scrollController,
      ),
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
    );
  }
}
