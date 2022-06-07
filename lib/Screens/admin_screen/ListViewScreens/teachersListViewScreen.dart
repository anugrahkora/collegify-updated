import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collegify/shared/components/constants.dart';
import 'package:collegify/shared/components/loadingWidget.dart';
import 'package:flutter/material.dart';

class TeacherListViewScreen extends StatefulWidget {
  const TeacherListViewScreen({
    Key key,
  }) : super(key: key);
  @override
  _TeacherListViewScreenState createState() => _TeacherListViewScreenState();
}

class _TeacherListViewScreenState extends State<TeacherListViewScreen> {
  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    return Scaffold(
      // backgroundColor: HexColor(appPrimaryColour),
      appBar: AppBar(
        title: HeadingText(
          alignment: Alignment.centerLeft,
          text: 'Teachers',
          size: 17.0,
          color: Theme.of(context).primaryTextTheme.bodyText1.color,
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('Role', isEqualTo: 'teacher')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Loader(
                color: Theme.of(context).primaryColor,
                size: 30.0,
                spinnerColor: Colors.black54);
          if (snapshot.hasError) {
            return HeadingText(
              text: 'Unknown error occured',
              size: 17.0,
              color: Theme.of(context).primaryTextTheme.bodyText1.color,
            );
          } else if (snapshot.data.docs.length == 0) {
            return HeadingText(
              text: 'No teachers added',
              size: 17.0,
              color: Theme.of(context).primaryTextTheme.bodyText1.color,
            );
          }
          List<DecoratedContainer> decoratedContainer = [];
          for (int i = 0; i < snapshot.data.docs.length; ++i) {
            DocumentSnapshot documentSnapshot = snapshot.data.docs[i];
            decoratedContainer.add(
              DecoratedContainer(
                child: Column(
                  children: [
                    HeadingText(
                      alignment: Alignment.centerLeft,
                      text: documentSnapshot.data()['Name'],
                      size: 15.0,
                      color: Theme.of(context).primaryTextTheme.bodyText1.color,
                    ),
                    HeadingText(
                      alignment: Alignment.centerLeft,
                      text: documentSnapshot
                          .data()['Department']
                          .toString()
                          .replaceAll('_', ' '),
                      size: 13.0,
                      color: Theme.of(context).primaryTextTheme.bodyText1.color,
                    ),
                  ],
                ),
              ),
            );
          }
          return Container(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: decoratedContainer,
              ),
            ),
          );
        },
      ),
    );
  }
}
