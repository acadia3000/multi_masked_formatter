import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MultiMaskedTextInputFormatter extends TextInputFormatter {
  List<String>? masks;
  String? separator;
  String? prevMask;

  MultiMaskedTextInputFormatter(
      {required this.masks, required this.separator}) {
    separator = ((separator!.isNotEmpty) ? separator : null)!;
    if (masks != null && masks!.isNotEmpty) {
      masks = masks;
      masks!.sort((l, r) => l.length.compareTo(r.length));
      prevMask = masks![0];
    } else {
      masks = null;
      prevMask = null;
    }
  }

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newText = newValue.text;
    final oldText = oldValue.text;

    if (newText.length == 0 ||
        newText.length < oldText.length ||
        masks == null ||
        separator == null) {
      return newValue;
    } else {}

    final pasted = (newText.length - oldText.length).abs() > 1;
    final mask = masks!.firstWhere((value) {
      final maskValue = pasted ? value.replaceAll(separator!, '') : value;
      return newText.length <= maskValue.length;
    });

    if (mask == null) {
      return oldValue;
    }
    // nullcheck

    final needReset = (prevMask != mask || newText.length - oldText.length > 1);
    prevMask = mask;

    if (needReset) {
      final text = newText.replaceAll(separator!, '');
      String resetValue = '';
      int sep = 0;

      for (int i = 0; i < text.length; i++) {
        if (mask[i + sep] == separator) {
          resetValue += separator!;
          ++sep;
        }
        resetValue += text[i];
      }

      return TextEditingValue(
          text: resetValue,
          selection: TextSelection.collapsed(
            offset: resetValue.length,
          ));
    }

    if (newText.length < mask.length && mask[newText.length - 1] == separator) {
      final text = '$oldText$separator${newText.substring(newText.length - 1)}';
      return TextEditingValue(
        text: text,
        selection: TextSelection.collapsed(
          offset: text.length,
        ),
      );
    }

    return newValue;
  }
}
