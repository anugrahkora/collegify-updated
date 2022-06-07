import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:collegify/models/user_model.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../shared/components/constants.dart';
import '../../../shared/components/loadingWidget.dart';
import 'openImageScreen.dart';
import 'openPdfScreen.dart';

class StudentNotes extends StatefulWidget {
  final String className;
  final String courseName;
  final String moduleName;
  final StudentModel studentModel;

  const StudentNotes({
    Key key,
    @required this.className,
    @required this.studentModel,
    @required this.courseName,
    @required this.moduleName,
  }) : super(key: key);

  @override
  _StudentNotesState createState() => _StudentNotesState();
}

class _StudentNotesState extends State<StudentNotes> {
  // String _notes = 'Notes';
  ListResult notesList;
  ListResult imageList;
  ListResult pdfList;
  FullMetadata fullMetadata;
  String _imagePath;

  bool noData = false;

  Future _getImages() async {
    _imagePath =
        'Notes/${widget.studentModel.department}/${widget.studentModel.course}/${widget.studentModel.semester}/${widget.className}/${widget.moduleName}/Images';

    final _imageStorage = FirebaseStorage.instance.ref().child(_imagePath);

    notesList = await _imageStorage.listAll();

    return notesList.items.length;
  }

  // Future<ListResult> listresult;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: HeadingText(
          text: widget.className + '   Module  ' + widget.moduleName,
          color: Theme.of(context).primaryTextTheme.bodyText1.color,
          size: 17.0,
        ),
      ),
      // backgroundColor: HexColor(appPrimaryColour),
      body: SafeArea(
        child: FutureBuilder(
          future: _getImages(),
          builder: (context, snapshot) {
            if (snapshot.data == 0)
              return HeadingText(
                text: 'No notes have been added',
                color: Theme.of(context).primaryTextTheme.bodyText1.color,
                size: 17.0,
              );
            if (snapshot.hasData) {
              return buildListView(size);
            } else if (snapshot.hasError) {
              return HeadingText(
                text: 'Unknown Error occured',
                color: Theme.of(context).primaryTextTheme.bodyText1.color,
                size: 17.0,
              );
            } else
              return Loader(
                size: 20.0,
                color: Theme.of(context).primaryColor,
                spinnerColor: Colors.black87,
              );
          },
        ),
      ),
    );
  }

  ListView buildListView(Size size) {
    return ListView.builder(
        itemCount: notesList.items.length,
        itemBuilder: (BuildContext context, index) {
          return ViewNotes(
              metadata: notesList.items[index].getMetadata(),
              imageName: notesList.items[index].name.substring(0, 16),
              imageUrl: notesList.items[index].getDownloadURL(),
              imagePath: notesList.items[index].name,
              // documentSnapshot: widget.documentSnapshot,
              path: _imagePath);
        });
  }
}

class ViewNotes extends StatefulWidget {
  final Future<FullMetadata> metadata;
  final String imageName;
  final Future<String> imageUrl;
  final String imagePath;
  // final DocumentSnapshot documentSnapshot;
  final String path;

  const ViewNotes({
    Key key,
    @required this.imageName,
    @required this.imageUrl,
    @required this.imagePath,
    // @required this.documentSnapshot,
    @required this.path,
    this.metadata,
  }) : super(key: key);
  @override
  _ViewNotesState createState() => _ViewNotesState();
}

class _ViewNotesState extends State<ViewNotes> {
  bool _loading = false;
  String contentType;

  // IconData _getContentIcon(Future<FullMetadata> fullMetadata) {
  //   fullMetadata.then((value) {
  //     if (this.mounted)
  //       setState(() {
  //         contentType = value.contentType;
  //       });
  //   });
  //   return contentType == 'application/pdf'
  //       ? Icons.picture_as_pdf
  //       : Icons.image;
  // }

  _getContentype(Future<FullMetadata> fullMetadata) {
    fullMetadata.then((value) {
      if (this.mounted)
        setState(() {
          contentType = value.contentType;
        });
    });
    return contentType;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
      child: Card(
        color: Theme.of(context).primaryColorLight,
        child: InkWell(
          splashColor: Theme.of(context).colorScheme.secondary,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.15,
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5.0),
                      child: FutureBuilder(
                          future: widget.imageUrl,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              if (_getContentype(widget.metadata) ==
                                  'application/pdf')
                                return CachedNetworkImage(
                                  placeholder: (context, url) => placeholder(),
                                  fit: BoxFit.cover,
                                  imageUrl:
                                      "https://d1qwl4ymp6qhug.cloudfront.net/blog-media/imported/b35884fc226ea0bc7ffffba816b3b115",
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                );
                              else if (_getContentype(widget.metadata) ==
                                  'image/jpeg')
                                return CachedNetworkImage(
                                  imageUrl: snapshot.data,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => placeholder(),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                );
                              return placeholder();
                            }
                            return placeholder();
                          }),
                    ),
                  ),
                  SizedBox(
                    height: 3.0,
                  ),
                  // Icon(
                  //   _getContentIcon(widget.metadata),
                  //   color: Colors.black54,
                  // ),
                  Row(
                    children: [
                      HeadingText(
                        text: "Uploaded on  ",
                        size: 15.0,
                        fontWeight: FontWeight.bold,
                        color:
                            Theme.of(context).primaryTextTheme.bodyText1.color,
                      ),
                      HeadingText(
                        text: widget.imageName,
                        size: 15.0,
                        color:
                            Theme.of(context).primaryTextTheme.bodyText1.color,
                      ),
                    ],
                  ),

                  Container(
                      child: _loading
                          ? Loader(
                              size: 20.0,
                              color: Theme.of(context).primaryColorLight,
                              spinnerColor: Colors.black87,
                            )
                          : SizedBox(
                              width: 20.0,
                            )),
                ]),
          ),
          onTap: () async {
            setState(() {
              _loading = true;
            });
            String imageUrl = await widget.imageUrl;
            setState(() {
              _loading = false;
            });
            // print(_getContentype(widget.metadata));

            // await _openPDF(imageUrl);
            await openFile(imageUrl, widget.imageName);
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //       builder: (context) =>
            //           _getContentype(widget.metadata) == 'application/pdf'
            //               ? OpenPDfScreen(
            //                   documentFile: imageUrl,
            //                   pdfName: widget.imageName,
            //                   documentPath: widget.imagePath,
            //                   path: widget.path)
            //               : OpenImage(
            //                   imageUrl: imageUrl,
            //                   imageName: widget.imageName,
            //                   imagePath: widget.imagePath,
            //                   // documentSnapshot: widget.documentSnapshot,
            //                   path: widget.path,
            //                 )),
            // );
          },
        ),
      ),
    );
  }

  placeholder() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[100],
      enabled: true,
      child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          height: 100.0,
          width: double.infinity),
    );
  }

  Future openFile(String url, String fileName) async {
    final file = await downloadFile(url, fileName);
    if (file == null) return;

    OpenFile.open(file.path);
  }

  Future<File> downloadFile(String url, String name) async {
    final appStorage = await getApplicationDocumentsDirectory();
    final file = File('${appStorage.path}/$name');
    try {
      final res = await Dio().get(url,
          options: Options(
              responseType: ResponseType.bytes,
              followRedirects: false,
              receiveTimeout: 0));

      final raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(res.data);
      await raf.close();
      return file;
    } catch (e) {
      return null;
    }
  }

  // Future _openPDF(String url) async {
  //   if (await canLaunch(url)) {
  //     await launch(
  //       '$url',
  //       // forceWebView: true,
  //     );
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }
}
