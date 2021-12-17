import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paitent/core/models/ChatApiResponse.dart';
import 'package:paitent/core/models/FAQChatModelPojo.dart';
import 'package:paitent/core/models/user_data.dart';
import 'package:paitent/core/viewmodels/views/bot_view_model.dart';
import 'package:paitent/networking/CustomException.dart';
import 'package:paitent/ui/shared/app_colors.dart';
import 'package:paitent/utils/CommonUtils.dart';
import 'package:paitent/utils/SharedPrefUtils.dart';
import 'package:paitent/utils/TimeAgo.dart';

import '../base_widget.dart';


class FAQChatScreen extends StatefulWidget {
  @override
  FAQChatScreenState createState() {
    return FAQChatScreenState();
  }
}

class FAQChatScreenState extends State<FAQChatScreen> {
  var model = BotViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController =
      ScrollController(initialScrollOffset: 50.0);
  final _chatController = TextEditingController();
  final _chatFocus = FocusNode();

  var chatBoxWidth = 0.0;
  final SharedPrefUtils _sharedPrefUtils = SharedPrefUtils();
  String phoneNumber = '';

  Timer timer;

  loadSharedPrefs() async {
    try {
      final UserData user =
          UserData.fromJson(await _sharedPrefUtils.read('user'));
      phoneNumber = user.data.user.person.phone;

      /* */
      setState(() {
        //debugPrint('Gender ==> ${patient.gender.toString()}');
      });
      timer =
          Timer.periodic(Duration(seconds: 30), (Timer t) => setState(() {}));
    } catch (Excepetion) {
      // do something
      debugPrint(Excepetion);
    }
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    loadSharedPrefs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    chatBoxWidth = MediaQuery.of(context).size.width - 100;
    return BaseWidget<BotViewModel>(
      model: model,
      builder: (context, model, child) => Container(
        child: Scaffold(
          key: _scaffoldKey,
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.white,
            brightness: Brightness.light,
            title: Text(
              'Support',
              style: TextStyle(
                  fontSize: 16.0,
                  color: primaryColor,
                  fontWeight: FontWeight.w700),
            ),
            iconTheme: IconThemeData(color: Colors.black),
            actions: <Widget>[
              /*IconButton(
                icon: Icon(
                  Icons.person_pin,
                  color: Colors.black,
                  size: 32.0,
                ),
                onPressed: () {
                  debugPrint("Clicked on profile icon");
                },
              )*/
                ],
              ),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              chatList.isEmpty
                  ? Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ImageIcon(
                              AssetImage('res/images/ic_chat_bot.png'),
                              size: 64,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Type your question below',
                              style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    )
                  : listWidget(),
              Container(
                constraints: BoxConstraints(maxHeight: 100),
                padding: const EdgeInsets.all(8.0),
                width: MediaQuery.of(context).size.width,
                color: Colors.black12,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            reverse: true,
                            child: Theme(
                              data: ThemeData(
                            primaryColor: Colors.white,
                            primaryColorDark: Colors.white,
                          ),
                              child: TextFormField(
                                  controller: _chatController,
                                  focusNode: _chatFocus,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  decoration: InputDecoration(
                                      isDense: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  filled: true,
                                  hintStyle: TextStyle(color: Colors.black38),
                                  hintText: 'Type your question',
                                  fillColor: Colors.white)),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    IconButton(
                        icon: Icon(
                          Icons.send,
                          color: primaryColor,
                          size: 32,
                          semanticLabel: 'Send',
                        ),
                        onPressed: () {
                          if (_chatController.text.isNotEmpty) {
                            sendMessageBotApi(_chatController.text);
                            final chatMsg = FAQChatModelPojo(
                                _chatController.text, DateTime.now(), 'ME');
                            _chatController.clear();
                            chatList.insert(0, chatMsg);
                            /* var chatMsgReceive = new FAQChatModelPojo(
                              'Text msg ' + chatList.length.toString(),
                              new DateTime.now(),
                              'BOT');
                          chatList.insert(0, chatMsgReceive);*/
                            setState(() {
                              _scrollController.animateTo(00,
                                  duration: Duration(milliseconds: 200),
                                  curve: Curves.easeInOut);
                            });
                          }
                        }),
                  ],
                    ),
                  )
                ],
              ),
            ),
          ),
    );
  }

  Widget listWidget() {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.separated(
            itemBuilder: (context, index) => _createMsgContect(context, index),
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(
                height: 8,
              );
            },
            reverse: true,
            controller: _scrollController,
            itemCount: chatList.length,
            scrollDirection: Axis.vertical,
            shrinkWrap: true),
      ),
    );
  }

  _createMsgContect(BuildContext context, int index) {
    final chatMsg = chatList.elementAt(index);

    return chatMsg.sender == 'ME'
        ? _myChatMsg(chatMsg)
        : _senderChatMsg(chatMsg);
  }

  _myChatMsg(FAQChatModelPojo chatModelPojo) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(
              left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
          constraints: BoxConstraints(maxWidth: chatBoxWidth, minWidth: 100),
          decoration: BoxDecoration(
              color: getAppType() == 'AHA'
                  ? Colors.red.shade200
                  : primaryLightColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  bottomLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                chatModelPojo.text,
                style: TextStyle(fontSize: 14, color: textBlack),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                TimeAgo.timeAgoSinceByDate(chatModelPojo.timeStamp),
                style: TextStyle(fontSize: 10, color: textBlack),
              ),
            ],
          ),
        ),
      ],
    );
  }

  _senderChatMsg(FAQChatModelPojo chatModelPojo) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(
              left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
          constraints: BoxConstraints(maxWidth: chatBoxWidth, minWidth: 100),
          decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  bottomLeft: Radius.circular(0.0),
                  topRight: Radius.circular(16.0),
                  bottomRight: Radius.circular(16))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                chatModelPojo.text,
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
              SizedBox(
                height: 4,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  TimeAgo.timeAgoSinceByDate(chatModelPojo.timeStamp),
                  style: TextStyle(fontSize: 10, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  sendMessageBotApi(String msg) async {
    try {
      final map = <String, String>{};
      map['phoneNumber'] = phoneNumber;
      map['type'] = 'text';
      map['message'] = msg;

      final ChatApiResponse baseResponse = await model.sendMsgApi(map);
      debugPrint('Base Response ==> ${baseResponse.toJson()}');
      if (baseResponse.success) {
        final chatMsgReceive = FAQChatModelPojo(
            baseResponse.data.responseMessage, DateTime.now(), 'BOT');
        chatList.insert(0, chatMsgReceive);

        setState(() {
          _scrollController.animateTo(00,
              duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
        });
      } else {
        //showToast(knowledgeTopicResponse.message);
      }
    } on FetchDataException catch (e) {
      debugPrint('error caught: $e');
      model.setBusy(false);
      showToast(e.toString(), context);
    }
    /* catch (CustomException) {
      model.setBusy(false);
      showToast(CustomException.toString(), context);
      debugPrint('Error ' + CustomException.toString());
    }*/
  }
}
