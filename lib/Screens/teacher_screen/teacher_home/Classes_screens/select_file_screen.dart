import 'dart:io';
import 'package:collegify/models/user_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../shared/components/constants.dart';

class UploaderImage extends StatefulWidget {
  final String className;
  final PlatformFile platformFile;
  final String semester;
  final String courseName;
  final String moduleName;
  final File file;
  final TeacherModel teacherModel;

  UploaderImage({
    Key key,
    this.file,
    @required this.teacherModel,
    this.className,
    this.semester,
    @required this.courseName,
    @required this.moduleName,
    this.platformFile,
  }) : super(key: key);

  createState() => _UploaderImageState();
}

class _UploaderImageState extends State<UploaderImage> {
  UploadTask _uploadTask;

  _startUpload() {
    String _filePath =
        'Notes/${widget.teacherModel.department}/${widget.courseName}/${widget.semester}/${widget.className}/${widget.moduleName}/Images/${DateTime.now()}';
    if (widget.file != null) {
      try {
        final _storage = FirebaseStorage.instance.ref().child(_filePath);

        setState(() {
          _uploadTask = _storage.putFile(widget.file);
        });
      } catch (e) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_uploadTask != null) {
      return StreamBuilder<TaskSnapshot>(
          stream: _uploadTask.snapshotEvents,
          builder: (context, snapshot) {
            var event = snapshot?.data;

            double progressPercent =
                event != null ? event.bytesTransferred / event.totalBytes : 0;
            if (_uploadTask.snapshot.state == TaskState.success) {
              Fluttertoast.showToast(msg: 'Done');
            }

            return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (_uploadTask.snapshot.state == TaskState.paused)
                    TextButton(
                      child: Icon(Icons.play_arrow, size: 50),
                      onPressed: _uploadTask.resume,
                    ),
                  if (_uploadTask.snapshot.state == TaskState.running) ...[
                    TextButton(
                      child: Icon(Icons.pause, size: 50),
                      onPressed: _uploadTask.pause,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: LinearProgressIndicator(
                        value: progressPercent,
                        backgroundColor: Theme.of(context).colorScheme.secondary,
                        semanticsValue: '${(progressPercent * 100)} % ',
                      ),
                    ),
                  ],
                ]);
          });
    } else {
      return RoundedButton(
        text: 'Upload',
        color: Theme.of(context).colorScheme.secondary,
        onPressed: _startUpload,
        loading: false,
      );
    }
  }
}

class UploaderDocument extends StatefulWidget {
  final String className;

  final String semester;
  final String courseName;
  final String moduleName;
  final File file;
  final TeacherModel teacherModel;

  UploaderDocument({
    Key key,
    @required this.file,
    @required this.teacherModel,
    @required this.className,
    @required this.semester,
    @required this.courseName,
    @required this.moduleName,
  }) : super(key: key);

  createState() => _UploaderDocumentState();
}

class _UploaderDocumentState extends State<UploaderDocument> {
  UploadTask _uploadTask;

  _startUpload() {
    String _filePath =
        'Notes/${widget.teacherModel.department}/${widget.courseName}/${widget.semester}/${widget.className}/${widget.moduleName}/Images/${DateTime.now()}';
    if (widget.file != null) {
      try {
        final _storage = FirebaseStorage.instance.ref().child(_filePath);

        setState(() {
          _uploadTask = _storage.putFile(widget.file);
        });
      } catch (e) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_uploadTask != null) {
      return StreamBuilder<TaskSnapshot>(
          stream: _uploadTask.snapshotEvents,
          builder: (context, snapshot) {
            var event = snapshot?.data;

            double progressPercent =
                event != null ? event.bytesTransferred / event.totalBytes : 0;
            if (_uploadTask.snapshot.state == TaskState.success) {
              Fluttertoast.showToast(msg: 'Done');
            }

            return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // if (_uploadTask.snapshot.state == TaskState.paused)
                  //   TextButton(
                  //     child: Icon(Icons.play_arrow, size: 50),
                  //     onPressed: _uploadTask.resume,
                  //   ),
                  if (_uploadTask.snapshot.state == TaskState.running) ...[
                    // TextButton(
                    //   child: Icon(Icons.pause, size: 50),
                    //   onPressed: _uploadTask.pause,
                    // ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(
                        value: progressPercent,
                        backgroundColor: Theme.of(context).colorScheme.secondary,
                        semanticsValue: '${(progressPercent * 100)} % ',
                      ),
                    ),
                  ],
                ]);
          });
    } else {
      return TextButton(
        onPressed: _startUpload,
        child: HeadingText(
          text: 'Upload',
          color: Theme.of(context).primaryTextTheme.bodyText1.color,
          size: 13.0,
        ),
      );

      // RoundedButton(
      //   text: 'Upload',
      //   color: HexColor(appSecondaryColour),
      //   onPressed: _startUpload,
      //   loading: false,
      // );
    }
  }
}
