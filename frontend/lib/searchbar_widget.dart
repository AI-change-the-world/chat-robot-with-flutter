import 'package:flutter/material.dart';
import 'package:zhixiaoxia_extra/custom_response_model.dart';
import 'package:zhixiaoxia_extra/utils.dart';

class SearchBar extends StatefulWidget {
  SearchBar({Key? key, required this.height, required this.answerKey})
      : super(key: key);
  final double height;
  final GlobalKey<AnswerWidgetState> answerKey;
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (_controller.text == "") {
        widget.answerKey.currentState!.grep("");
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: paddingSize, right: paddingSize),
      child: Container(
        height: widget.height,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.only(left: paddingSize),
              width: CommonUtils.screenW() * 0.5,
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintStyle: TextStyle(fontSize: 15),
                  contentPadding: EdgeInsets.only(top: 0, bottom: 0),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                  icon: Icon(
                    Icons.search,
                    size: 30,
                    color: Colors.grey,
                  ),
                  hintText: "搜索问题",
                ),
              ),
            ),
            Spacer(),
            Container(
              margin: EdgeInsets.only(right: 3),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.grey[200],
                ),
                onPressed: () {
                  print(_controller.text);
                  if (_controller.text != "") {
                    widget.answerKey.currentState!.grep(_controller.text);
                  }
                },
                child: Text(
                  "搜索",
                  style: TextStyle(color: Colors.blueAccent),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
