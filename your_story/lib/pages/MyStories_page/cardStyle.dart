
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
                                      Navigator.of(context)
                                          .pop(); // Close the bottom sheet
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
                                      title: const Text('حذف القصة'),
                                      onTap: () {
                                        Navigator.of(context)
                                            .pop(); // Close the bottom sheet
                                        deleteStory(docId, context, storyType);
                                      }),
                                ],
                                if (storyType == "illustrated") ...[
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: CachedNetworkImage(
                                              imageUrl: fimg,
                                              width: 180,
                                              height: 180,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) =>
                                                  Center(
                                                      child: Lottie.asset(
                                                          'assets/loading.json',
                                                          width: 200,
                                                          height: 200)),
                                              errorWidget:
                                                  (context, url, error) =>
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
                                      title: const Text('حذف القصة'),
                                      onTap: () {
                                        Navigator.of(context)
                                            .pop(); // Close the bottom sheet
                                        deleteStory(docId, context, storyType);
                                      }),
                                  ListTile(
                                      leading: const Icon(FontAwesomeIcons.shareFromSquare),
                                      title: const Text('مشاركة القصة'),
                                      onTap: () {
                                        Navigator.of(context)
                                            .pop(); // Close the bottom sheet
                                        sharePdf(pdfUrl, title, context);
                                      }),
                                  ListTile(
                                      leading: const Icon(FontAwesomeIcons.download),
                                      title: const Text('تحميل القصة'),
                                      onTap: () {
                                        Navigator.of(context)
                                            .pop(); // Close the bottom sheet
                                        downloadAndSaveFile(
                                          pdfUrl,
                                          title,
                                          context,
                                        );
                                      }),
                                  ListTile(
                                      leading: const Icon(FontAwesomeIcons.globe),
                                      title: Text(status
                                          ? 'ايقاف نشر القصة'
                                          : 'نشر القصة'),
                                      onTap: () {
                                        Navigator.of(context)
                                            .pop(); // Close the bottom sheet
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
                  ),
                ));
          } else {
            showMoreOptionsBottomSheet(
                context,
                docId,
                pdfUrl,
                title,
                content,
                status,
                storyType,
                fimg);
          }
        },
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            Container(
              height: 116, //116
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                color: index.isEven
                    ? kBlueColor
                    : kSecondaryColor,
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: kDefaultPadding),
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
                                  borderRadius:
                                      BorderRadius.circular(
                                          8.0),
                                  child: CachedNetworkImage(
                                    imageUrl: fimg,
                                    width: 90,
                                    height: 80,
                                    fit: BoxFit.cover,
                                    placeholder: (context,
                                            url) =>
                                        Center(
                                            child: Lottie.asset(
                                                'assets/loading.json',
                                                width: 200,
                                                height:
                                                    200)),
                                    errorWidget: (context,
                                            url, error) =>
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
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
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
                      mainAxisAlignment:
                          MainAxisAlignment.end,
                      children: [
                        Container(
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal:
                                kDefaultPadding * 0.4,
                            vertical:
                                kDefaultPadding * 0.0007,
                          ),
                          decoration: const BoxDecoration(
                            color: kSecondaryColor,
                            borderRadius: BorderRadius.only(
                              bottomLeft:
                                  Radius.circular(22),
                              topRight: Radius.circular(22),
                            ),
                          ),
                          child: Row(
                            children: [
                              if (storyType ==
                                  "illustrated")
                                Text(
                                  status
                                      ? 'منشوره'
                                      : 'غير منشوره',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge,
                                )
                              else
                                Text(
                                  "الخيارات",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge,
                                ),
                              IconButton(
                                icon: const Icon(
                                    Icons.more_vert,
                                    color: Colors.white),
                                onPressed: () =>
                                    showMoreOptionsBottomSheet(
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
