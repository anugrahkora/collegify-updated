import 'dart:io';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pinch_zoom/pinch_zoom.dart';
import '../../../shared/components/constants.dart';
import '../../../shared/components/loadingWidget.dart';

class OpenImage extends StatefulWidget {
  final String imageUrl;
  final String imageName;
  final String imagePath;
  // final DocumentSnapshot documentSnapshot;
  final String path;

  const OpenImage(
      {Key key,
      @required this.imageUrl,
      @required this.imageName,
      // @required this.documentSnapshot,
      @required this.path,
      @required this.imagePath})
      : super(key: key);

  @override
  _OpenImageState createState() => _OpenImageState();
}

class _OpenImageState extends State<OpenImage> {
  bool _loading = false;
  // Future<List<Directory>> _externalStorageDirectories;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black54),
        backgroundColor: Theme.of(context).primaryColorLight,
        title: HeadingText(
          alignment: Alignment.topLeft,
          text: widget.imageName,
          color: Colors.black54,
        ),
        actions: [
          IconButton(
              icon: _loading
                  ? Loader(
                      size: 20.0,
                      color: Theme.of(context).primaryColorLight,
                      spinnerColor: Colors.black54,
                    )
                  : Icon(
                      Icons.download_rounded,
                      color: Colors.black54,
                    ),
              onPressed: () async {
                setState(() {
                  _loading = true;
                });
                // await _downloadImageFromUrl(widget.imageUrl);
                await _downloadImage();
                setState(() {
                  _loading = false;
                });
              })
        ],
      ),
      backgroundColor: Colors.black87,
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          child: PinchZoom(
            image: Image.network(
              widget.imageUrl,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes
                        : null,
                  ),
                );
              },
            ),
            zoomedBackgroundColor: Colors.black.withOpacity(0.5),
            resetDuration: const Duration(milliseconds: 100),
            maxScale: 2.5,
          ),
        ),
      ),
    );
  }

  // Future _downloadImageFromUrl(String url) async {
  //   if (await canLaunch(url)) {
  //     await launch(
  //       'https://docs.google.com/gview?embedded=true&url=$url',
  //       forceWebView: true,
  //     );
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  Future<void> _downloadImage() async {
    Directory appDocDir = await getExternalStorageDirectory();

    File downloadToFile = File('${appDocDir.path}/${widget.imageName}.jpg');
    try {
      await firebase_storage.FirebaseStorage.instance
          .ref(widget.path)
          .child(widget.imagePath)
          .writeToFile(downloadToFile);
      Fluttertoast.showToast(msg: 'Downloaded');
      Fluttertoast.showToast(msg: appDocDir.path);
    } on firebase_core.FirebaseException catch (e) {
      Fluttertoast.showToast(msg: e.message.toString());
    }
  }
}
