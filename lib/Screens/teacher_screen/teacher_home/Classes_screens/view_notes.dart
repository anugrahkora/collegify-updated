import 'dart:io';
import 'package:collegify/Screens/videoPlayer.dart/videoPlayerScreen.dart';
import 'package:collegify/models/user_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../shared/components/constants.dart';
import '../../../../shared/components/loadingWidget.dart';
import '../../../student_screen/student_home/student_notes.dart';
import 'view_image.dart';
import 'view_pdf.dart';

class ViewNotesScreen extends StatefulWidget {
  final TeacherModel teacherModel;
  final String className;
  final String semester;
  final String courseName;
  final String moduleName;

  const ViewNotesScreen({
    Key key,
    @required this.teacherModel,
    @required this.className,
    @required this.semester,
    @required this.courseName,
    @required this.moduleName,
  }) : super(key: key);
  @override
  _ViewNotesScreenState createState() => _ViewNotesScreenState();
}

class _ViewNotesScreenState extends State<ViewNotesScreen> {
  ListResult notesList;
  ListResult docList;

  List<Image> imageList = [];
  FullMetadata fullMetadata;
  String _filePath;

  File _imageFile;
  String _videoFile;
  final picker = ImagePicker();
  File _documentFile;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final PickedFile pickedFile =
          await picker.getImage(source: source) ?? null;
      setState(() {
        _imageFile = File(pickedFile.path) ?? null;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ViewImages(
            imageFile: _imageFile,
            teacherModel: widget.teacherModel,
            className: widget.className,
            semester: widget.semester,
            courseName: widget.courseName,
            moduleName: widget.moduleName,
          ),
        ),
      );
    } catch (e) {
      Fluttertoast.showToast(msg: 'No file selected');
    }
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'jpg',
          'pdf',
        ],
      );

      if (result != null) {
        setState(() {
          _documentFile = File(result.files.single.path);
        });

        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ViewPdf(
                  documentFile: _documentFile,
                  teacherModel: widget.teacherModel,
                  moduleName: widget.moduleName,
                  courseName: widget.courseName,
                  className: widget.className,
                  semester: widget.semester)),
        );
      } else {
        Fluttertoast.showToast(msg: 'No file selected');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'No file selected');
    }
  }

  Future<void> _pickVideo() async {
    try {
      FilePickerResult result = await FilePicker.platform.pickFiles(
        type: FileType.video,
        // allowedExtensions: [

        // ],
      );

      if (result != null) {
        setState(() {
          _videoFile = result.files.single.path;
        });

        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VideoApp(
                file: _videoFile,
              ),
            ));
      } else {
        Fluttertoast.showToast(msg: 'No file selected');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'No file selected');
    }
  }

  /// Remove image

  Future _getImages() async {
    _filePath =
        'Notes/${widget.teacherModel.department}/${widget.courseName}/${widget.semester}/${widget.className}/${widget.moduleName}/Images';

    final _storage = FirebaseStorage.instance.ref().child(_filePath);

    notesList = await _storage.listAll();

    return notesList.items.length;
  }

  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<UserModel>(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                setState(() {});
              })
        ],
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.black54, //change your color here
        ),
        backgroundColor: Colors.white,
        title: Text(
          '${widget.className} ' + widget.moduleName,
          style: GoogleFonts.poppins(
              color: Theme.of(context).primaryTextTheme.bodyText1.color, fontSize: 17.0),
        ),
      ),
      // backgroundColor: HexColor(appPrimaryColour),
      body: SafeArea(
        child: FutureBuilder(
          future: _getImages(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Loader(
                  color: Theme.of(context).primaryColor,
                  size: 34.0,
                  spinnerColor: Theme.of(context).primaryTextTheme.bodyText1.color);
            } else if (snapshot.data == 0) {
              return HeadingText(
                text: 'No notes',
                size: 17.0,
                color: Theme.of(context).primaryTextTheme.bodyText1.color,
              );
            } else if (!snapshot.hasError) {
              return buildListView(size);
            } else if (snapshot.hasError) {
              return HeadingText(
                text: 'Unknown error occured',
                size: 17.0,
                color: Theme.of(context).primaryTextTheme.bodyText1.color,
              );
            }
            return Loader(
                color: Theme.of(context).primaryColor,
                size: 34.0,
                spinnerColor: Colors.black54);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'buttonAddNotes',
        splashColor: HexColor('#99b4bf'),
        hoverElevation: 20,
        elevation: 3.0,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        foregroundColor: Colors.white,
        onPressed: () {
          _openBottomSheet();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _openBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: Color(0xFF737373),
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(10.0),
                        topRight: const Radius.circular(10.0)),
                    color: Theme.of(context).primaryColor,
                ),
                child: types()),
          );
        });
  }

  Row types() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
              icon: Icon(
                Icons.camera_alt,
                size: 30.0,
              ),
              onPressed: () {
                _pickImage(
                  ImageSource.camera,
                );
              }),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
              icon: Icon(
                Icons.photo,
                size: 30.0,
              ),
              onPressed: () {
                _pickImage(
                  ImageSource.gallery,
                );
              }),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
              icon: Icon(
                Icons.picture_as_pdf,
                size: 30.0,
              ),
              onPressed: () {
                _pickFile();
              }),
        ),
      ],
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
              path: _filePath);
        });
  }
}
