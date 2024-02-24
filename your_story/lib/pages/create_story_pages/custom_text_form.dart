// import 'package:flutter/material.dart';
// import 'package:languagetool_textfield/languagetool_textfield.dart';

// class CustomLanguageToolTextField extends LanguageToolTextField {
//   final String? Function(String?)? customValidator;
//   final Widget? child;

//   CustomLanguageToolTextField({
//     Key? key,
//     required LanguageToolController controller,
//     String? language,
//    this.child,
//     InputDecoration? decoration,
//     String? hintText,
//     TextStyle? hintStyle,
//     TextStyle? style,
//     String? labelText,
//     TextStyle? labelStyle,
//     Widget? prefix,
//     Widget? suffix,
//     bool obscureText = false,
//     bool autocorrect = true,
//     bool autofocus = false,
//     bool enableSuggestions = true,
//     int? maxLines,
//     int? minLines,
//     int? maxLength,
//     ValueChanged<String>? onChanged,
//     this.customValidator,
//     TextInputAction? textInputAction,
//     ValueChanged<String>? onSubmitted,
//     TextInputType? keyboardType,
//     FocusNode? focusNode,
//     bool enabled = true,
//     GestureTapCallback? onTap,
//     bool readOnly = false,
//     TextEditingController? controllerToCopyFrom,
//   }) : super(
//           key: key,
//           controller: controller,
//           language: 'ar',
//           style: style,
//           maxLines: maxLines,
//           minLines: minLines,
//           decoration: decoration?.copyWith(hintText: hintText) ?? InputDecoration(hintText: hintText),
//         );
// }

import 'package:flutter/material.dart';
import 'package:languagetool_textfield/languagetool_textfield.dart';
import 'package:flutter/services.dart';

class CustomLanguageToolTextField extends LanguageToolTextField {
  final String? Function(String?)? customValidator;
  final bool applyNewLineFilter;
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
    this.applyNewLineFilter = false,
    TextEditingController? controllerToCopyFrom,
  }) : super(
    key: key,
    controller: controller,
    language: "ar",
    style: style,
    maxLines: maxLines,
    minLines: minLines,
    decoration: decoration ?? InputDecoration(hintText: hintText),
  );

  @override
  _CustomLanguageToolTextFieldState createState() => _CustomLanguageToolTextFieldState();
}

class _CustomLanguageToolTextFieldState extends State<CustomLanguageToolTextField> {
  final _focusNode = FocusNode();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final controller = widget.controller;

    controller.focusNode = _focusNode;
    controller.language = widget.language;
    final defaultPopup = MistakePopup(popupRenderer: PopupOverlayRenderer());
    controller.popupWidget = widget.mistakePopup ?? defaultPopup;

    controller.addListener(_textControllerListener);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (_, __) {
        final fetchError = widget.controller.fetchError;

        // it would probably look much better if the error would be shown on a
        // dedicated panel with field options
        final httpErrorText = Text(
          '$fetchError',
          style: TextStyle(
            color: widget.controller.highlightStyle.misspellingMistakeColor,
          ),
        );

        final inputDecoration = widget.decoration.copyWith(
          suffix: fetchError != null ? httpErrorText : null,
        );

        return TextField(
          textAlign: widget.textAlign,
          textDirection: widget.textDirection,
          focusNode: _focusNode,
          controller: widget.controller,
          scrollController: _scrollController,
          decoration: inputDecoration,
          minLines: widget.minLines,
            inputFormatters: widget.applyNewLineFilter
            ? [FilteringTextInputFormatter.deny(RegExp(r'\n'))]
            : null,
          maxLines: widget.maxLines,
          expands: widget.expands,
          style: widget.style,
        );
      },
    );
  }

    void _textControllerListener() =>
      widget.controller.scrollOffset = _scrollController.offset;

  @override
  void dispose() {
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}



