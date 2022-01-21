import 'package:flutter/material.dart';

class EmojiWidget extends StatefulWidget {
  EmojiWidget({Key? key}) : super(key: key);

  @override
  EmojiWidgetState createState() => EmojiWidgetState();
}

class EmojiWidgetState extends State<EmojiWidget> {
  late Map<int, String> pathMap = Map();
  late Map<int, String> satisfiedStr = Map();
  late int currentIndex;

  void changeEmoji(int index) {
    setState(() {
      this.currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    pathMap[0] = "assets/images/faces/0.png";
    pathMap[1] = "assets/images/faces/1.png";
    pathMap[2] = "assets/images/faces/2.png";
    pathMap[3] = "assets/images/faces/3.png";
    pathMap[4] = "assets/images/faces/4.png";
    currentIndex = 4;
    satisfiedStr[0] = "十分不满意";
    satisfiedStr[1] = "不满意";
    satisfiedStr[2] = "一般";
    satisfiedStr[3] = "满意";
    satisfiedStr[4] = "十分满意";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          // alignment: Alignment.centerRight,
          height: 30,
          width: 30,
          child: Image.asset(
            pathMap[currentIndex] ?? "assets/images/faces/4.png",
            fit: BoxFit.fill,
          ),
        ),
        Container(
          // alignment: Alignment.centerRight,
          margin: EdgeInsets.only(top: 10),
          child: Text(satisfiedStr[currentIndex] ?? "十分满意"),
        ),
      ],
    );
  }
}

class EmojiRelatedInfoWidget extends StatefulWidget {
  EmojiRelatedInfoWidget({Key? key}) : super(key: key);

  @override
  EmojiRelatedInfoWidgetState createState() => EmojiRelatedInfoWidgetState();
}

class EmojiRelatedInfoWidgetState extends State<EmojiRelatedInfoWidget> {
  late Map<int, String> satisfiedStr = Map();
  late int currentIndex;
  @override
  void initState() {
    super.initState();
    currentIndex = 4;
    satisfiedStr[0] = "十分不满意";
    satisfiedStr[1] = "不满意";
    satisfiedStr[2] = "一般";
    satisfiedStr[3] = "满意";
    satisfiedStr[4] = "十分满意";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(satisfiedStr[currentIndex] ?? satisfiedStr[4]!),
    );
  }
}
