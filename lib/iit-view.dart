import 'package:ChatBot/utils/const.dart';
import 'package:easy_web_view/easy_web_view.dart';
import 'package:flutter/material.dart';
class IITView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return EasyWebView(
      src: iitUrl,
    );
  }
}

