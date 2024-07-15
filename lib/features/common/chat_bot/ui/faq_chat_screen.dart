import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:patient/features/common/chat_bot/models/chat_api_response.dart';
import 'package:patient/features/common/chat_bot/models/faq_chat_model_pojo.dart';
import 'package:patient/features/common/chat_bot/view_models/bot_view_model.dart';
import 'package:patient/features/misc/models/user_data.dart';
import 'package:patient/infra/networking/custom_exception.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:patient/infra/utils/common_utils.dart';
import 'package:patient/infra/utils/shared_prefUtils.dart';
import 'package:patient/infra/utils/time_ago.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../misc/ui/base_widget.dart';

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
  String? phoneNumber = '';

  late Timer timer;

  loadSharedPrefs() async {
    try {
      final UserData user =
          UserData.fromJson(await _sharedPrefUtils.read('user'));
      phoneNumber = user.data!.user!.person!.phone;

      /* */
      setState(() {
        //debugPrint('Gender ==> ${patient.gender.toString()}');
      });
      timer =
          Timer.periodic(Duration(seconds: 30), (Timer t) => setState(() {}));
    } catch (Excepetion) {
      // do something
      debugPrint(Excepetion.toString());
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
    return BaseWidget<BotViewModel?>(
      model: model,
      builder: (context, model, child) => Container(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.light),
            title: Text(
              'Support',
              style: TextStyle(
                  fontSize: 16.0,
                  color: primaryColor,
                  fontWeight: FontWeight.w600),
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
                                  fontWeight: FontWeight.w600),
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
                          if (_chatController.text.trim().isNotEmpty) {
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
                          } else {
                            _chatController.clear();
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
              Linkify(
                onOpen: (link) async {
                  if (await canLaunchUrl(Uri.parse(link.url))) {
                    await launchUrl(Uri.parse(link.url));
                  } else {
                    throw 'Could not launch $link';
                  }
                },
                softWrap: true,
                options: LinkifyOptions(humanize: false, looseUrl:true ),
                text: chatModelPojo.text.toString(),
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontFamily: 'Montserrat'),
                linkStyle: TextStyle(color: Colors.lightBlueAccent),
              ),
              /*Text(
                chatModelPojo.text!,
                style: TextStyle(fontSize: 14, color: textBlack),
              ),*/
              /*LinkText(
                chatModelPojo.text!,
                textStyle: TextStyle(fontSize: 14, color: textBlack,
                  fontWeight: FontWeight.w500,),
                linkStyle: TextStyle(color: Colors.lightBlueAccent, decoration: TextDecoration.underline, fontSize: 14,
                  fontWeight: FontWeight.w500,),
              ),*/
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
    announceText();
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
              Linkify(
                onOpen: (link) async {
                  if (await canLaunchUrl(Uri.parse(link.url))) {
                    await launchUrl(Uri.parse(link.url));
                  } else {
                    throw 'Could not launch $link';
                  }
                },
                softWrap: true,
                options: LinkifyOptions(humanize: false, looseUrl:true ),
                text: chatModelPojo.text.toString(),
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontFamily: 'Montserrat'),
                linkStyle: TextStyle(color: Colors.lightBlueAccent),
              ),
              /*Text(
                chatModelPojo.text!,
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),*/
             /* LinkText(
                chatModelPojo.text!,

                textStyle: TextStyle(fontSize: 14, color: Colors.white,
                  fontWeight: FontWeight.w500,),
                linkStyle: TextStyle(color: Colors.lightBlueAccent, decoration: TextDecoration.underline, fontSize: 14,
                  fontWeight: FontWeight.w500,),
              ),*/
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

  announceText() {
    if (!chatList.elementAt(0).hasAnnounced) {
      SemanticsService.announce(chatList.elementAt(0).text!, TextDirection.ltr);
      chatList.elementAt(0).hasAnnounced = true;
    }
  }

  sendMessageBotApi(String msg) async {
    try {
      final map = <String, String?>{};
      map['phoneNumber'] = phoneNumber;
      map['type'] = 'text';
      map['message'] = msg.trim();

      final ChatApiResponse baseResponse = await model.sendMsgApi(map);
      debugPrint('Base Response ==> ${baseResponse.toJson()}');
      if (baseResponse.success!) {
        final chatMsgReceive = FAQChatModelPojo(
            baseResponse.data!.responseMessage, DateTime.now(), 'BOT');
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
