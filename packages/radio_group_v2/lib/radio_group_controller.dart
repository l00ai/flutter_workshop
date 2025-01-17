import 'package:flutter/material.dart';

import 'exceptions/controller_decoupled_exception.dart';
import 'exceptions/illegal_value_exception.dart';
import 'exceptions/index_out_of_bounds_exception.dart';
import 'exceptions/multiple_radio_group_exception.dart';
import 'radio_group_v2.dart';

/// Holds the value of the selected button so parent widgets can know what
/// is selected and also allows parent widgets to set a new selected value.
///
/// {@tool snippet}
///
/// This sample shows how to retrieve the value of the selected button.
///
/// ```dart
/// // First initialize everything
/// RadioGroupController myController = RadioGroupController();
/// List<String> items = ["Choice1", "Choice2", "Choice3"];
/// RadioGroup(
///   controller: myController,
///   values: items,
///   onChanged: (value) {
///     liveChangeHere();
///   },
///   orientation: Horizontal,
/// )
///
/// // This code programmatically sets the last radio button as "selected".
/// myController.value = items.last;
///
/// // This code retrieves the value of the selected button.
/// String selectedValue = myController.value as String;
/// ```
/// {@end-tool}
class RadioGroupController {
  /// This is the state of the radio group that this controller is in charge of.
  GlobalKey<RadioGroupState>? _myRadioGroupKey;

  RadioGroupState? _myRadioGroup;

  GlobalKey<RadioGroupState>? get myRadioGroupKey => _myRadioGroupKey;
  set myRadioGroupKey(GlobalKey<RadioGroupState>? key) {
    if (key == null) return;

    if (key == _myRadioGroupKey) {
      if (_myRadioGroupKey!.currentState != null &&
          _myRadioGroupKey!.currentState!.mounted &&
          _myRadioGroupKey!.currentState! != _myRadioGroup) {
        _myRadioGroup = _myRadioGroupKey!.currentState!;
      }

      return;
    }

    if (_myRadioGroup == null || !_myRadioGroup!.mounted) {
      _myRadioGroupKey = key;
      _myRadioGroup = _myRadioGroupKey!.currentState;
    } else {
      throw MultipleRadioGroupException(radioGroupController: this, key: key);
    }
  }

  /// Sets the value of the selected item in `this` controller's radio group.
  ///
  /// @throws [IllegalValueException] If the `value` provided is not a value in
  /// the radio group's values list.
  ///
  /// @throws [ControllerDecoupledException] If the controller cannot access the
  /// value of its radio group.
  set value(Object? value) {
    if (_myRadioGroup != null) {
      if (value != null && !_myRadioGroup!.widget.values.contains(value)) {
        throw IllegalValueException(value: value);
      }

      _myRadioGroup!.value = value;
      return;
    }

    // If it makes it to this point, something has gone wrong.
    throw ControllerDecoupledException(radioGroupController: this);
  }

  /// Returns the value of the selected item in `this` controller's radio group.
  ///
  /// @throws [ControllerDecoupledException] If the controller cannot access the
  /// value of its radio group.
  Object? get value {
    if (_myRadioGroup != null) {
      return _myRadioGroup!.value;
    }

    // If it makes it to this point, something has gone wrong.
    throw ControllerDecoupledException(radioGroupController: this);
  }

  /// Sets the value of the selected item in `this` controller's radio group to
  /// the value of the element at `index` in the radio group's value list.
  ///
  /// **Note:** By setting `index` to `-1`, the radio group will deselect all
  /// options.
  ///
  /// @throws [IndexOutOfBoundsException] If the `index` provided is not within
  /// the range of the radio group's value list.
  ///
  /// @throws [ControllerDecoupledException] If the controller cannot access the
  /// value of its radio group.
  void selectAt(int index) {
    if (_myRadioGroup != null) {
      if (index == -1) {
        value = null;
      } else if (index >= 0 && index < _myRadioGroup!.widget.values.length) {
        value = _myRadioGroup!.widget.values[index];
      } else {
        throw IndexOutOfBoundsException(
          index: index,
          iterable: _myRadioGroup!.widget.values,
        );
      }
    }
  }
}
