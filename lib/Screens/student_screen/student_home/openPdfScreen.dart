import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:collegify/shared/components/loadingWidget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../../../shared/components/constants.dart';

class OpenPDfScreen extends StatefulWidget {
  final String documentFile;
  final String path;
  final String pdfName;
  final String documentPath;
  const OpenPDfScreen(
      {Key key,
      @required this.documentFile,
      @required this.path,
      @required this.pdfName,
      @required this.documentPath})
      : super(key: key);

  @override
  _OpenPDfScreenState createState() => _OpenPDfScreenState();
}

class _OpenPDfScreenState extends State<OpenPDfScreen> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black54),
        backgroundColor: Theme.of(context).primaryColorLight,
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
                await _downloadPdf();
                setState(() {
                  _loading = false;
                });
              })
        ],
      ),
      // body: Container(child: SfPdfViewer.network(widget.documentFile)),
    );
  }

  Future<void> _downloadPdf() async {
    Directory appDocDir = await getExternalStorageDirectory();

    File downloadToFile = File('${appDocDir.path}/${widget.pdfName}.jpg');
    try {
      await firebase_storage.FirebaseStorage.instance
          .ref(widget.path)
          .child(widget.documentPath)
          .writeToFile(downloadToFile);
      Fluttertoast.showToast(msg: 'Downloaded');
      Fluttertoast.showToast(msg: appDocDir.path);
    } on firebase_core.FirebaseException catch (e) {
      Fluttertoast.showToast(msg: e.message.toString());
    }
  }
}
