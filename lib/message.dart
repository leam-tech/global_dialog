import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class MessageDialog extends StatelessWidget {
  final String? title;
  final dynamic content;
  final dynamic button;
  final bool dismissible;
  final bool hasBlurBackground;

  MessageDialog(this.title, this.content, this.button, this.dismissible,
      this.hasBlurBackground);

  @override
  Widget build(BuildContext context) {
    final child = AlertDialog(
      backgroundColor: Colors.white,
      contentPadding: EdgeInsets.all(0.0),
      shape: RoundedRectangleBorder(
          side: BorderSide(
            style: BorderStyle.none,
          ),
          borderRadius: BorderRadius.circular(15)),
      title: Text(
        title!,
        style: Theme.of(context).textTheme.subtitle1,
      ),
      content: content is Widget
          ? content
          : content is String
              ? Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    content,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                )
              : Container(),
      actions: [
        button is Widget
            ? button
            : TextButton(
                child: Text(
                  button is String ? button : 'Ok',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
      ],
    );
    return WillPopScope(
      onWillPop: () => Future.value(dismissible),
      child: hasBlurBackground
          ? ClipRect(
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: child,
              ),
            )
          : child,
    );
  }
}
