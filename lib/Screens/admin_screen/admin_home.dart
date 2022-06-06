import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collegify/Screens/admin_screen/build_items.dart';
import 'package:collegify/database/databaseService.dart';
import 'package:collegify/shared/components/loadingWidget.dart';

import 'package:flutter/material.dart';

import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../../authentication/auth_service.dart';
import '../../models/user_model.dart';
import '../../shared/components/constants.dart';

class AdminHome extends StatefulWidget {
  final AdminModel adminModel;

  const AdminHome({Key key, @required this.adminModel}) : super(key: key);
  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  bool loading = false;
  String university;
  String college;
  String department, newDepartment;
  String course, newCourse, newYear;
  String year;

  final AuthService _authService = AuthService();
  final DatabaseService _databaseService = DatabaseService();
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black54, //change your color here
        ),
        backgroundColor: Theme.of(context).primaryColorLight,
        title: HeadingText(
          alignment: Alignment.centerLeft,
          text: 'Admin Page',
          size: 17.0,
          color: Theme.of(context).primaryTextTheme.bodyText1.color,
        ),
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Column(
                children: [
                  // ImageIcon(
                  //   AssetImage('assets/icons/iconTeacherLarge.png'),
                  //   color: Colors.black54,
                  //   size: 90,
                  // ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: HeadingText(
                        text: user.email,
                        size: 15.0,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                // color: HexColor(appPrimaryColour),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: buildDrawerWidgets(user),
            ),
            SizedBox(
              width: size.width,
              height: size.height * 0.4,
              child: Container(child: buildStreamBuilder()),
            ),
            ListTile(
              title: Text('Sign Out'),
              onTap: () async {
                await _authService.signOut();
              },
            ),
          ],
        ),
      ),
      // backgroundColor: HexColor(appPrimaryColour),
      body: SafeArea(
        child: Container(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: BuildItems(
                size: size,
                widget: widget,
              ),
            ),
          ),
        ),
      ),
    );
  }

  StreamBuilder<QuerySnapshot> buildStreamBuilder() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('adminAnnouncement')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Loader(
            color: Theme.of(context).primaryColor,
            size: 20.0,
            spinnerColor: Theme.of(context).primaryTextTheme.bodyText1.color,
          );
        if (snapshot.hasError) {
          return HeadingText(
            color: Colors.black87,
            text: 'Unknown error',
            size: 17,
          );
        } else if (!snapshot.hasData) {
          return HeadingText(
            color: Theme.of(context).primaryTextTheme.bodyText1.color,
            text: 'No data',
            size: 17,
          );
        } else if (snapshot.data.docs.length == 0) {
          return HeadingText(
            color: Theme.of(context).primaryTextTheme.bodyText1.color,
            text: 'No admin Announcements',
            size: 17,
          );
        } else
          return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (BuildContext context, index) {
                return DecoratedCard(
                  onTap: () {},
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          HeadingText(
                            color: Theme.of(context).primaryTextTheme.bodyText1.color,
                            text: snapshot.data.docs[index]['Title'],
                            size: 15,
                          ),
                          HeadingText(
                            color: Theme.of(context).primaryTextTheme.bodyText1.color,
                            text: snapshot.data.docs[index]['Date']
                                .toString()
                                .substring(0, 11),
                            size: 13,
                          ),
                        ],
                      ),
                      HeadingText(
                        alignment: Alignment.topLeft,
                        color: Theme.of(context).primaryTextTheme.bodyText1.color,
                        text: snapshot.data.docs[index]['Body'],
                        size: 13,
                      ),
                      TextButton(
                          onPressed: () async {
                            await _databaseService.deleteAdminAnnouncement(
                                snapshot.data.docs[index]['Date'].toString());
                          },
                          child: Text('Delete'))
                    ],
                  ),
                );
              });
      },
    );
  }

  Widget buildDrawerWidgets(UserModel user) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          child: Column(
            children: [
              HeadingText(
                alignment: Alignment.centerLeft,
                text: widget.adminModel.name ?? '...',
                color: Colors.black54,
                size: 17.0,
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: HeadingText(
                    alignment: Alignment.centerLeft,
                    text: user.email,
                    size: 15.0,
                    color: Colors.black54,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
