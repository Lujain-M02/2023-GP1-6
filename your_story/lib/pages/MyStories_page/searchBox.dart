import 'package:flutter/material.dart';
import 'package:your_story/style.dart';

class SearchBox extends StatelessWidget {
  const SearchBox({
     Key? key,
    required this.onChanged,
  }) : super(key: key);

  final ValueChanged onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: kDefaultPadding,
              right: 5,),
      padding: const EdgeInsets.symmetric(
        vertical: kDefaultPadding / 4, 
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        onChanged: onChanged,
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          prefixIcon: const Icon(Icons.search, color: Colors.white),
          hintText: 'البحث عن قصة',
          hintStyle: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}