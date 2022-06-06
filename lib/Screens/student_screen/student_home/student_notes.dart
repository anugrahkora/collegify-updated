import 'package:collegify/models/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
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
        iconTheme: IconThemeData(
          color: Colors.black54, //change your color here
        ),
        backgroundColor: Theme.of(context).primaryColorLight,
        title: HeadingText(
          alignment: Alignment.topLeft,
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

  IconData _getContentIcon(Future<FullMetadata> fullMetadata) {
    fullMetadata.then((value) {
      if (this.mounted)
        setState(() {
          contentType = value.contentType;
        });
    });
    return contentType == 'application/pdf'
        ? Icons.picture_as_pdf
        : Icons.image;
  }

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
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Card(
        child: InkWell(
          splashColor: Theme.of(context).colorScheme.secondary,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    _getContentIcon(widget.metadata),
                    color: Colors.black54,
                  ),
                  HeadingText(
                    text: widget.imageName,
                    size: 15.0,
                    color: Colors.black54,
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

            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      _getContentype(widget.metadata) == 'application/pdf'
                          ? OpenPDfScreen(
                              documentFile: imageUrl,
                              pdfName: widget.imageName,
                              documentPath: widget.imagePath,
                              path: widget.path)
                          : OpenImage(
                              imageUrl: imageUrl,
                              imageName: widget.imageName,
                              imagePath: widget.imagePath,
                              // documentSnapshot: widget.documentSnapshot,
                              path: widget.path,
                            )),
            );
          },
        ),
      ),
    );
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
