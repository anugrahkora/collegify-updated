import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collegify/database/databaseService.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../models/user_model.dart';
import '../../../../shared/components/constants.dart';
import '../../../../shared/components/loadingWidget.dart';
import 'create_announcement.dart';

class ViewParentAnnouncement extends StatefulWidget {
  final TeacherModel teacherModel;
  final String semester;
  final String courseName;
  final String className;

  const ViewParentAnnouncement({
    Key key,
    @required this.teacherModel,
    this.semester,
    @required this.courseName,
    @required this.className,
  }) : super(key: key);
  @override
  _ViewParentAnnouncementState createState() => _ViewParentAnnouncementState();
}

class _ViewParentAnnouncementState extends State<ViewParentAnnouncement> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  List<AnnouncementModel> parentAnnouncements = [];
  DocumentSnapshot snapshot;
  final DatabaseService _databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: 'floatingActionButtonParent',
        splashColor: Theme.of(context).colorScheme.secondary,
        hoverElevation: 20,
        elevation: 3.0,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        foregroundColor: Colors.white,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(
              builder: (context) => CreateAnnouncement(
                className: widget.className,
                courseName: widget.courseName,
                teacherModel: widget.teacherModel,
                role: 'Parent',
                semester: widget.semester,
                icon: ImageIcon(
                  AssetImage('assets/icons/iconParent.png'),
                  color: Colors.black54,
                ),
              ),
            ),
          );
        },
      ),
      // backgroundColor: HexColor(appPrimaryColour),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection(college)
              .doc(widget.teacherModel.department)
              .collection('CourseNames')
              .doc('${widget.courseName}')
              .collection('Semester')
              .doc('${widget.semester}')
              .collection('AnnouncementParent')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Loader(
                size: 20.0,
                spinnerColor: Colors.black54,
              );
            }
            if (snapshot.data.docs.length == 0) {
              return HeadingText(
                // fontWeight: FontWeight.w500,
                text: 'No Announcements yet',
                size: 17.0,
                color: Theme.of(context).primaryTextTheme.bodyText1.color,
              );
            }
            List<DecoratedCard> decoratedContainer = [];
            for (int i = 0; i < snapshot.data.docs.length; ++i) {
              DocumentSnapshot documentSnapshot = snapshot.data.docs[i];
              decoratedContainer.add(
                DecoratedCard(
                  child: Column(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            HeadingText(
                              fontWeight: FontWeight.bold,
                              text: documentSnapshot.data()['Title'] ?? '---',
                              size: 17.0,
                              color: Theme.of(context).primaryTextTheme.bodyText1.color,
                            ),
                            HeadingText(
                              fontWeight: FontWeight.w500,
                              text: documentSnapshot.data()['Date'] ?? '---',
                              size: 13.0,
                              color: Theme.of(context).primaryTextTheme.bodyText1.color,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      HeadingText(
                        alignment: Alignment.centerLeft,
                        text: documentSnapshot.data()['Body'] ?? '---',
                        size: 15.0,
                        color: Theme.of(context).primaryTextTheme.bodyText1.color,
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      TextButton(
                        onPressed: () async {
                          await _databaseService.deleteParentAnnouncement(
                              widget.teacherModel.department,
                              widget.courseName,
                              widget.semester,
                              documentSnapshot.id);
                        },
                        child: Text('Delete'),
                      ),
                    ],
                  ),
                  onTap: () {},
                ),
              );
            }
            return Container(
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                child: Column(
                  children: decoratedContainer,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
