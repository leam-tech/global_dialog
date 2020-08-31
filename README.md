# Global Dialog

This is a simple package to get you started with dialog interactions from your business logic directly without having to create widgets of dialog multiple times.

To start using this package simply wrap your entire app globally like so:

``GlobalDialog(child: App());``

#### Loading

In order to display a simple loading animation call the `showLoading` like so:

``GlobalDialog.showLoading(context, loading: true);``

Once done with your business logic, you might need to call than

``GlobalDialog.showLoading(context, loading: false);``

#### Messages

In order to display messages to the user, a simple `showMessage` could be called for example;

```
  GlobalDialog.showMessage(
    context,
    button: 'Ok',
    content: 'Example content',
    title: 'Example Title',
    dismissible: true,
  );
```
Dart attribute | Description
------------ | -------------
button | Button to show on a message, depending upon the Type like widget or string the button will shown replacing the default or will replace the default string
title | Title of the message
content | Content of the message
dismissible | Whether to allow message to be dismissed

#### Prompt

In order to display a prompt to the user, a simple `showPromp` could be called for example;

```
  GlobalDialog.showPrompt(
    context,
    content: 'Example content',
    title: 'Example Title',
    dismissible: true,
    actions: [],
  );
```
Dart attribute | Description
------------ | -------------
title | Title of the prompt
content | Content of the prompt
dismissible | Whether to allow prompt to be dismissed
actions | List of Widgets to handle control over the prompt


#### Alternatively

if needed `GlobalDialog.dialog` could be called directly with generic set and builder to display within the dialog.

