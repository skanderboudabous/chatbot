import 'dart:convert';

import 'package:ChatBot/utils/const.dart';
import 'package:ChatBot/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'chat_messages.dart';
import 'iit-view.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  HomeScreenState createState() => new HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  FocusNode inputNode=new FocusNode();
  final List<ChatMessages> messageList = <ChatMessages>[];
  final TextEditingController _textController = new TextEditingController();
  ScrollController _scrollController = new ScrollController();
  String localLanguage;

  Widget _queryInputWidget(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30))),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50), color: appColor),
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8),
          child: Row(
            children: <Widget>[
              Flexible(
                child: TextField(
                  focusNode: inputNode,
                  controller: _textController,
                  onSubmitted: submitQuery,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration.collapsed(
                      hintText: "Send a message",
                      hintStyle: TextStyle(color: Colors.white)),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                child: IconButton(
                    icon: Icon(
                      Icons.send,
                      color: Colors.lightGreenAccent,
                    ),
                    onPressed: () => submitQuery(_textController.text)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void agentResponse(String query) async {
    query = query.replaceAll("'", "_");
    _textController.clear();
    AuthGoogle authGoogle = await AuthGoogle(fileJson: jsonPath).build();
    Dialogflow dialogFlow =
        Dialogflow(authGoogle: authGoogle, language: localLanguage);
    AIResponse response = await dialogFlow.detectIntent(query);
    if (response.getMessage().contains("[web]")) {
      Navigator.of(context).push(new MaterialPageRoute(builder: (_) => new IITView()));
    } else {
      ChatMessages message = ChatMessages(
        text: response.getMessage() ??
            CardDialogflow(response.getListMessage()[0].title),
        name: "Flutter",
        type: false,
      );
      setState(() {
        messageList.insert(0, message);
      });
    }
  }

  void submitQuery(String text) {
    if (text != "") {

      _scrollController.animateTo(
        0.0,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
      _textController.clear();
      ChatMessages message = new ChatMessages(
        text: text,
        name: "User",
        type: true,
      );
      setState(() {
        messageList.insert(0, message);
        inputNode.unfocus();
      });
      agentResponse(text);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (!GetIt.I.isRegistered<HomeScreenState>())
      GetIt.I.registerSingleton<HomeScreenState>(this);
  }

  @override
  Widget build(BuildContext context) {
    Locale myLocale = Localizations.localeOf(context);
    localLanguage = myLocale.languageCode;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(TITLE, style: TextStyle(color: Colors.white)),
        backgroundColor: appColor,
        elevation: 0,
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        fit: StackFit.expand,
        children: <Widget>[
          new Image(
            image: new AssetImage("assets/login_back.jpg"),
            fit: BoxFit.cover,
            colorBlendMode: BlendMode.darken,
            color: Colors.black87,
          ),
          Column(children: <Widget>[
            new Flexible(
                child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(8.0),
              reverse: true,
              //To keep the latest messages at the bottom
              itemBuilder: (_, int index) => messageList[index],
              itemCount: messageList.length,
            )),
            _queryInputWidget(context),
          ]),
        ],
      ),
    );
  }
}
