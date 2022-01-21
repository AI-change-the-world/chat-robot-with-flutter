import 'package:flutter/material.dart';
import 'package:zhixiaoxia_extra/custom_chat_page.dart';
import 'package:zhixiaoxia_extra/custom_rating_service_widget.dart';
import 'package:zhixiaoxia_extra/custom_service_main_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: CustomRatingService(),
      home: CustomChatPageV2(),
    );
  }
}
