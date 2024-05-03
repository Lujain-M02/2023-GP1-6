import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:your_story/pages/MyStories_page/pdf_methods.dart';
import 'package:your_story/pages/create_story_pages/create_story.dart';
import 'package:your_story/pages/pdf_pages/pdf_view.dart';
import 'package:your_story/style.dart';

class pdfCard_myStories extends StatelessWidget {
  const pdfCard_myStories({
    super.key,
    required this.storyType,
    required this.pdfUrl,
    required this.title,
    required this.docId,
    required this.content,
    required this.status,
    required this.fimg,
    required this.size,
    required this.index,
    required this.userId,
  });

  final String storyType;
  final String pdfUrl;
  final String title;
  final String docId;
  final String content;
  final bool status;
  final String fimg;
  final Size size;
  final int index;
  final String userId;

  void showMoreOptionsBottomSheet(
      BuildContext context,
      String docId,
      String pdfUrl,
      String title,
      String content,
      bool status,
      String storyType,
      String fimg) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Wrap(
              children: <Widget>[
                if (storyType == "drafted") ...[
                  ListTile(
                    leading: const Icon(FontAwesomeIcons.pen),
                    title: const Text('تعديل'),
                    onTap: () {
                      // globalTitle = title;
                      // globalContent = content;
                      // globalId = docId;
                      Navigator.of(context).pop(); // Close the bottom sheet
                      // Navigate to CreateStory with initial values for editing
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateStory(
                            initialTitle: title,
                            initialContent: content,
                            draftID: docId,
                          ),
                        ),
                      );
                    },
                  ),
                  ListTile(
                      leading: const Icon(FontAwesomeIcons.trash),
                      title: const Text('حذف'),
                      onTap: () {
                        Navigator.of(context).pop(); // Close the bottom sheet
                        deleteStory(docId, context, storyType);
                      }),
                ],
                if (storyType == "illustrated") ...[
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: CachedNetworkImage(
                              imageUrl: fimg,
                              width: 180,
                              height: 180,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Center(
                                  child: Lottie.asset('assets/loading.json',
                                      width: 200, height: 200)),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: Text(
                              title,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ]),
                  ),
                  ListTile(
                      leading: const Icon(FontAwesomeIcons.trash),
                      title: const Text('حذف '),
                      onTap: () {
                        Navigator.of(context).pop(); // Close the bottom sheet
                        deleteStory(docId, context, storyType);
                      }),
                  ListTile(
                      leading: const Icon(FontAwesomeIcons.shareFromSquare),
                      title: const Text('مشاركة '),
                      onTap: () {
                        Navigator.of(context).pop(); // Close the bottom sheet
                        sharePdf(pdfUrl, title, context);
                      }),
                  ListTile(
                      leading: const Icon(FontAwesomeIcons.download),
                      title: const Text('تحميل '),
                      onTap: () {
                        Navigator.of(context).pop(); // Close the bottom sheet
                        downloadAndSaveFile(
                          pdfUrl,
                          title,
                          context,
                        );
                      }),
                  ListTile(
                      leading: const Icon(FontAwesomeIcons.globe),
                      title: Text(status ? 'ايقاف نشر القصة' : 'نشر القصة'),
                      onTap: () {
                        Navigator.of(context).pop(); // Close the bottom sheet
                        publishStory(docId, status, context);
                      }),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: kDefaultPadding,
        vertical: kDefaultPadding / 2,
      ),
      height: 140, //140
      child: InkWell(
        onTap: () {
          if (storyType == "illustrated") {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewPDFPage(
                    pdfUrl: pdfUrl,
                    storyTitle: title,
                    userId: userId,
                    docId: docId,
                  ),
                ));
          } else {
            showMoreOptionsBottomSheet(context, docId, pdfUrl, title, content,
                status, storyType, fimg);
          }
        },
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            Container(
              height: 116, //116
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                color: index.isEven ? kBlueColor : kSecondaryColor,
                boxShadow: const [kDefaultShadow],
              ),
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
            ),
            // PDF image
            Positioned(
              top: 0,
              right: 0,
              child: Hero(
                tag: index,
                child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                    height: 140, //140
                    width: 250, //180
                    child: Stack(
                      children: <Widget>[
                        Image.asset(
                          "assets/under.png",
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          top: 20,
                          left: 82,
                          child: fimg != "#"
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: CachedNetworkImage(
                                    imageUrl: fimg,
                                    width: 90,
                                    height: 80,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Center(
                                        child: Lottie.asset(
                                            'assets/loading.json',
                                            width: 200,
                                            height: 200)),
                                    errorWidget: (context, url, error) =>
                                        Image.asset(
                                      "assets/errorimg.png", // An error placeholder image
                                      width: 45,
                                      height: 45,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              : Image.asset(
                                  "assets/draft_under.png", // The asset image to show draft image
                                  width: 90,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Positioned(
                          top: 80,
                          left: 140,
                          child: storyType == "drafted"
                              ? Image.asset(
                                  "assets/draft_upper.png",
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  "assets/pdfupper.png",
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                        )
                      ],
                    )),
              ),
            ),
            // card title and type of PDF
            Positioned(
              bottom: 0,
              left: 0,
              child: SizedBox(
                height: 136,
                width: size.width - 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: kDefaultPadding),
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
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: kDefaultPadding * 0.4,
                            vertical: kDefaultPadding * 0.0007,
                          ),
                          decoration: const BoxDecoration(
                            color: kSecondaryColor,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(22),
                              topRight: Radius.circular(22),
                            ),
                          ),
                          child: Row(
                            children: [
                              if (storyType == "illustrated")
                                Text(
                                  status ? 'منشوره' : 'غير منشوره',
                                  style: Theme.of(context).textTheme.labelLarge,
                                )
                              else
                                Text(
                                  "الخيارات",
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                              IconButton(
                                icon: const Icon(Icons.more_vert,
                                    color: Colors.white),
                                onPressed: () => showMoreOptionsBottomSheet(
                                    context,
                                    docId,
                                    pdfUrl,
                                    title,
                                    content,
                                    status,
                                    storyType,
                                    fimg),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



//published page
class PdfCard_published extends StatelessWidget {

  
   final String title;
    final String pdfUrl;
    final String docId;
    final String fimg;
    final int index;
    final String userId;

const PdfCard_published({
    Key? key,
    required this.title, 
    required this.pdfUrl, 
    required this.docId, 
    required this.fimg,
    required this.index, 
    required this.userId
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ViewPDFPage(pdfUrl: pdfUrl, storyTitle: title,userId:userId,docId: docId,),
            ));
      },
      child: Container(
          padding: const EdgeInsets.only(left: 5, right: 5, top: 10),
          margin: const EdgeInsets.all(0),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 244, 247, 252),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF475269).withOpacity(0.3),
                blurRadius: 5,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Stack(
            children: <Widget>[
              Positioned(
                  right: 0,
                  left: 3,
                  child: Hero(
                    tag: index,
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
                            left:  MediaQuery.of(context).size.width * 0.14,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                imageUrl: fimg,
                                width: 81,
                                height: 100,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Center(
                                    child: Lottie.asset('assets/loading.json',
                                        width: 200, height: 200)),
                                errorWidget: (context, url, error) =>
                                    Image.asset(
                                  "assets/errorimg.png", // An error placeholder image
                                  width: 45,
                                  height: 45,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 81,
                            child: Image.asset(
                              "assets/pdfupper.png",
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          )
                        ],
                      ),
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.only(top: 130),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF475269),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(
                            FontAwesomeIcons.shareFromSquare,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                          onPressed: () => sharePdf(pdfUrl, title, context),
                        ),
                        IconButton(
                          icon: const Icon(
                            FontAwesomeIcons.download,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                          onPressed: () =>
                              downloadAndSaveFile(pdfUrl, title, context),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }
}


class resentCard extends StatelessWidget {
  const resentCard({
    super.key,
    required this.pdfUrl,
    required this.title,
    required this.fimg,
    required this.userId,
    required this.docId,
  });

  final String pdfUrl;
  final String title;
  final String fimg;
  final String userId;
  final String docId;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ViewPDFPage(
                        pdfUrl: pdfUrl,
                        storyTitle: title,
                        userId:userId,
                        docId: docId,),
              ));
        },
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: SizedBox(
            width: 205,
            child: AspectRatio(
              aspectRatio: 0.83,
              child: Stack(
                alignment:
                    Alignment.bottomCenter,
                children: <Widget>[
                  ClipPath(
                    clipper:
                        resentCardStyle(),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                        color: kSecondaryColor,
                        child: Column(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .center,
                          children: <Widget>[
                            const Padding(
                              padding: EdgeInsets
                                  .only(
                                      top: 100),
                            ),
                            Text(title,
                                style:
                                    const TextStyle(
                                        fontSize:
                                            20)),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment
                                      .center,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                      FontAwesomeIcons
                                          .shareFromSquare,
                                      size: 19,
                                      color: Color
                                          .fromARGB(
                                              255,
                                              5,
                                              0,
                                              58)),
                                  onPressed: () =>
                                      sharePdf(
                                          pdfUrl,
                                          title,
                                          context),
                                ),
                                IconButton(
                                    icon: const Icon(
                                        FontAwesomeIcons
                                            .download,
                                        size:
                                            19,
                                        color: Color.fromARGB(
                                            255,
                                            5,
                                            0,
                                            58)),
                                    onPressed: () =>
                                        downloadAndSaveFile(
                                          pdfUrl,
                                          title,
                                          context,
                                        )),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                      color:
                          const Color.fromARGB(
                              0, 104, 58, 183),
                      padding:
                          const EdgeInsets.only(
                              left: 2, top: 1),
                      margin:
                          const EdgeInsets.all(
                              1),
                      child: Stack(
                          children: <Widget>[
                            Positioned(
                              top: -9,
                              left: 20,
                              child: Container(
                                  height: 130,
                                  child: Stack(
                                      children: <Widget>[
                                        Image
                                            .asset(
                                          width:
                                              150,
                                          height:
                                              130,
                                          "assets/under1.png",
                                          fit: BoxFit
                                              .cover,
                                        ),
                                        Positioned(
                                            top:
                                                37,
                                            left:
                                                26,
                                            child:
                                                ClipRRect(
                                              borderRadius: BorderRadius.circular(8.0),
                                              child: CachedNetworkImage(
                                                imageUrl: fimg,
                                                width: 101,
                                                height: 67,
                                                fit: BoxFit.cover,
                                                placeholder: (context, url) => Center(child: Lottie.asset('assets/loading.json', width: 200, height: 200)),
                                                errorWidget: (context, url, error) => Image.asset(
                                                  "assets/errorimg.png", // An error placeholder image
                                                  width: 45,
                                                  height: 45,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            )),
                                        Positioned(
                                          top:
                                              69,
                                          right:
                                              -3,
                                          child:
                                              Image.asset(
                                            "assets/pdfupper.png",
                                            width:
                                                60,
                                            height:
                                                60,
                                            fit:
                                                BoxFit.cover,
                                          ),
                                        ),
                                      ])),
                            )
                          ]))
                ],
              ),
            ),
          ),
        ));
  }
}



class resentCardStyle extends CustomClipper<Path> {
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
