import 'package:flutter/material.dart';
import 'package:zhixiaoxia_extra/comment_widget.dart';
import 'package:zhixiaoxia_extra/emoji_widget.dart';
import 'package:zhixiaoxia_extra/rating_widget.dart';

class CustomRatingService extends StatefulWidget {
  CustomRatingService({Key? key}) : super(key: key);

  @override
  _CustomRatingServiceState createState() => _CustomRatingServiceState();
}

class _CustomRatingServiceState extends State<CustomRatingService> {
  GlobalKey<EmojiWidgetState> emojiKey = GlobalKey();
  GlobalKey<CommentWidgetState> commentKey = GlobalKey();

  bool visibility = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: ListTile(
                  title: Container(
                    margin: EdgeInsets.only(bottom: 20),
                    child: Text("非常感谢使用本产品"),
                  ),
                  subtitle: Container(
                    child: Text("你对XXX的服务满意吗？"),
                  ),
                  trailing: EmojiWidget(
                    key: emojiKey,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Rating(
                  size: 30,
                  initialRating: 5,
                  onRated: (i) {
                    // print(i);
                    if (i == 0 || i == 1) {
                      emojiKey.currentState!.changeEmoji(0);
                      commentKey.currentState!.changeStars(1);
                    } else {
                      emojiKey.currentState!.changeEmoji(i - 1);
                      commentKey.currentState!.changeStars(i);
                    }

                    setState(() {
                      // print(visibility);
                      visibility = i != 5;
                      // print(visibility);
                    });
                  },
                ),
              ),
              Visibility(
                  visible: visibility,
                  // maintainAnimation: false,
                  // maintainSize: false,
                  maintainState: true,
                  // maintainInteractivity: false,
                  child: CommentWidget(
                    key: commentKey,
                  )),
              Container(
                child: ElevatedButton(
                  child: Text("感谢你的反馈"),
                  onPressed: () {
                    print("。");
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
