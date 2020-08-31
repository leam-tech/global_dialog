import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class DialogContainer extends StatelessWidget {
  final ThemeData theme;
  final Builder child;

  DialogContainer(this.theme, this.child);

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Builder(
          builder: (BuildContext context) {
            return theme != null ? Theme(data: theme, child: child) : child;
          },
        ),
      ),
    );
  }
}
