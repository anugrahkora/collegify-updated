import 'dart:io';
import 'package:collegify/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../../shared/components/constants.dart';
import 'select_file_screen.dart';

class ViewImages extends StatefulWidget {
  final File imageFile;
  final TeacherModel teacherModel;
  final String moduleName;
  final String courseName;
  final String className;
  final String semester;

  const ViewImages({
    Key key,
    @required this.imageFile,
    @required this.teacherModel,
    @required this.moduleName,
    @required this.courseName,
    @required this.className,
    @required this.semester,
  }) : super(key: key);
  @override
  _ViewImagesState createState() => _ViewImagesState();
}

class _ViewImagesState extends State<ViewImages> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black54),
        backgroundColor: Theme.of(context).primaryColorLight,
        title: HeadingText(
          alignment: Alignment.topLeft,
          text: "Upload Image",
          color: Colors.black54,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            alignment: Alignment.center,
            child: Image.file(
              widget.imageFile,
              width: size.width * 0.8,
              height: size.height * 0.7,
              fit: BoxFit.contain,
            ),
          ),
          UploaderImage(
            file: widget.imageFile,
            teacherModel: widget.teacherModel,
            className: widget.className,
            semester: widget.semester,
            courseName: widget.courseName,
            moduleName: widget.moduleName,
          ),
        ],
      ),
    );
  }
}
