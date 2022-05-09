import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  final bool hasBlurBackground;
  Loading(this.hasBlurBackground, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final child = AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      contentPadding: EdgeInsets.all(0.0),
      shape: RoundedRectangleBorder(
          side: BorderSide(
            style: BorderStyle.none,
          ),
          borderRadius: BorderRadius.circular(15)),
      content: Center(
        child: CircularProgressIndicator(),
      ),
    );
    return hasBlurBackground
        ? ClipRect(
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: child,
            ),
          )
        : child;
  }
}

class LoadingOverlay {
  LoadingOverlay({this.loadingUi, this.blockGestures, this.hasBlurBackground});

  final Widget? loadingUi;
  final bool? hasBlurBackground;

  OverlayEntry? _loadingOverlayEntry;
  final bool? blockGestures;

  void show(BuildContext context, {bool? isRootOverlay}) {
    _loadingOverlayEntry = _createdLoadingEntry(context);
    Overlay.of(context, rootOverlay: isRootOverlay ?? false)!
        .insert(_loadingOverlayEntry!);
  }

  void hide() {
    if (_loadingOverlayEntry != null) {
      _loadingOverlayEntry!.remove();
      _loadingOverlayEntry = null;
    }
  }

  OverlayEntry _createdLoadingEntry(BuildContext context) {
    return OverlayEntry(
      builder: (BuildContext context) => AbsorbPointer(
        absorbing: blockGestures ?? true,
        child: (loadingUi != null)
            ? loadingUi!
            : Loading(hasBlurBackground ?? true),
      ),
    );
  }
}
