import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:your_story/pages/MyStories_page/cardStyle.dart';
import 'package:your_story/pages/create_story_pages/create_story.dart';
import 'package:your_story/pages/published_stories/waiting_method.dart';
import 'package:your_story/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:math' as math;

//import 'package:your_story/pages/pdf_pages/pdf_view.dart';

class StoriesPage extends StatefulWidget {
  const StoriesPage({Key? key}) : super(key: key);

  @override
  State<StoriesPage> createState() => _StoriesPageState();
}

class _StoriesPageState extends State<StoriesPage> {
  late final StreamController<List<QueryDocumentSnapshot>>
      _storiesStreamController;
  late TextEditingController _searchController;
  bool _isSearching = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();

    _storiesStreamController = StreamController<List<QueryDocumentSnapshot>>();
    _searchController = TextEditingController();
    _updateCombinedStoriesStream();

    //_isMounted = true;
  }

  //  create combined stories stream
  Stream<List<QueryDocumentSnapshot>> _createCombinedStoriesStream() {
    var usersRef = FirebaseFirestore.instance.collection('User');

    return usersRef.snapshots().flatMap((usersSnapshot) {
      if (usersSnapshot.docs.isEmpty) {
        return Stream.value([]);
      }
      // Create a list of streams for each user's stories
      List<Stream<List<QueryDocumentSnapshot>>> storyStreams =
          usersSnapshot.docs.map((userDoc) {
        return userDoc.reference
            .collection('Story')
            .where('type', isEqualTo: 'illustrated')
            .where('published', isEqualTo: true)
            .snapshots()
            .map((snapshot) => snapshot.docs);
      }).toList();
      // Combine all story streams into one
      return CombineLatestStream.list(storyStreams).map((listOfStoryLists) {
        return listOfStoryLists.expand((x) => x).toList();
      });
    });
  }

  // Function to update stories stream
  void _updateCombinedStoriesStream() {
    _createCombinedStoriesStream().listen((data) {
      if (_searchQuery.isEmpty) {
        _storiesStreamController.add(data);
      } else {
        final filteredData = data
            .where((doc) => (doc.data() as Map<String, dynamic>)['title']
                .toString()
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()))
            .toList();
        _storiesStreamController.add(filteredData);
      }
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
    });
  }

  void _handleSearchChange(String query) {
    setState(() {
      _searchQuery = query;
      _updateCombinedStoriesStream();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "القصص المنشورة ",
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: _toggleSearch,
          ),
        ],
        centerTitle: true,
        backgroundColor: YourStoryStyle.s2Color,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: YourStoryStyle.s2Color,
      body: Stack(
        children: [
          StreamBuilder<List<QueryDocumentSnapshot>>(
            stream: _storiesStreamController.stream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return waiting_page();
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Container(
                  padding: const EdgeInsets.only(
                    left: 20,
                    top: 30,
                    right: 20,
                  ),
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 244, 247, 252),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                    ),
                  ),
                  child: _isSearching
                      ? const Center(
                          child: Text(
                            'يبدو أنه لا يوجد أي قصص منشوره',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : Center(
                          child: Text(
                            'يبدو أنه لا يوجد أي قصص منشوره بعنوان \"$_searchQuery\"',
                            style: const TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                );
              }

              final stories = snapshot.data!;
stories.sort((a, b) => (b['views'] ?? 0).compareTo(a['views'] ?? 0)); // Sort stories
              return SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                  ),
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 244, 247, 252),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                    ),
                  ),
                  child: Column(children: [
                    // const SizedBox(
                    // height: 120,
                    // width: double.infinity,
                    // child: Row(mainAxisAlignment: MainAxisAlignment.start,
                    //   children: [
                    //     Text(
                    //       'حيث نحول خيالك\n                       لواقع ',
                    //       style: TextStyle(fontSize: 30,),
                    //       // textAlign: TextAlign.justify,
                    //     ),
                    //   ],
                    // ),
                    //     ),
                    _searchQuery == ''
                        ? Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 20,
                                ),
                                child: Container(
                                  width: double.infinity,
                                  alignment: Alignment.centerRight,
                                  child: const Text(
                                    "القصص الاعلى مشاهدة",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Container(
                                height: 200,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: math.min(
                                      stories.length, 5), //stories.length,
                                  itemBuilder: (context, index) {
                                    final pdfData = stories[index].data()
                                        as Map<String, dynamic>?;
                                    final String title =
                                        pdfData?['title'] ?? 'Untitled';
                                    final String pdfUrl =
                                        pdfData?['url'] ?? '#';
                                    final String fimg =
                                        pdfData?['imageUrl'] ?? '#';
                                    final String userId = pdfData?['userId'] ?? 'Unknown';
                                    final String docId = stories[index].id; 
                                    return resentCard(pdfUrl: pdfUrl, title: title, fimg: fimg , userId:userId, docId: docId,);
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              const Divider(height: 5),
                            ],
                          )
                        : const SizedBox(
                            height: 0,
                          ),

                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.centerRight,
                        child: const Text(
                          "جميع القصص",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(10),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.75,
                          ),
                          itemCount: stories.length,
                          itemBuilder: (context, index) {
                            final pdfData =
                                stories[index].data() as Map<String, dynamic>?;
                            final String title =
                                pdfData?['title'] ?? 'Untitled';
                            final String pdfUrl = pdfData?['url'] ?? '#';
                            final String docId = stories[index].id;
                            final String fimg = pdfData?['imageUrl'] ?? '#';
                            final String userId = pdfData?['userId'] ?? 'Unknown'; 
                            return PdfCard_published(
                              title: title,
                              pdfUrl: pdfUrl,
                              docId: docId,
                              fimg: fimg,
                              index: index,
                              userId:userId,
                            );
                          },
                        ),
                        _searchQuery == ''
                            ? const SizedBox(height: 0)
                            : SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.5,
                              )
                      ],
                    ),
                  ]),
                ),
              );
            },
          ),
          if (_isSearching) ...[
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  autofocus: true,
                  controller: _searchController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: '...ابحث عن قصة',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        _searchController.clear();
                        _handleSearchChange('');
                        _toggleSearch();
                      },
                    ),
                  ),
                  onChanged: _handleSearchChange,
                  onSubmitted: (value) {
                    _toggleSearch();
                  },
                ),
              ),
            ),
          ],
        ],
      ),
      floatingActionButton: _isSearching
          ? null
          : FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CreateStory()),
                );
              },
              backgroundColor: const Color.fromARGB(255, 15, 26, 107),
              child: const Icon(Icons.add, color: Colors.white),
            ),
    );
  }
}
