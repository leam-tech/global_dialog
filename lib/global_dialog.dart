library global_dialog;

import 'package:flutter/material.dart';

import 'dialog_container.dart';
import 'loading.dart';
import 'message.dart';
import 'prompt.dart';

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
      dismissible: dismissible,
      title: title,
      content: content,
      actions: actions,
    );
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
    final ThemeData theme = themeData ?? Theme.of(context);
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
  bool dismissible,
  String title,
  dynamic content,
  dynamic button,
});

typedef PromptFunction = Function(
  BuildContext context, {
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
