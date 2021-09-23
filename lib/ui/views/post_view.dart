import 'package:flutter/material.dart';
import 'package:paitent/core/models/post.dart';
import 'package:paitent/ui/shared/app_colors.dart';
import 'package:paitent/ui/shared/text_styles.dart';
import 'package:paitent/ui/shared/ui_helpers.dart';

class PostView extends StatelessWidget {
  final Post post;

  const PostView({Key key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Semantics(
          label: post.title,
          readOnly: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              UIHelper.verticalSpaceLarge,
              Text(post.title, style: headerStyle),
              Text(
                '',
                style: TextStyle(fontSize: 9.0),
              ),
              UIHelper.verticalSpaceMedium,
              Text(post.body),
            ],
          ),
        ),
      ),
    );
  }
}
