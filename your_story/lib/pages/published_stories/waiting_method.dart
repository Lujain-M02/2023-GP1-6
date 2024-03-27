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


import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class waiting_page extends StatelessWidget {
  const waiting_page({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 244, 247, 252),
        borderRadius:
            BorderRadius.only(topLeft: Radius.circular(60)),
      ),
      child: GridView.builder(
        itemCount: 8,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
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
              color: const Color.fromARGB(255, 244, 247, 252),
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
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 40,
                        width: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color:
                              Colors.grey.shade600.withOpacity(0.6),
                        ),
                      ),
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color:
                              Colors.grey.shade600.withOpacity(0.6),
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
}

