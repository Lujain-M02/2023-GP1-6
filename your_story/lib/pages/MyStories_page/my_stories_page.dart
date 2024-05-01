import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:your_story/pages/MyStories_page/cardStyle.dart';
import 'package:your_story/pages/MyStories_page/searchBox.dart';
import 'package:your_story/pages/MyStories_page/typeBar.dart';
import 'package:your_story/pages/create_story_pages/create_story.dart';
import 'package:your_story/style.dart';

class MyStories extends StatefulWidget {
  const MyStories({super.key});

  @override
  State<MyStories> createState() => _MyStoriesState();
}

class _MyStoriesState extends State<MyStories> {
  final StreamController<List<QueryDocumentSnapshot>> _storiesStreamController =
      StreamController.broadcast();
  late Stream<List<QueryDocumentSnapshot>> storiesList;
  late final String userId;
  // List<QueryDocumentSnapshot> _allStories = [];
  late TextEditingController _searchController;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser!.uid;
    storiesList = _storiesStreamController.stream;
    _searchController = TextEditingController();
    updateStoriesList(
      'جميع القصص',
    );
  }

  void updateStoriesList(String category) {
    String filter = '';
    switch (category) {
      case 'مصورة':
        filter = 'illustrated';
        break;
      case 'مسودة':
        filter = 'drafted';
        break;
      case 'جميع القصص':
      default:
        filter = '';
        break;
    }

    var collection = FirebaseFirestore.instance
        .collection("User")
        .doc(userId)
        .collection("Story");
    var query = filter.isNotEmpty
        ? collection.where('type', isEqualTo: filter)
        : collection;

    query.snapshots().listen((snapshot) {
      if (_searchQuery.isEmpty) {
        _storiesStreamController.add(snapshot.docs);
      } else {
        final filteredData = snapshot.docs
            .where((doc) => (doc.data())['title']
                .toString()
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()))
            .toList();
        _storiesStreamController.add(filteredData);
      }
    });
  }

  void _handleSearchChange(String query) {
    setState(() {
      _searchQuery = query;
      updateStoriesList('جميع القصص');
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              "قصصي",
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
            centerTitle: true,
            backgroundColor: YourStoryStyle.s2Color,
            automaticallyImplyLeading: false,
          ),
          backgroundColor: YourStoryStyle.s2Color,
          body: Column(children: [
            SearchBox(
              controller: _searchController,
              onChanged: (query) {
                _handleSearchChange(query);
              },
              onClearPressed: () {
                _searchController.clear();
                _handleSearchChange('');
              },
            ),
            storyType(onCategorySelected: updateStoriesList),
            const SizedBox(height: kDefaultPadding / 2),
            StreamBuilder<List<QueryDocumentSnapshot>>(
                stream: storiesList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Lottie.asset('assets/loading_white.json',
                          width: 200, height: 200),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(top: 70),
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 244, 247, 252),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40),
                          ),
                        ),
                        child: _searchQuery.isEmpty
                            ? const Center(
                                child: Text(
                                  'يبدو أنه لا يوجد أي قصص منشوره',
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : Center(
                                child: Text(
                                  'يبدو أنه لا يوجد أي قصص بعنوان \"$_searchQuery\"',
                                  style: const TextStyle(
                                    fontSize: 25,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                      ),
                    );
                  }

                  final stories = snapshot.data!;
                  return Expanded(
                      child: Stack(children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(top: 70),
                      decoration: const BoxDecoration(
                        color: kBackgroundColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                      ),
                    ),
                    ListView.builder(
                      itemCount: stories.length,
                      itemBuilder: (context, index) {
                        final pdfData =
                            stories[index].data() as Map<String, dynamic>?;
                        final String title = pdfData?['title'] ?? 'Untitled';
                        final String content = pdfData?['content'] ?? '';
                        final String pdfUrl = pdfData?['url'] ?? '#';
                        final String fimg = pdfData?['imageUrl'] ?? '#';
                        final bool status = pdfData?['published'] ?? false;
                        final String docId = stories[index].id;
                        final String storyType = pdfData?['type'];
                        final String userId = pdfData?['userId'] ?? 'Unknown'; 
                        return pdfCard_myStories(
                            storyType: storyType,
                            pdfUrl: pdfUrl,
                            title: title,
                            docId: docId,
                            content: content,
                            status: status,
                            fimg: fimg,
                            size: size,
                            index: index,
                            userId:userId);
                      },
                      padding: const EdgeInsets.only(bottom: 80),
                    )
                  ]));
                }),
          ]),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CreateStory()),
              );
            },
            backgroundColor: const Color.fromARGB(255, 15, 26, 107),
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ));
  }
}
