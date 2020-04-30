import 'package:ChatBot/home_screen.dart';
import 'package:ChatBot/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ChatMessages extends StatelessWidget {
  ChatMessages({this.text, this.name, this.type});

  final String text;
  final String name;
  final bool type;

  List<Widget> botMessage(context) {
    return <Widget>[
      Container(
        margin: const EdgeInsets.only(right: 10.0),
        child: CircleAvatar(child: Padding(
          padding: const EdgeInsets.all(5),
          child: FlutterLogo(),
        ), backgroundColor: Colors.grey[200], radius: 20,),
      ),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
//            Text(this.name,
//                style: TextStyle(fontWeight: FontWeight.bold)),
            Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))
                ),
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: buildReponseWidget(text)
                )
            ),
          ],
        ),
      ),
    ];
  }

  Widget buildReponseWidget(String result) {
    if (result.contains("[choices]")) {
      result = result.substring(10);
      print(result.split("\n"));
      List<String> choices = result.split("\n");
      return Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.start,
        children: choices.map((e) =>
            GestureDetector(onTap: () {
              GetIt.I<HomeScreenState>().submitQuery(e);
            }, child: Chip(label: Text(e),))).toList(),);
    } else {
      return Text(result);
    }
  }

  List<Widget> userMessage(context) {
    return <Widget>[
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
//            Text(this.name, style: Theme.of(context).textTheme.subhead),
            Card(
                color: appColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(text, style: TextStyle(color: Colors.white),),
                )
            ),
          ],
        ),
      ),
      Container(
        margin: const EdgeInsets.only(left: 10.0),
        child: CircleAvatar(child: new Text(
          this.name[0], style: TextStyle(color: Colors.lightGreenAccent),),
          backgroundColor: appColor,
          radius: 20,),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: this.type ? userMessage(context) : botMessage(context),
      ),
    );
  }
}