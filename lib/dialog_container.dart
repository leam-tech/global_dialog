import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class DialogContainer extends StatelessWidget {
  final ThemeData theme;
  final Builder child;
  final bool hasBlurBackground;

  DialogContainer(this.theme, this.child, this.hasBlurBackground);

  @override
  Widget build(BuildContext context) {
    return hasBlurBackground
        ? ClipRect(
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Builder(
                builder: (BuildContext context) {
                  return theme != null
                      ? Theme(data: theme, child: child)
                      : child;
                },
              ),
            ),
          )
        : child;
  }
}
