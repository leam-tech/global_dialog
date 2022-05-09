import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class PromptDialog extends StatelessWidget {
  final String? title;
  final dynamic content;
  final List<Widget>? actions;
  final bool dismissible;
  final bool hasBlurBackground;

  PromptDialog(this.title, this.content, this.actions, this.dismissible,
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
      // Prompt user asking, with actions and such
      title: Text(title!),
      content: content is Widget
          ? content
          : content is String
              ? Padding(padding: EdgeInsets.all(24), child: Text(content))
              : Container(),
      actions: actions,
    );
    return WillPopScope(
      onWillPop: () => Future.value(dismissible),
      child: hasBlurBackground
          ? ClipRect(
              child: BackdropFilter(
                  filter: ui.ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: child),
            )
          : child,
    );
  }
}
