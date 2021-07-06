import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MultiMaskedTextInputFormatter extends TextInputFormatter {
  List<String> _masks;
  List<String> _separator;
  String _prevMask;

  MultiMaskedTextInputFormatter(
      {@required List<String> masks, @required List<String> separator}) {
    _separator = (separator != null && separator.isNotEmpty) ? separator : null;
    if (masks != null && masks.isNotEmpty) {
      _masks = masks;
      _masks.sort((l, r) => l.length.compareTo(r.length));
      _prevMask = masks[0];
    }
  }

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newText = newValue.text;
    final oldText = oldValue.text;

    if (newText.length == 0 ||
        newText.length < oldText.length ||
        _masks == null ||
        _separator == null) {
      return newValue;
    }

    final pasted = (newText.length - oldText.length).abs() > 1;
    final mask = _masks.firstWhere((value) {
      String maskValue = value; 
      
      if(pasted) {
        _separator.forEach((f) {          
          maskValue = maskValue.replaceAll(f, '');        
        });
      } 
      else 
        maskValue = value;

      return newText.length <= maskValue.length;
    }, orElse: () => null);

    if (mask == null) {
      return oldValue;
    }

    final needReset =
        (_prevMask != mask || newText.length - oldText.length > 1);
    _prevMask = mask;

    if (needReset) {
      String text = newText; 
      _separator.forEach((f) {
        text = text.replaceAll(f, '');
      });
      String resetValue = '';
      int sep = 0;

      for (int i = 0; i < text.length; i++) {
        if (_separator.contains(mask[i + sep])) {
          _separator.forEach((f) {
            if(f == mask[i+sep]) {
              resetValue += f;
              ++sep;
            }

          });          
        }
        resetValue += text[i];
      }

      return TextEditingValue(
          text: resetValue,
          selection: TextSelection.collapsed(
            offset: resetValue.length,
          ));
    }

    String cleanText = newText;

    _separator.forEach((element) {
      cleanText = cleanText.replaceAll(element, '');
    });

    if(newText.length < mask.length) {
      
      int index = 0;
      int normalCount = 0;
      String calcText = '';
      while(index < mask.length) {
        if(_separator.contains(mask[index]))
          calcText += mask[index];
        else {
          calcText += cleanText[normalCount];
          normalCount++;
        }

        index++;
        if(normalCount == cleanText.length)
          break;
      }

      return TextEditingValue(
        text: calcText,
        selection: TextSelection.collapsed(
          offset: calcText.length,
        ),
      );
    }
    return newValue;
  }
}
