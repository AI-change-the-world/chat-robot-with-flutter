import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zhixiaoxia_extra/ask_question_model.dart';
import 'package:zhixiaoxia_extra/bloc/chat_page_bloc.dart';
import 'package:zhixiaoxia_extra/chat_list_widget.dart';
import 'package:zhixiaoxia_extra/custom_response_model.dart';
import 'package:zhixiaoxia_extra/dioutils.dart';
import 'package:zhixiaoxia_extra/question_model.dart';
import 'package:zhixiaoxia_extra/utils.dart';

class CustomChatPage extends StatefulWidget {
  CustomChatPage({Key? key}) : super(key: key);

  @override
  _CustomChatPageState createState() => _CustomChatPageState();
}

class _CustomChatPageState extends State<CustomChatPage> {
  late ChatPageBloc _chatPageBloc;
  TextEditingController textEditingController = TextEditingController();

  ScrollController _scrollController = ScrollController(); //listview的控制器
  DioUtil dioUtil = DioUtil();
  @override
  void initState() {
    super.initState();
    _chatPageBloc = context.read<ChatPageBloc>();
    _chatPageBloc.add(AddChatMessageEvent(
        widget: Card(
      margin: EdgeInsets.all(paddingSize),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(paddingSize),
            alignment: Alignment.centerLeft,
            child: Text(
              "热门问题",
              style: TextStyle(color: Colors.blueAccent, fontSize: 20),
            ),
          ),
          Divider(),
          AnswerWidget()
        ],
      ),
    )));
  }

  @override
  void dispose() {
    textEditingController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Container(
            width: 50,
            height: 50,
            child: Image.asset(
              "assets/images/icon.png",
              fit: BoxFit.contain,
            ),
          ),
        ),
        body: BlocBuilder<ChatPageBloc, ChatPageState>(
          builder: (context, state) {
            return Container(
                child: Column(children: [
              Expanded(
                flex: 1,
                child: Container(
                  //列表内容少的时候靠上
                  alignment: Alignment.topCenter,
                  child: ChatListWidget(
                    scrollController: _scrollController,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x14000000),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(15, 10, 0, 10),
                        constraints: BoxConstraints(
                          maxHeight: 100.0,
                          minHeight: 50.0,
                        ),
                        decoration: BoxDecoration(
                            color: Color(0xFFF5F6FF),
                            borderRadius: BorderRadius.all(Radius.circular(2))),
                        child: TextField(
                          controller: textEditingController,
                          cursorColor: Color(0xFF464EB5),
                          maxLines: null,
                          maxLength: 200,
                          decoration: InputDecoration(
                            counterText: '',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(
                                left: 16.0,
                                right: 16.0,
                                top: 10.0,
                                bottom: 10.0),
                            hintText: "点此提问或者寻找客服",
                            hintStyle: TextStyle(
                                color: Color(0xFFADB3BA), fontSize: 15),
                          ),
                          style:
                              TextStyle(color: Color(0xFF03073C), fontSize: 15),
                        ),
                      ),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                        alignment: Alignment.center,
                        height: 70,
                        child: Text(
                          '发送',
                          style: TextStyle(
                            color: Color(0xFF464EB5),
                            fontSize: 14,
                          ),
                        ),
                      ),
                      onTap: () async {
                        if (textEditingController.text != "") {
                          AskQuestion askQuestion = AskQuestion();
                          String url = "http://192.168.50.99:9001/question/ask";
                          askQuestion.question = textEditingController.text;
                          Map jsonStr = askQuestion.toJson();
                          Response? response =
                              await dioUtil.post(url, data: jsonStr);
                          if (null != response) {
                            var result = response.data;
                            List data = result['data'];
                            List<Data> questions =
                                data.map((e) => new Data.fromJson(e)).toList();

                            Future.delayed(Duration(milliseconds: 1))
                                .then((value) {
                              _chatPageBloc.add(AddChatMessageEvent(
                                widget: BaseQuestionWidget(
                                    text: textEditingController.text),
                              ));
                              textEditingController.text = "";
                            }).then((value) {
                              Future.delayed(Duration(milliseconds: 100))
                                  .then((value) {
                                _scrollController.jumpTo(
                                    _scrollController.position.maxScrollExtent);
                              });
                            }).then((value) {
                              Future.delayed(Duration(milliseconds: 1000))
                                  .then((value) {
                                _chatPageBloc.add(AddChatMessageEvent(
                                  widget: BaseAnswerWidget(
                                    text: null,
                                  ),
                                ));
                              }).then((value) {
                                Future.delayed(Duration(milliseconds: 100))
                                    .then((value) {
                                  _scrollController.jumpTo(_scrollController
                                      .position.maxScrollExtent);
                                }).then((value) {
                                  Future.delayed(Duration(milliseconds: 1000))
                                      .then((value) {
                                    _chatPageBloc.add(ReplaceChatMessageEvent(
                                        widget: CustomerAskWidget(
                                      dataList: questions,
                                    )));
                                  }).then((value) {
                                    Future.delayed(Duration(milliseconds: 100))
                                        .then((value) {
                                      _scrollController.jumpTo(_scrollController
                                          .position.maxScrollExtent);
                                    });
                                  });
                                });
                              });
                            });
                          }
                        }
                      },
                    ),
                  ],
                ),
              )
            ]));
          },
        ));
  }
}

class CustomChatPageV2 extends StatelessWidget {
  const CustomChatPageV2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatPageBloc()..add(InitChatPageEvent()),
      child: CustomChatPage(),
    );
  }
}

class BaseQuestionWidget extends StatelessWidget {
  const BaseQuestionWidget({Key? key, required this.text}) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      child: Container(
        color: Colors.blueAccent,
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.only(right: paddingSize, top: 20, left: paddingSize),
        child: Text(text),
      ),
    );
  }
}

class BaseAnswerWidget extends StatelessWidget {
  const BaseAnswerWidget({Key? key, required this.text}) : super(key: key);
  final String? text;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Container(
        color: Colors.grey[200],
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.only(right: paddingSize, top: 20, left: paddingSize),
        child: Text(text ?? "正在输入..."),
      ),
    );
  }
}

class ProposalWidget extends StatelessWidget {
  const ProposalWidget({Key? key, required this.customResponseModel})
      : super(key: key);
  final CustomResponseModel customResponseModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Card(
        child: Column(
          children: [Text(customResponseModel.answer ?? "")],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class CustomerAskWidget extends StatefulWidget {
  CustomerAskWidget({Key? key, required this.dataList}) : super(key: key);
  List<Data>? dataList;

  @override
  _CustomerAskWidgetState createState() => _CustomerAskWidgetState();
}

class _CustomerAskWidgetState extends State<CustomerAskWidget> {
  late List<Widget> ans;

  Widget humanHelp = Container(
    alignment: Alignment.bottomRight,
    margin: EdgeInsets.only(
        top: paddingSize, right: paddingSize, bottom: 0.5 * paddingSize),
    child: InkWell(
      onTap: () {
        Fluttertoast.showToast(msg: "这里跳转客服页面");
      },
      child: Text("没找到想要的结果？点此人工客服帮助"),
    ),
  );

  @override
  void initState() {
    super.initState();
    if (null != widget.dataList) {
      ans = CustomResponseModel.renderQuestion(context, widget.dataList!);
      ans.add(humanHelp);
    } else {
      ans = [];
      ans.add(humanHelp);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(paddingSize),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(paddingSize),
            alignment: Alignment.centerLeft,
            child: Text(
              "相似的问题",
              style: TextStyle(color: Colors.greenAccent, fontSize: 20),
            ),
          ),
          Divider(),
          Column(
            children: ans,
          )
        ],
      ),
    );
  }
}
