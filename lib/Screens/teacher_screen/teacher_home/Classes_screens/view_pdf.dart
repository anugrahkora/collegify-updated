import 'dart:io';
import 'package:collegify/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../../shared/components/constants.dart';
import 'select_file_screen.dart';

class ViewPdf extends StatefulWidget {
  final File documentFile;
  final TeacherModel teacherModel;
  final String moduleName;
  final String courseName;
  final String className;
  final String semester;

  const ViewPdf(
      {Key key,
      @required this.documentFile,
      @required this.teacherModel,
      @required this.moduleName,
      @required this.courseName,
      @required this.className,
      @required this.semester})
      : super(key: key);
  @override
  _ViewPdfState createState() => _ViewPdfState();
}

class _ViewPdfState extends State<ViewPdf> {
  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black54),
        backgroundColor: Theme.of(context).primaryColorLight,
        title: HeadingText(
          alignment: Alignment.topLeft,
          text: 'Upload PDF',
          color: Colors.black54,
        ),
        actions: [
          UploaderDocument(
              file: widget.documentFile,
              teacherModel: widget.teacherModel,
              className: widget.className,
              semester: widget.semester,
              courseName: widget.courseName,
              moduleName: widget.moduleName),
        ],
      ),
      // body: Container(child: SfPdfViewer.file(widget.documentFile)),
    );
  }
}
