import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import 'package:your_story/pages/create_story_pages/create_story.dart';
import 'package:your_story/pages/MyStories_Page/pdf_methods.dart';
import 'package:your_story/pages/pdf_pages/pdf_view.dart';
import 'package:your_story/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
//import 'package:your_story/pages/pdf_pages/pdf_view.dart';

class StoriesPage extends StatefulWidget {
  const StoriesPage({Key? key}) : super(key: key);

  @override
  State<StoriesPage> createState() => _StoriesPageState();
}
/*
 class _StoriesPageState extends State<StoriesPage> {
   late final Stream<List<QueryDocumentSnapshot>> combinedStoriesStream;

   @override
   void initState() {
     super.initState();
     combinedStoriesStream = _createCombinedStoriesStream();
   }

   Stream<List<QueryDocumentSnapshot>> _createCombinedStoriesStream() {
     var usersRef = FirebaseFirestore.instance.collection('User');

     return usersRef.snapshots().flatMap((usersSnapshot) {
       if (usersSnapshot.docs.isEmpty) {
         return Stream.value([]);
       }

       List<Stream<List<QueryDocumentSnapshot>>> storyStreams =
           usersSnapshot.docs.map((userDoc) {
         return userDoc.reference
             .collection('Story')
             .where('type', isEqualTo: 'illustrated')
             .where('published', isEqualTo: true)
             .snapshots()
             .map((snapshot) => snapshot.docs);
       }).toList();

       return CombineLatestStream.list(storyStreams).map((listOfStoryLists) {
         return listOfStoryLists.expand((x) => x).toList();
       });
     });
   }

   Future<void> refreshList() {
     combinedStoriesStream = _createCombinedStoriesStream();
     return Future.delayed(Duration(seconds: 3));
   }*/

class _StoriesPageState extends State<StoriesPage> {
  
  late final StreamController<List<QueryDocumentSnapshot>>
      _storiesStreamController;

  // bool _isRefreshing = false;
  // bool _isMounted = false;

  @override
  void initState() {
    super.initState();

    _storiesStreamController = StreamController<List<QueryDocumentSnapshot>>();

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
      _storiesStreamController.add(data);
    });
  }

  // Future<void> refreshStoriesList() async {
  //   if (!_isMounted) return;
  //   setState(() {
  //     _isRefreshing = true;
  //   });

  //   await Future.delayed(const Duration(seconds: 10)); //
  //   if (!_isMounted) return;
  //   _updateCombinedStoriesStream();

  //   if (!_isMounted) return;
  //   setState(() {
  //     _isRefreshing = false;
  //   });
  // }

  // @override
  // void dispose() {
  //   _storiesStreamController.close();
  //   //_isMounted = false;
  //   super.dispose();
  // }

  Widget _buildPdfCard(String title, String pdfUrl, String docId,String fimg, int index,
      BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
           builder: (context) => ViewPDFPage(pdfUrl: pdfUrl, storyTitle: title),
          )
        );
      },
      child: Container(
        padding: const EdgeInsets.only(left: 5, right: 5, top: 10),
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color:  const Color.fromARGB(255, 244, 247, 252),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF475269).withOpacity(0.3),
              blurRadius: 5,
              spreadRadius: 1,
            ),
          ],
        ),
        child:Stack(children: <Widget>[
          Positioned(right: 0,
          left: 3,
          child: Hero(tag: index,
          child: Container(
            height: 130,
            child: Stack(
              children: <Widget>[
                Image.asset(
                  width: 150,
                  height: 150,
                  "assets/under2.png",
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 20,
                  left: 39,
                  child:ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: fimg,
                      width: 81,
                      height: 100.5,
                      fit: BoxFit.cover,
                      placeholder: 
                      (context,url)=>Center(child: Lottie.asset('assets/loading.json',width: 200,height: 200)),                           
                      errorWidget: (context,url, error) =>                                                          
                      Image.asset(                                                        
                        "assets/errorimg.png", // An error placeholder image                                                        
                        width: 45,                                                        
                        height: 45,                                                        
                        fit: BoxFit.cover,
                     ),
                    ),
                  ) ,
                ),
                Positioned(top: 83,
                child: Image.asset(
                  "assets/pdfupper.png",
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
                )
              ],
            ),
          )
          ,)
          ),
          Padding(padding:  EdgeInsets.only(top: height*0.15),
          child: Column(children: [Center(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color:const Color(0xFF475269),
              ),
             maxLines: 1,
             overflow: TextOverflow.ellipsis,                                                             
            ),
          ),
          Row(
            children: [Expanded(
              child: 
              IconButton(
              icon:Icon(FontAwesomeIcons.shareFromSquare,color: const Color.fromARGB(255, 0, 0, 0),),
              onPressed: () => sharePdf(pdfUrl, title, context),)
              ),
              Expanded(
              child:                     
              IconButton(  
                icon: Icon(FontAwesomeIcons.download,color: const Color.fromARGB(255, 0, 0, 0),),   
                onPressed: () => downloadAndSaveFile(pdfUrl, title, context),
                )                                                             
              )
              ],
          )
          ],),)
        ],) 
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "القصص المنشورة",
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: YourStoryStyle.s2Color,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: YourStoryStyle.s2Color,
      body: StreamBuilder<List<QueryDocumentSnapshot>>(
        stream: _storiesStreamController.stream,
        builder: (context, snapshot) {

            /*   if (_isRefreshing) {
           return Center(
             child: CircularProgressIndicator(),
           );
            Container(
             padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
             decoration: const BoxDecoration(
               color: Color.fromARGB(255, 255, 255, 255),
               borderRadius: BorderRadius.only(topLeft: Radius.circular(60)),
             ),
             child: GridView.builder(
               itemCount: 8,
               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                 crossAxisCount: 2,
                 crossAxisSpacing: 10,
                 mainAxisSpacing: 10,
                 childAspectRatio: 0.75,
             ),
               itemBuilder: (context, index) {
                 return Container(
                   height: 200,
                   width: 220,
                   padding:
                       const EdgeInsets.only(left: 15, right: 15, top: 10),
                   margin: const EdgeInsets.all(8),
                   decoration: BoxDecoration(
                     color: const Color(0xFFFF5F9FD),
                     borderRadius: BorderRadius.circular(10),
                   ),
                   child: Shimmer.fromColors(
                     baseColor: Colors.grey.shade700.withOpacity(0.9),
                     highlightColor: Colors.grey.withOpacity(0.4),
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Container(
                           height: 140,
                         width: 160,
                           decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(30),
                             color: Colors.grey.shade600.withOpacity(0.6),
                           ),
                         ),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Container(
                               height: 40,
                               width: 80,
                               decoration: BoxDecoration(
                                 borderRadius: BorderRadius.circular(30),
                                 color: Colors.grey.shade600.withOpacity(0.6),
                               ),
                             ),
                             Container(
                               height: 40,
                               width: 40,
                               decoration: BoxDecoration(
                                 borderRadius: BorderRadius.circular(30),
                                 color: Colors.grey.shade600.withOpacity(0.6),
                               ),
                             ),
                           ],
                         ),
                       ],
                     ),
                   ),
                 );
               },
             ),
           );
           }*/
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(60)),
              ),
              child: GridView.builder(
                itemCount: 8,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  return Container(
                    height: 200,
                    width: 220,
                    padding:
                        const EdgeInsets.only(left: 15, right: 15, top: 10),
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color:const Color.fromARGB(255, 244, 247, 252),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey.shade700.withOpacity(0.9),
                      highlightColor: Colors.grey.withOpacity(0.4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 140,
                            width: 160,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.grey.shade600.withOpacity(0.6),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 40,
                                width: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.grey.shade600.withOpacity(0.6),
                                ),
                              ),
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.grey.shade600.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
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
                child: Text(
                  'يبدو أنه لا يوجد أي قصص منشوره',
                  style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final stories = snapshot.data!;
          return  SingleChildScrollView(
            child: Container(
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
      child: Column(
      children: [
         Padding(
          padding: const EdgeInsets.only(top: 20,),
          child: Container(
          width: double.infinity, 
    alignment: Alignment.centerRight,
    child: const Text(
            "القصص المنشورة حديثًا",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),),
            Container(
              height: 200, 
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: stories.length, 
                itemBuilder: (context, index) {
                  final pdfData =
                        stories[index].data() as Map<String, dynamic>?;
                    final String title = pdfData?['title'] ?? 'Untitled';
                    final String pdfUrl = pdfData?['url'] ?? '#';
                    final String fimg = pdfData?['imageUrl'] ?? '#';                
                  return  GestureDetector(
        onTap: () {
          Navigator.push(
                     context,
                     MaterialPageRoute(
                     builder: (context) => ViewPDFPage(pdfUrl: pdfUrl, storyTitle: title),
                            )
                          );
        },
        child:  Padding(
                    padding: const EdgeInsets.all(2),
                    child: SizedBox(
                      width: 205,
                      child: AspectRatio(
                        aspectRatio: 0.83,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: <Widget>[
                            ClipPath(
                              clipper: CategoryCustomShape(),
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: Container(
                                  color: kSecondaryColor, 
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[                                                                                
                                      Padding(padding: EdgeInsets.only(top: 100),),
                                      Text(title, style: const TextStyle(fontSize: 20)),
                                      Row(     
                                        mainAxisAlignment: MainAxisAlignment.center,    
                                        children: [                  
                                          IconButton(                      
                                            icon: const Icon(FontAwesomeIcons.shareFromSquare,size: 19,                          
                                            color: Color.fromARGB(255, 5, 0, 58)),                      
                                            onPressed: () => sharePdf(pdfUrl, title, context),                    
                                            ),             
                                          IconButton(                      
                                            icon: const Icon(                        
                                              FontAwesomeIcons.download,size: 19,color: Color.fromARGB(255, 5, 0, 58)                      
                                              ),                      
                                              onPressed: () =>                          
                                              downloadAndSaveFile(pdfUrl, title,context,)                    
                                              ),                
                                        ],              
                                      ),            
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(color: Color.fromARGB(0, 104, 58, 183),        
                            padding: const EdgeInsets.only(left:2, top: 1),        
                            margin: const EdgeInsets.all(1),    
                            child:  Stack(              
                              children: <Widget>[                               
                                Positioned(top: -9,                                 
                                left: 20,                                
                                child:Container(                                      
                                  height: 130,                                      
                                  child: Stack(                                        
                                    children: <Widget>[                                                        
                                      Image.asset(                                           
                                      width: 150,                                             
                                      height: 130,                                            
                                      "assets/under1.png",                                            
                                      fit: BoxFit.cover,                                          
                                      ),                                          
                                      Positioned(                                             
                                        top: 37,                                             
                                        left: 26,                                            
                                        child: ClipRRect(                                                    
                                          borderRadius:                                                        
                                          BorderRadius.circular(8.0),                                     
                                          child: CachedNetworkImage(                                       
                                            imageUrl: fimg,                                                      
                                            width: 101,                                                      
                                            height: 67,                                                      
                                            fit: BoxFit.cover,                                                      
                                            placeholder: (context,url) =>
                                                          Center(child: Lottie.asset('assets/loading.json',width: 200,height: 200)),
                                                      errorWidget: (context,url, error) =>
                                                          Image.asset(                                     
                                                            "assets/errorimg.png", // An error placeholder image                
                                                            width: 45,                                                        
                                                            height: 45,                                                        
                                                            fit: BoxFit.cover,                                                     
                                                          ),
                                                    ),
                                                  )),                                          
                                          Positioned(
                                            top: 69,
                                            right: -3,
                                           child:  Image.asset(
                                              "assets/pdfupper.png",
                                              width: 60,
                                              height: 60,
                                              fit: BoxFit.cover,
                                            ),
                                          ),                                                    
                                        ]        
                                      )        
                                    ),
                                )]))
                          ],
                        ),
                      ),
                    ),
                  ));
                },
              ),
            ),
            SizedBox(height: 5,),
            Divider(height: 5),
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
                 GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(10),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
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
                        final String fimg = pdfData?['imageUrl'] ?? '#';

                  
                        return _buildPdfCard(title, pdfUrl, docId,fimg, index, context);
                      },
                    ),
              
            
              ]),
            ),
          );
        },
      ),

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
    );
  }
}

class CategoryCustomShape extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    double height = size.height;
    double width = size.width;
    double cornerSize = 30;

    path.lineTo(0, height - cornerSize);
    path.quadraticBezierTo(0, height, cornerSize, height);
    path.lineTo(width - cornerSize, height);
    path.quadraticBezierTo(width, height, width, height - cornerSize);
    path.lineTo(width, cornerSize);
    path.quadraticBezierTo(width, 0, width - cornerSize, 0);
    path.lineTo(cornerSize, cornerSize * 0.75);
    path.quadraticBezierTo(0, cornerSize, 0, cornerSize * 2);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

