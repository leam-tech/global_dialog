import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class DialogContainer extends StatelessWidget {
  final ThemeData theme;
  final Builder? builder;
  final Widget? child;

  DialogContainer(this.theme, {this.builder, this.child, Key? key})
      : assert(child != null || builder != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (child != null) {
      return ClipRect(
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Builder(
            builder: (BuildContext context) {
              return Theme(data: theme, child: child!);
            },
          ),
        ),
      );
    }
    if (builder != null) {
      return builder!;
    }
    return Container(
      child: Text('Please provide child or builder'),
    );
  }
}
