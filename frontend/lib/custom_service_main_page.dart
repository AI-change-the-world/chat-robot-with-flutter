import 'package:flutter/material.dart';
import 'package:zhixiaoxia_extra/custom_response_model.dart';
import 'package:zhixiaoxia_extra/searchbar_widget.dart';
import 'package:zhixiaoxia_extra/utils.dart';

class CustomServiceMainPage extends StatefulWidget {
  CustomServiceMainPage({Key? key}) : super(key: key);

  @override
  _CustomServiceMainPageState createState() => _CustomServiceMainPageState();
}

class _CustomServiceMainPageState extends State<CustomServiceMainPage> {
  // final TextEditingController _controller = TextEditingController();

  GlobalKey<AnswerWidgetState> answerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(
        children: [
          Positioned(
              left: 0,
              top: 0,
              child: Container(
                color: Colors.blue,
                height: 200,
                width: CommonUtils.screenW(),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          top: 15, bottom: 20, left: paddingSize),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "我的客服",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                    ListTile(
                      leading: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            image: DecorationImage(
                                image: AssetImage("assets/images/icon.png"))),
                        width: 70,
                        height: 70,
                      ),
                      title: Container(
                        padding: EdgeInsets.only(bottom: 15),
                        child: Text(
                          "Hi，xxx",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                      ),
                      subtitle: Text(
                        "我是智能客服xxx",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SearchBar(
                      height: 40,
                      answerKey: answerKey,
                    ),
                  ],
                ),
              )),
          Positioned(
            left: 0,
            top: 190,
            child: Container(
                width: CommonUtils.screenW(),
                height: CommonUtils.screenH() - 180,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                            left: paddingSize, right: paddingSize),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: AnswerWidget(
                            key: answerKey,
                          ),
                        ),
                      ),
                      ElevatedButton(onPressed: () {}, child: Text("转到人工客服"))
                    ],
                  ),
                )),
          ),
        ],
      ),
    ));
  }
}
