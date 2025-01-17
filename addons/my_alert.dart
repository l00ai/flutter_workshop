// @author Christian Babin
// @version 2.1.0
// https://github.com/babincc/flutter_workshop/blob/master/addons/my_alert.dart

import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// This file allows for the creation of a pop-up that will cover a lot of the
/// screen with an opaque message box and fills the rest of the screen with a
/// translucent overlay to disable touching the page in the background.
///
/// This pop-up can be used to give the user warnings, give them information,
/// allow for confirmation before certain actions, etc.
///
/// ## Examples
///
/// {@tool snippet}
///
/// ### Warning Dialog Example
///
/// This example shows the creation of an alert that is used as a warning. It
/// can explain to the user why they are not being allowed to do a certain
/// thing.
///
/// ```dart
/// /// The alert dialog that will be shown to the user.
/// MyAlert myAlert = MyAlert(
///   title: "Action Blocked!",
///   content: "Your attempt to do this action has been blocked because this "
///       "action can not be completed at this time. Thank you!",
///   buttons: {
///     "ok": () {},
///   },
/// );
///
/// // Show [myAlert] to the user.
/// myAlert.show(context);
/// ```
/// {@end-tool}
///
/// {@tool snippet}
///
/// ### Information Dialog Example
///
/// This example shows the creation of an alert that is used as a way of giving
/// the user information.
///
/// ```dart
/// /// The alert dialog that will be shown to the user.
/// MyAlert myAlert = MyAlert(
///   title: "Did you know?",
///   content: Text("Flutter was initially released in May of 2017?"),
///   buttons: {
///     "Now I Know": () {},
///   },
/// );
///
/// // Show [myAlert] to the user.
/// myAlert.show(context);
/// ```
/// {@end-tool}
///
/// {@tool snippet}
///
/// ### Confirmation Dialog Example
///
/// This example shows the creation of an alert that is used as a way of
/// confirming something with the user.
///
/// ```dart
/// /// The alert dialog that will be shown to the user.
/// MyAlert myAlert = MyAlert(
///   title: "Are you sure?",
///   content: "Are you sure you want to leave this page? Any unsaved data "
///       "will be lost.",
///   buttons: {
///     "leave": () => leavePageAnyway(),
///     "cancel": () => null,
///   },
/// );
///
/// // Show [myAlert] to the user.
/// myAlert.show(context);
/// ```
/// {@end-tool}
class MyAlert extends StatelessWidget {
  /// Creates a pop-up that covers a lot of the screen with an opaque message
  /// box and fills the rest of the screen with a translucent overlay to disable
  /// touching the page in the background.
  ///
  /// **Note:** To display this pop-up, call `this` alert's [show] method.
  ///
  /// This pop-up can be used to display messages to the user. These messages
  /// can be warnings, information, confirmation for certain actions, etc.
  ///
  /// **Note:** Any `content` that is not a widget will be displayed as a string
  /// within a [Text] widget.
  MyAlert({
    Key? key,
    this.title,
    dynamic content,
    this.buttons,
    this.barrierDismissible = true,
  })  : body = (content is Widget)
            ? content
            : (content == null ? null : Text(content.toString())),
        super(key: key);

  /// The title at the top of the alert dialog box.
  final String? title;

  /// The main content in the alert dialog box.
  final dynamic body;

  /// All of the action buttons at the bottom of the alert dialog box as well as
  /// what they do.
  final Map<String?, Function>? buttons;

  /// Whether or not this alert will close if the user clicks outside of it.
  final bool barrierDismissible;

  /// Keeps track of whether or not this alert is currently being displayed.
  final _VisManager _visManager = _VisManager();

  /// This method displays `this` alert to the screen.
  Future<void> show(BuildContext context) async {
    if (!_visManager.isVisible) {
      _visManager.isBuilding = true;

      await showDialog(
        context: context,
        barrierDismissible: barrierDismissible,
        builder: (dialogContext) {
          _visManager.context = dialogContext;

          return this;
        },
      ).whenComplete(() {
        _visManager.isBuilding = false;
      });
    }
  }

  // This method closes `this` alert if it is currently being shown.
  Future<void> close() async {
    if (_visManager.isVisible || _visManager.isBuilding) {
      await _closeAlert();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Display an alert that looks native to the device's platform.
    if (!kIsWeb && Platform.isIOS) {
      return _iosAlert(context);
    } else {
      return _androidAlert(context);
    }
  }

  /// This method displays an alert using a layout that looks more native to
  /// Android devices.
  _androidAlert(BuildContext context) {
    /// The list of buttons that will be displayed at the bottom of the dialog
    /// box.
    List<Widget> builtButtons = [];

    // If there are meant to be buttons, build them.
    if (buttons != null) {
      buttons!.forEach(
        (name, action) {
          builtButtons.add(
            TextButton(
              onPressed: () {
                // Close the dialog box once a button is pressed.
                _closeAlert();

                // Preform the action associated with that button.
                action();
              },
              child: Text(name!),
            ),
          );
        },
      );
    }

    return AlertDialog(
      title: title != null ? Text(title!) : null,
      content: body,
      actions: builtButtons.isEmpty ? [] : builtButtons,
    );
  }

  /// This method displays an alert using a layout that looks more native to iOS
  /// devices.
  _iosAlert(BuildContext context) {
    /// The list of buttons that will be displayed at the bottom of the dialog
    /// box.
    List<Widget> builtButtons = [];

    // If there are meant to be buttons, build them.
    if (buttons != null) {
      buttons!.forEach(
        (name, action) {
          builtButtons.add(
            CupertinoDialogAction(
              onPressed: () {
                // Close the dialog box once a button is pressed.
                _closeAlert();

                // Preform the action associated with that button.
                action();
              },
              child: Text(name!),
            ),
          );
        },
      );
    }

    return CupertinoAlertDialog(
      title: title != null ? Text(title!) : null,
      content: body,
      actions: builtButtons.isEmpty ? [] : builtButtons,
    );
  }

  /// This method closes the alert dialog box.
  Future<void> _closeAlert() async {
    if (_visManager.isBuilding) {
      await Future.doWhile(() =>
          Future.delayed(const Duration(milliseconds: 100))
              .then((value) => _visManager.isBuilding));
    }

    if (_visManager.isVisible) {
      Navigator.pop(_visManager.context!);
      _visManager.context = null;
    }
  }
}

/// Keeps track of whether or not this alert is currently being displayed.
class _VisManager {
  /// If `null`, then the alert is not currently being shown.
  BuildContext? context;

  bool _isBuilding = false;

  bool get isBuilding => _isBuilding && !isVisible;
  set isBuilding(bool isBuilding) => _isBuilding = isBuilding;

  /// Whether or not this alert is currently being shown.
  bool get isVisible => context != null;
}