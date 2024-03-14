import 'package:flutter/material.dart';
import 'package:your_story/style.dart';

class storyType extends StatefulWidget {
  final Function(String) onCategorySelected;

  const storyType({Key? key, required this.onCategorySelected})
      : super(key: key);

  @override
  _storyTypeState createState() => _storyTypeState();
}

class _storyTypeState extends State<storyType> {
  int selectedIndex = 0;
  List categories = [' جميع القصص', 'مصورة', 'غير مصورة'];
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
      height: 30,
      alignment: Alignment.center,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            setState(() {
              selectedIndex = index;
            });
            widget.onCategorySelected(categories[index]);
          },
          child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(
              left: kDefaultPadding,
              right: kDefaultPadding,
            ),
            padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
            decoration: BoxDecoration(
              color: index == selectedIndex
                  ? Colors.white.withOpacity(0.4)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              categories[index],
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
