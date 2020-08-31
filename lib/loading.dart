import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: AlertDialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          contentPadding: EdgeInsets.all(0.0),
          shape: RoundedRectangleBorder(
              side: BorderSide(
                style: BorderStyle.none,
              ),
              borderRadius: BorderRadius.circular(15)),
          content: Center(
            child: CircularProgressIndicator(
              backgroundColor: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}

class LoadingOverlay {
  OverlayEntry _loadingOverlayEntry;

  void show(BuildContext context) {
    _loadingOverlayEntry = _createdLoadingEntry(context);
    Overlay.of(context).insert(_loadingOverlayEntry);
  }

  void hide() {
    if (_loadingOverlayEntry != null) {
      _loadingOverlayEntry.remove();
      _loadingOverlayEntry = null;
    }
  }

  OverlayEntry _createdLoadingEntry(BuildContext context) {
    return OverlayEntry(
      builder: (BuildContext context) => Stack(
        children: <Widget>[
          Loading(),
        ],
      ),
    );
  }
}
