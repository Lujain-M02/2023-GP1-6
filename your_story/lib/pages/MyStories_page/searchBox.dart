import 'package:flutter/material.dart';
import 'package:your_story/style.dart';

class SearchBox extends StatelessWidget {
  const SearchBox({
    Key? key,
    required this.onChanged,
    required this.controller,
    required this.onClearPressed,
  }) : super(key: key);

  final ValueChanged<String> onChanged;
  final TextEditingController controller;
  final VoidCallback onClearPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        left: kDefaultPadding,
        right: 5,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: kDefaultPadding / 4,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        autofocus: true,
        onChanged: onChanged,
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          prefixIcon: Icon(Icons.search, color: Colors.white),
          hintText: 'البحث عن قصة',
          hintStyle: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
