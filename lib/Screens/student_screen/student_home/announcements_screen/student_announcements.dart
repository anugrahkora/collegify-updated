import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collegify/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../shared/components/constants.dart';
import '../../../../shared/components/loadingWidget.dart';

class StudentAnnouncements extends StatefulWidget {
  final StudentModel studentModel;
 

  const StudentAnnouncements({
    Key key,
    @required this.studentModel,
  }) : super(key: key);
  @override
  _StudentAnnouncementsState createState() => _StudentAnnouncementsState();
}

class _StudentAnnouncementsState extends State<StudentAnnouncements> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black54),
        backgroundColor: Colors.white,
        title: HeadingText(
          alignment: Alignment.topLeft,
          text: 'Announcements',
          color:Theme.of(context).primaryTextTheme.bodyText1.color,
          size: 17.0,
        ),
      ),
      // backgroundColor: HexColor(appPrimaryColour),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('myCollege')
                  
                  
                  .doc(widget.studentModel.department)
                  .collection('CourseNames')
                  .doc(widget.studentModel.course)
                  .collection('Semester')
                  .doc(widget.studentModel.semester)
                  .collection('AnnouncementStudent')
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
                    // fontWeight: FontWeight.bold,
                    alignment: Alignment.center,
                    text: 'No Announcements',
                    size: 17.0,
                    color:Theme.of(context).primaryTextTheme.bodyText1.color,
                  );
                }
                List<DecoratedCard> decoratedContainer = [];
                for (int i = 0; i < snapshot.data.docs.length; ++i) {
                  DocumentSnapshot documentSnapshot = snapshot.data.docs[i];
                  decoratedContainer.add(
                    DecoratedCard(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              HeadingText(
                                fontWeight: FontWeight.bold,
                                text: documentSnapshot.data()['Title'] ?? '---',
                                size: 17.0,
                                color:Theme.of(context).primaryTextTheme.bodyText1.color,
                              ),
                              HeadingText(
                                fontWeight: FontWeight.w500,
                                text: documentSnapshot.data()['Date'] ?? '---',
                                size: 1.0,
                                color:Theme.of(context).primaryTextTheme.bodyText1.color,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          HeadingText(
                            alignment: Alignment.centerLeft,
                            text: documentSnapshot.data()['Body'] ?? '---',
                            size: 15.0,
                            color:Theme.of(context).primaryTextTheme.bodyText1.color,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: HeadingText(
                              // fontWeight: FontWeight.bold,
                              alignment: Alignment.centerRight,
                              text: '- ' + documentSnapshot.data()['From'],
                              size: 13.0,
                              color:Theme.of(context).primaryTextTheme.bodyText1.color,
                            ),
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
        ),
      ),
    );
  }
}
