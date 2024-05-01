import 'package:flutter/material.dart';
import 'package:your_story/style.dart';
import 'package:your_story/pages/create_story_pages/processing_illustarting/global_story.dart';


class storyType extends StatefulWidget {
  final Function(String) onCategorySelected;

   storyType({Key? key, required this.onCategorySelected})
      : super(key: key);

  @override
  _storyTypeState createState() => _storyTypeState();
}

class _storyTypeState extends State<storyType> {
  int selectedIndex = 0;
  List categories = [' جميع القصص', 'مصورة', 'مسودة'];
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
            padding: EdgeInsets.symmetric(horizontal: kDefaultPadding/1.5),
            decoration: BoxDecoration(
                 color: index == (searchQuery1!.isEmpty ? 0 : selectedIndex)
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
