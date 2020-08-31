library global_dialog;

import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class GlobalDialog extends StatefulWidget {
  static GlobalDialogData of(BuildContext context) {
    var globalDialogData =
        context.dependOnInheritedWidgetOfExactType<GlobalDialogData>();
    return globalDialogData;
  }

  static void showLoading(BuildContext context, {@required bool loading}) {
    GlobalDialog.of(context).showLoading(context, loading: loading);
  }

  static void showMessage(
    BuildContext context, {
    bool dismissible = true,
    String title = '',
    dynamic content = '',
    dynamic button,
  }) {
    GlobalDialog.of(context).showMessage(
      context,
      message: true,
      dismissible: dismissible,
      title: title,
      content: content,
      button: button,
    );
  }

  static void showPrompt(
    BuildContext context, {
    bool dismissible = false,
    String title = '',
    dynamic content = '',
    @required List<Widget> actions,
  }) {
    GlobalDialog.of(context).showPrompt(
      context,
      prompt: true,
      dismissible: dismissible,
      title: title,
      content: content,
      actions: actions,
  }

  const GlobalDialog({Key key, this.child}) : super(key: key);

  final Widget child;

  static Future<T> dialog<T>(
    BuildContext context, {
    bool generic = false,
    bool message = false,
    bool prompt = false,
    bool barrierDismissible = true,
    WidgetBuilder builder,
    Color backgroundColor,
    String title,
    dynamic content,
    dynamic button,
    List<Widget> actions,
    ThemeData themeData,
  }) {
    assert(debugCheckHasMaterialLocalizations(context));
    final ThemeData theme =
        themeData ?? Theme.of(context, shadowThemeOnly: true);
    return showGeneralDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: backgroundColor != null
          ? backgroundColor
          : Colors.black.withOpacity(0.01),
      transitionDuration: const Duration(milliseconds: 100),
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return Builder(builder: (ctx) {
          if (generic) {
            return DialogContainer(
              theme,
              Builder(
                builder: builder,
              ),
            );
          } else if (message) {
            return MessageDialog(
              title,
              content,
              button,
              barrierDismissible,
            );
          } else if (prompt) {
            return PromptDialog(
              title,
              content,
              actions,
              barrierDismissible,
            );
          } else {
            return Container();
          }
        });
      },
    );
  }

  @override
  _GlobalDialogState createState() => _GlobalDialogState();
}

class _GlobalDialogState extends State<GlobalDialog> {
  bool loading;
  bool message;
  bool prompt;

  LoadingOverlay loadingOverlay = LoadingOverlay();

  void showLoading(BuildContext context, {@required bool loading}) {
    if (this.loading != loading) {
      message = false;
      prompt = false;
      this.loading = loading;
      if (this.loading) loadingOverlay.show(context);
      if (!this.loading) {
        loadingOverlay.hide();
      }
    }
  }

  void showMessage(
    BuildContext context, {
    bool dismissible = true,
    String title = '',
    dynamic content = '',
    dynamic button,
  }) {
    loading = false;
    prompt = false;
    this.message = true;
    if (this.message) {
      GlobalDialog.dialog<void>(
        context,
        message: true,
        barrierDismissible: dismissible,
        title: title,
        content: content,
        button: button,
      );
    }
  }

  void showPrompt(
    BuildContext context, {
    bool dismissible = false,
    String title = '',
    dynamic content = '',
    @required List<Widget> actions,
  }) {
    loading = false;
    message = false;
    this.prompt = true;
    if (this.prompt) {
      GlobalDialog.dialog<void>(context,
          prompt: true,
          title: title,
          content: content,
          barrierDismissible: dismissible,
          actions: actions);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GlobalDialogData(
      child: widget.child,
      showLoading: showLoading,
      showMessage: showMessage,
      showPrompt: showPrompt,
    );
  }
}

typedef LoadingFunction = Function(BuildContext context, {bool loading});

typedef MessageFunction = Function(
  BuildContext context, {
  bool message,
  bool dismissible,
  String title,
  dynamic content,
  dynamic button,
});

typedef PromptFunction = Function(
  BuildContext context, {
  bool prompt,
  bool dismissible,
  String title,
  dynamic content,
  List<Widget> actions,
});

class GlobalDialogData extends InheritedWidget {
  final LoadingFunction showLoading;
  final MessageFunction showMessage;
  final PromptFunction showPrompt;

  GlobalDialogData({
    Key key,
    this.showLoading,
    this.showMessage,
    this.showPrompt,
    Widget child,
  }) : super(key: key, child: child);

  static GlobalDialogData of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<GlobalDialogData>();
  }

  @override
  bool updateShouldNotify(GlobalDialogData oldWidget) {
    return oldWidget.showLoading != showLoading ||
        oldWidget.showMessage != showMessage ||
        oldWidget.showPrompt != showPrompt;
  }
}

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

class LoadingDialog extends StatelessWidget {
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

class MessageDialog extends StatelessWidget {
  final String title;
  final dynamic content;
  final dynamic button;
  final bool dismissible;

  MessageDialog(this.title, this.content, this.button, this.dismissible);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(dismissible),
      child: ClipRect(
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: AlertDialog(
            backgroundColor: Colors.white,
            contentPadding: EdgeInsets.all(0.0),
            shape: RoundedRectangleBorder(
                side: BorderSide(
                  style: BorderStyle.none,
                ),
                borderRadius: BorderRadius.circular(15)),
            title: Text(
              title,
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
                  : FlatButton(
                      child: Text(
                        button is String ? button : 'Ok',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
            ],
          ),
        ),
      ),
    );
  }
}

class PromptDialog extends StatelessWidget {
  final String title;
  final dynamic content;
  final List<Widget> actions;
  final bool dismissible;

  PromptDialog(this.title, this.content, this.actions, this.dismissible);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(dismissible),
      child: ClipRect(
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: AlertDialog(
            backgroundColor: Colors.white,
            contentPadding: EdgeInsets.all(0.0),
            shape: RoundedRectangleBorder(
                side: BorderSide(
                  style: BorderStyle.none,
                ),
                borderRadius: BorderRadius.circular(15)),
            // Prompt user asking, with actions and such
            title: Text(title),
            content: content is Widget
                ? content
                : content is String
                    ? Padding(padding: EdgeInsets.all(24), child: Text(content))
                    : Container(),
            actions: actions,
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
          LoadingDialog(),
        ],
      ),
    );
  }
}
