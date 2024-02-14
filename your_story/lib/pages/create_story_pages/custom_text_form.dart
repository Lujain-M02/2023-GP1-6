import 'package:flutter/material.dart';
import 'package:languagetool_textfield/languagetool_textfield.dart';

class CustomLanguageToolTextField extends LanguageToolTextField {
  final String? Function(String?)? customValidator;
  final Widget? child;

  CustomLanguageToolTextField({
    Key? key,
    required LanguageToolController controller,
    String? language,
   this.child,
    InputDecoration? decoration,
    String? hintText,
    TextStyle? hintStyle,
    TextStyle? style,
    String? labelText,
    TextStyle? labelStyle,
    Widget? prefix,
    Widget? suffix,
    bool obscureText = false,
    bool autocorrect = true,
    bool autofocus = false,
    bool enableSuggestions = true,
    int? maxLines,
    int? minLines,
    int? maxLength,
    ValueChanged<String>? onChanged,
    this.customValidator,
    TextInputAction? textInputAction,
    ValueChanged<String>? onSubmitted,
    TextInputType? keyboardType,
    FocusNode? focusNode,
    bool enabled = true,
    GestureTapCallback? onTap,
    bool readOnly = false,
    TextEditingController? controllerToCopyFrom,
  }) : super(
          key: key,
          controller: controller,
          language: 'ar',
          style: style,
          maxLines: maxLines,
          minLines: minLines,
          decoration: decoration?.copyWith(hintText: hintText) ?? InputDecoration(hintText: hintText),
        );
}


