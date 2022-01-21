import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zhixiaoxia_extra/dioutils.dart';
import 'package:zhixiaoxia_extra/question_model.dart';
// import 'package:zhixiaoxia_extra/rating_widget.dart';

class CustomResponseModel {
  String? question;
  String? answer;
  bool? showNewPage;
  int id;
  bool isPrimary;
  void Function()? onTap;

  CustomResponseModel(
      {this.question,
      this.answer,
      this.showNewPage,
      required this.isPrimary,
      required this.id,
      required this.onTap});

  static List<String> get questions => [
        "工资条怎么查看",
        "什么时候发工资",
        "授权出现问题怎么解决",
        "怎么绑定用工单位",
        "我要去哪里打卡",
        "实名出现问题怎么解决",
        "发工资会有提示吗"
      ];

  static List<CustomResponseModel> getReservedResponse() {
    List<CustomResponseModel> reservedResponses = [];
    reservedResponses.add(CustomResponseModel(
        isPrimary: false,
        onTap: null,
        id: 0,
        question: "工资条怎么查看",
        answer: "进入羚活云人事小程序，点击左下收入栏目后查看，记得要关注羚活公众号哦",
        showNewPage: false));

    reservedResponses.add(CustomResponseModel(
        isPrimary: false,
        onTap: null,
        id: 1,
        question: "什么时候发工资",
        answer: "以合同约定的发放收入时间为准，如果是日结用户，尾薪在合同时间最后补齐",
        showNewPage: false));

    reservedResponses.add(CustomResponseModel(
        isPrimary: false,
        onTap: null,
        id: 2,
        question: "授权出现问题怎么解决",
        answer: "可以用截图、视频等方式存证，并发给我们。我们帮忙解决",
        showNewPage: false));

    reservedResponses.add(CustomResponseModel(
        isPrimary: false,
        onTap: null,
        id: 3,
        question: "怎么绑定用工单位",
        answer:
            "用户不能手动绑定用工单位。注册小程序成功后、关注羚活公众号 然后再小程序或服务号留言。姓名+时间+用工单位。我们会帮你绑定用工单位",
        showNewPage: false));
    reservedResponses.add(CustomResponseModel(
        isPrimary: false,
        onTap: null,
        id: 4,
        question: "我要去哪里打卡",
        answer: "打卡拍的为驻场指定的物件照片",
        showNewPage: false));

    reservedResponses.add(CustomResponseModel(
        isPrimary: false,
        onTap: null,
        id: 5,
        question: "实名出现问题怎么解决",
        answer: "实名出现问题可能是当前访问人数过高，等1-2分钟或者过段时间再试，如果之后还不行可以把截图发给我们",
        showNewPage: false));

    reservedResponses.add(CustomResponseModel(
        isPrimary: false,
        onTap: null,
        id: 6,
        question: "发工资会有提示吗",
        answer: "在微信零钱中会有提示、在羚活 小程序中也有记录",
        showNewPage: false));

    return reservedResponses;
  }

  static Widget getQuestionWidget(
      CustomResponseModel model, BuildContext context, int length) {
    return Container(
        decoration: model.id == length - 1
            ? null
            : BoxDecoration(
                border: Border(
                bottom: BorderSide(width: 1, color: Colors.grey[200]!),
              )),
        child: ListTile(
            // title: model.isPrimary ? Text("你是不是想问?") : null,
            title: model.isPrimary
                ? Row(
                    children: [
                      Text(model.question ?? ""),
                      Text(
                        "(最接近)",
                        style: TextStyle(color: Colors.red),
                      )
                    ],
                  )
                : Text(model.question ?? ""),
            trailing: Icon(
              Icons.chevron_right,
              color: Colors.grey[200],
            ),
            onTap: model.onTap ??
                () async {
                  if (!model.showNewPage!) {
                    await showCupertinoDialog(
                        context: context,
                        builder: (context) {
                          return CupertinoAlertDialog(
                            content: Column(
                              children: [
                                Container(
                                  child: Text(
                                    model.answer ?? "",
                                    maxLines: 10,
                                  ),
                                ),
                              ],
                            ),
                            actions: [
                              CupertinoActionSheetAction(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("确定"))
                            ],
                          );
                        });
                  }
                }));
  }

  static List<Widget> getAll(BuildContext context, {String condition = ""}) {
    List<CustomResponseModel> ls = getReservedResponse();
    List<Widget> lw = [];
    int id = 0;
    for (var i in ls) {
      i.id = id;
      id += 1;
      if (i.question!.contains(condition)) {
        lw.add(getQuestionWidget(i, context, lw.length));
      }
    }
    return lw;
  }

  static List<Widget> renderQuestion(
      BuildContext context, List<Data> questions) {
    List<CustomResponseModel> reservedResponses = [];
    for (var q in questions) {
      reservedResponses.add(CustomResponseModel(
          isPrimary: q.isPrimary!,
          id: q.qid!,
          onTap: null,
          question: q.comment,
          answer: q.answer,
          showNewPage: false));
    }
    List<Widget> lw = [];
    for (var i in reservedResponses) {
      if (i.isPrimary) {
        lw.insert(0, getQuestionWidget(i, context, lw.length));
      } else {
        lw.add(getQuestionWidget(i, context, lw.length));
      }
    }
    return lw;
  }
}

class AnswerWidget extends StatefulWidget {
  AnswerWidget({Key? key}) : super(key: key);

  @override
  AnswerWidgetState createState() => AnswerWidgetState();
}

class AnswerWidgetState extends State<AnswerWidget> {
  List<CustomResponseModel> ls = CustomResponseModel.getReservedResponse();
  late List<Widget> ans;

  DioUtil dioUtil = DioUtil();
  var _future;

  @override
  void initState() {
    super.initState();
    // ans = CustomResponseModel.getAll(context);
    _future = getHotQuestions();
  }

  void grep(String s) {
    setState(() {
      if (s != "") {
        ans = CustomResponseModel.getAll(context, condition: s);
      } else {
        ans = CustomResponseModel.getAll(context);
      }
    });
  }

  Future<List<Data>?> getHotQuestions() async {
    String url = "http://192.168.50.99:9001/question/hot";

    Response? response = await dioUtil.get(url);
    if (null != response) {
      var result = response.data;
      List data = result['data'];
      List<Data> questions = data.map((e) => new Data.fromJson(e)).toList();
      return questions;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _future,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (!snapshot.hasError) {
              ans = CustomResponseModel.renderQuestion(
                  context, snapshot.data as List<Data>);
              return Column(
                children: ans,
              );
            } else {
              return SizedBox(
                height: 150,
                child: Center(
                  child: Text("查询失败"),
                ),
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
