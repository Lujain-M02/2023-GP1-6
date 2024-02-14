import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:your_story/pages/create_story_pages/create_story.dart';
import 'package:your_story/pages/More_Page/more_page.dart';
import 'package:your_story/pages/MyStories_Page/my_stories_page.dart';
import 'package:your_story/style.dart';
import 'package:lottie/lottie.dart';
import 'package:share/share.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPage createState() => _MainPage();
}

class PdfData {
  final String title;
  final String pdfUrl;
  final String docId;

  PdfData({required this.title, required this.pdfUrl, required this.docId});
}

class _MainPage extends State<MainPage> {
  //late final String userId;
  late final Stream<List<QueryDocumentSnapshot>> pdfS;
  final List<PdfData> _allPdfs = [];
  bool _isLoading = true;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchAllPdfs();
  } /*
  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser!.uid;
    pdfS = FirebaseFirestore.instance
        .collection("User")
        .doc(userId)
        .collection("pdf")
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }*/

  Future<void> _fetchAllPdfs() async {
    FirebaseFirestore.instance
        .collection('User')
        .get()
        .then((userSnapshot) async {
      List<PdfData> tempAllPdfs = [];
      for (var userDoc in userSnapshot.docs) {
        final userId = userDoc.id;
        await FirebaseFirestore.instance
            .collection('User')
            .doc(userId)
            .collection('pdf')
            .get()
            .then((pdfSnapshot) {
          for (var pdfDoc in pdfSnapshot.docs) {
            final pdfData = PdfData(
              title: pdfDoc.data()['title'] ?? 'Untitled',
              pdfUrl: pdfDoc.data()['url'] ?? '#',
              docId: pdfDoc.id,
            );
            tempAllPdfs.add(pdfData);
          }
        });
      }
      setState(() {
        _allPdfs.clear();
        _allPdfs.addAll(tempAllPdfs);
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              body: _buildBody(_currentIndex),
              bottomNavigationBar: CurvedNavigationBar(
                backgroundColor: Colors.white,
                index: _currentIndex,
                onTap: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                items: const <Widget>[
                  Icon(Icons.home, size: 30, color: Colors.white),
                  Icon(Icons.library_books, size: 30, color: Colors.white),
                  Icon(
                    Icons.more_vert_sharp,
                    size: 30,
                    color: Colors.white,
                  ),
                ],
                color: const Color.fromARGB(199, 0, 29, 57),
                buttonBackgroundColor: YourStoryStyle.primarycolor,
                // You can customize the appearance more if needed
              ),
            )));
  }

  Widget _buildBody(int currentIndex) {
    Future<void> sharePdf(
        String pdfUrl, String title, BuildContext context) async {
      try {
        final response = await http.get(Uri.parse(pdfUrl));
        final bytes = response.bodyBytes;

        // Get the temporary directory and save the PDF file
        final tempDir = await getTemporaryDirectory();
        final file = File('${tempDir.path}/$title.pdf');
        await file.writeAsBytes(bytes);

        // Share the local file path
        Share.shareFiles([file.path], text: 'ملف القصة: $title.pdf');
      } catch (e) {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text('خطأ'),
            content: Text('لا يمكن مشاركة الملف: $e'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('حسنًا'),
              ),
            ],
          ),
        );
      }
    }

    Widget _buildPdfCard(String title, String pdfUrl, String docId, int index) {
      return Container(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFFF5F9FD),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF475269).withOpacity(0.3),
              blurRadius: 5,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  // preview
                },
                child: Image.asset(
                  "assets/6.png",
                ),
              ),
            ),
            Center(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF475269),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.share,
                      color: Color.fromARGB(255, 5, 0, 58)),
                  onPressed: () => sharePdf(pdfUrl, title, context),
                ),
              ],
            ),
          ],
        ),
      );
    }

    if (currentIndex == 0) {
      // Home Page
      return _isLoading
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                childAspectRatio: 0.75,
              ),
              itemCount: _allPdfs.length,
              itemBuilder: (context, index) {
                final pdf = _allPdfs[index];
                return _buildPdfCard(pdf.title, pdf.pdfUrl, pdf.docId, index);
              },
            );
    } else if (currentIndex == 1) {
      // stories Page
      return const MyStories();
    } else if (currentIndex == 2) {
      return const MorePage();
    }
    return Container();
  }
}

class StoriesPage extends StatelessWidget {
  final String userId;

  final Stream<List<QueryDocumentSnapshot>> pdfS;

  const StoriesPage({Key? key, required this.pdfS, required this.userId})
      : super(key: key);

  Widget _buildPdfCard(String title, String pdfUrl, String docId, int index,
      BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFFF5F9FD),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF475269).withOpacity(0.3),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                // preview
              },
              child: Image.asset(
                "assets/6.png",
              ),
            ),
          ),
          Center(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF475269),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /* IconButton(
                icon: const Icon(Icons.share, color: Colors.blue),
                onPressed: () => sharePdf(pdfUrl, title, context),
              ),*/
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 48, 96),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text(
              "القصص المنشورة",
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
            const SizedBox(height: 10), // space between the text and the box
            Container(
                padding: const EdgeInsets.only(
                  left: 20,
                  top: 30,
                  right: 20,
                  bottom: 700,
                ),
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 244, 247, 252),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                  ),
                ),
                child: StreamBuilder<List<QueryDocumentSnapshot>>(
                  stream: pdfS,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: Lottie.asset('assets/loading2.json',
                            width: 200, height: 200),
                      );
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
                        child: const Center(
                          child: Text("No PDF found"),
                        ),
                      );
                    }

                    final stories = snapshot.data!;

                    return Container(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                      ),
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 244, 247, 252),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(60),
                        ),
                      ),
                      child: GridView.builder(
                        padding: const EdgeInsets.all(20),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.75,
                        ),
                        itemCount: stories.length,
                        itemBuilder: (context, index) {
                          final pdfData =
                              stories[index].data() as Map<String, dynamic>?;
                          final String title = pdfData?['title'] ?? 'Untitled';
                          final String pdfUrl = pdfData?['url'] ?? '#';
                          final String docId = stories[index].id;

                          return _buildPdfCard(
                              title, pdfUrl, docId, index, context);
                        },
                      ),
                    );
                  },
                )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the CreateStory Page when the button is pressed
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateStory()),
          );
        },
        backgroundColor: const Color.fromARGB(255, 15, 26, 107),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
