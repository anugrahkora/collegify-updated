import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collegify/database/databaseService.dart';
import 'package:collegify/models/user_model.dart';
import 'package:collegify/shared/components/constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateAdminAnnouncement extends StatefulWidget {
  final AdminModel adminModel;

  const CreateAdminAnnouncement({
    Key key,
    @required this.adminModel,
  }) : super(key: key);
  @override
  _CreateAdminAnnouncementState createState() =>
      _CreateAdminAnnouncementState();
}

class _CreateAdminAnnouncementState extends State<CreateAdminAnnouncement> {
  String _title;
  String _body;
  DateTime dateTime = DateTime.now();
  bool _loading = false;
  DatabaseService databaseService = new DatabaseService();
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          title: HeadingText(
        alignment: Alignment.centerLeft,
        text: 'Annoucement',
        color: Theme.of(context).primaryTextTheme.bodyText1.color,
        size: 17.0,
      )),
      // backgroundColor: HexColor(appPrimaryColour),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 0),
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  width: size.width * 0.8,
                  height: size.height * 0.6,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.1),
                          offset: Offset(6, 2),
                          blurRadius: 6.0,
                          spreadRadius: 3.0),
                    ],
                    color: Theme.of(context).primaryColorLight,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formkey,
                      child: Column(
                        children: [
                          TextFormField(
                            validator: (val) =>
                                val.isEmpty ? '* Mandatory' : null,
                            keyboardType: TextInputType.multiline,
                            maxLines: 5,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context)
                                  .primaryTextTheme
                                  .bodyText1
                                  .color,
                            ),
                            onChanged: (val) {
                              _title = val;
                            },
                            decoration: InputDecoration(
                              hintStyle: GoogleFonts.montserrat(
                                  color: Theme.of(context)
                                      .primaryTextTheme
                                      .bodyText1
                                      .color,
                                  fontSize: 16),
                              hintText: 'Subject',
                              border: InputBorder.none,
                            ),
                          ),
                          TextFormField(
                            validator: (val) =>
                                val.isEmpty ? '* Mandatory' : null,
                            keyboardType: TextInputType.multiline,
                            maxLines: 30,
                            style: TextStyle(
                              color: Theme.of(context)
                                  .primaryTextTheme
                                  .bodyText1
                                  .color,
                            ),
                            onChanged: (val) {
                              _body = val;
                            },
                            decoration: InputDecoration(
                              hintStyle: GoogleFonts.montserrat(
                                  color: Theme.of(context)
                                      .primaryTextTheme
                                      .bodyText1
                                      .color,
                                  fontSize: 16),
                              hintText: 'Body',
                              border: InputBorder.none,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                RoundedButton(
                  text: 'Post',
                  color: Theme.of(context).colorScheme.secondary,
                  loading: _loading,
                  onPressed: () async {
                    if (_formkey.currentState.validate()) {
                      try {
                        setState(() {
                          _loading = true;
                        });
                        dynamic result =
                            await databaseService.postAdminAnnouncement(
                                widget.adminModel.name,
                                dateTime.toString(),
                                _title,
                                _body);

                        if (result != null) {
                          Fluttertoast.showToast(msg: 'failed');
                        } else
                          Fluttertoast.showToast(msg: 'Added');
                        Navigator.pop(context);
                      } on FirebaseException catch (e) {
                        Fluttertoast.showToast(msg: e.message);
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
