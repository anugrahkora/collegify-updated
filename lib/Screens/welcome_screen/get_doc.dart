import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/user_model.dart';
import '../ErrorScreen/error_screen.dart';
import '../SplashScreen/spashScreen.dart';
import 'body.dart';
import 'role_check.dart';

class GetUserDocument extends StatefulWidget {
  const GetUserDocument({
    Key key,
  }) : super(key: key);
  @override
  _GetUserDocumentState createState() => _GetUserDocumentState();
}

class _GetUserDocumentState extends State<GetUserDocument> {
  DocumentSnapshot documentSnapshot;
  String role;

  Future<DocumentSnapshot> _getDocument(String uid) async {
    documentSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .onError((error, stackTrace) {
      return error;
    });

    return documentSnapshot;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);
    return user != null
        ? FutureBuilder(
            future: _getDocument(user.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return SpashScreen();
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData)
                return RoleCheck(
                  uid: user.uid,
                  documentSnapshot: snapshot.data,
                );
              if (snapshot.hasError) return ErrorScreen();
              return SpashScreen();
            })
        : Body();
  }
}
