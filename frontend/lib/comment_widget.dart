import 'package:flutter/material.dart';
import 'package:zhixiaoxia_extra/utils.dart';

class CommentWidget extends StatefulWidget {
  CommentWidget({Key? key}) : super(key: key);

  @override
  CommentWidgetState createState() => CommentWidgetState();
}

class CommentWidgetState extends State<CommentWidget> {
  late int stars;

  @override
  void initState() {
    super.initState();
    stars = 5;
  }

  void changeStars(int s) {
    setState(() {
      this.stars = s;
    });
  }

  @override
  Widget build(BuildContext context) {
    // print(this.stars);
    TextStyle errorStyle = TextStyle(fontSize: 20, color: Colors.blue);
    if (this.stars == 5 || this.stars == 4) {
      return Container();
    } else if (this.stars >= 2 && this.stars < 4) {
      // print("class2");
      return Card(
        margin: EdgeInsets.all(paddingSize * 0.5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.all(paddingSize * 0.5),
              alignment: Alignment.centerLeft,
              child: Text(
                "请问以下内容哪些不那么尽如人意？",
                style: errorStyle,
              ),
            ),
            Container(
              child: Column(
                children: [
                  SubCommentWidget(
                    name: "功能模块1",
                  ),
                  SubCommentWidget(
                    name: "功能模块2",
                  ),
                  SubCommentWidget(
                    name: "功能模块3",
                  ),
                  SubCommentWidget(
                    name: "功能模块4",
                  ),
                  SubCommentWidget(
                    name: "功能模块5",
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return Card(
        margin: EdgeInsets.all(paddingSize * 0.5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.all(0.5 * paddingSize),
              alignment: Alignment.centerLeft,
              child: Text(
                "请简要说明哪些功能操作不便？",
                style: errorStyle,
              ),
            ),
            Container(
              margin: EdgeInsets.all(0.5 * paddingSize),
              // width: 0.85 * CommonUtils.screenW(),
              alignment: Alignment.center,
              // height: 300,
              child: TextField(
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "请在这里输入你的意见或者建议，如果采纳的话我们会给与相应的奖励。"),
                keyboardType: TextInputType.multiline,
                maxLines: 10,
                maxLength: 300,
              ),
            )
          ],
        ),
      );
    }
  }
}

class SubCommentWidget extends StatefulWidget {
  SubCommentWidget({Key? key, required this.name}) : super(key: key);
  final String name;

  @override
  SubCommentWidgetState createState() => SubCommentWidgetState();
}

class SubCommentWidgetState extends State<SubCommentWidget> {
  late bool vis;

  @override
  void initState() {
    super.initState();
    vis = false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                this.vis = !vis;
              });
            },
            child: Container(
              margin: EdgeInsets.all(paddingSize * 0.5),
              alignment: Alignment.centerLeft,
              child: Text(widget.name),
            ),
          ),
          Visibility(
              visible: this.vis,
              child: Container(
                margin: EdgeInsets.all(paddingSize * 0.5),
                child: TextField(
                  decoration: InputDecoration(hintText: "请简述原因"),
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                  maxLength: 100,
                ),
              ))
        ],
      ),
    );
  }
}
