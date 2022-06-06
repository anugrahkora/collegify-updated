import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collegify/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../shared/components/constants.dart';
import '../../../shared/components/loadingWidget.dart';

class AnnouncementFromTeacher extends StatefulWidget {
  final ParentModel parentModel;
  final StudentModel wardModel;

  const AnnouncementFromTeacher({
    Key key,
    @required this.parentModel,@required this.wardModel,
  }) : super(key: key);
  @override
  _AnnouncementFromTeacherState createState() =>
      _AnnouncementFromTeacherState();
}

class _AnnouncementFromTeacherState extends State<AnnouncementFromTeacher> {
  // StudentModel wardModel;
  // Future _getWardData() async {
  //   DocumentSnapshot doc;
  //   try {
  //     FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  //     await firebaseFirestore
  //         .collection('users')
  //         .where('Registration_Number', isEqualTo: widget.parentModel.regNumber)
  //         .where('Role', isEqualTo: 'student')
  //         .get()
  //         .then(
  //       (value) {
  //         value.docs.forEach((element) {
  //           doc = element;
  //           if (this.mounted)
  //             setState(() {
  //               wardModel = StudentModel(
  //                   name: element.data()['Name'],
  //                   department: element.data()['Department'],
  //                   course: element.data()['Course'],
  //                   semester: element.data()['Semester'],
  //                   regNumber: element.data()['Registration_Number']);
  //             });
  //         });
  //       },
  //     );
  //     return doc;
  //   } catch (e) {
  //     Fluttertoast.showToast(msg: e.toString());
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black54, //change your color here
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColorLight,
        title: HeadingText(
          text: 'Announcements',
          color: Theme.of(context).primaryTextTheme.bodyText1.color,
          size: 17.0,
          alignment: Alignment.centerLeft,
        ),
      ),
      // backgroundColor: HexColor(appPrimaryColour),
      body: SafeArea(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection(college)
                        .doc(widget.wardModel.department)
                        .collection('CourseNames')
                        .doc(widget.wardModel.course)
                        .collection('Semester')
                        .doc(widget.wardModel.semester)
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                HeadingText(
                                  fontWeight: FontWeight.bold,
                                  text:
                                      documentSnapshot.data()['Title'] ?? '---',
                                  size: 17.0,
                                  color: Theme.of(context).primaryTextTheme.bodyText1.color,
                                ),
                                HeadingText(
                                  fontWeight: FontWeight.w500,
                                  text:
                                      documentSnapshot.data()['Date'] ?? '---',
                                  size: 13.0,
                                  color: Theme.of(context).primaryTextTheme.bodyText1.color,
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
                              color: Theme.of(context).primaryTextTheme.bodyText1.color,
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            HeadingText(
                              alignment: Alignment.centerRight,
                              text: '~ ' + documentSnapshot.data()['From'] ??
                                  '---',
                              size: 15.0,
                              color: Theme.of(context).primaryTextTheme.bodyText1.color,
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
