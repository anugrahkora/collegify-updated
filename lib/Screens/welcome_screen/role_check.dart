import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collegify/Screens/checkStudentExists/checkStudentExists.dart';
import 'package:collegify/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../LoaderScreen/loader_screen.dart';
import '../admin_screen/admin_navigation.dart';
import '../not_verified.dart/not_verified_screen.dart';
import '../parent_screen/parent_home/parent_navigation_screen.dart';
import '../student_screen/student_home/classes.dart';
import '../teacher_screen/teacher_home/Classes_screens/teacher_Classes.dart';

class RoleCheck extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;
  final String uid;

  const RoleCheck({Key key, @required this.documentSnapshot,@required this.uid}) : super(key: key);
  @override
  _RoleCheckState createState() => _RoleCheckState();
}

class _RoleCheckState extends State<RoleCheck> {
  @override
  Widget build(BuildContext context) {
    if (widget.documentSnapshot.data()['Role'] == 'student') {
      return StudentClassList(
        studentModel: StudentModel(name: widget.documentSnapshot.data()['Name'],
        department: widget.documentSnapshot.data()['Department'],
        course: widget.documentSnapshot.data()['Course'],
        regNumber: widget.documentSnapshot.data()['Registration_Number'],
        semester:  widget.documentSnapshot.data()['Semester'],
        
        
        ),
      );
    } else if (widget.documentSnapshot.data()['Role'] == 'teacher') {
      return TeacherHome(
        teacherModel: TeacherModel(name:widget.documentSnapshot.data()['Name'],
        email: widget.documentSnapshot.data()['Email'],
        department: widget.documentSnapshot.data()['Department']
        
         ),
      );
    } else if (widget.documentSnapshot.data()['Role'] == 'admin') {
      return AdminNavigationScreen(
        adminModel: AdminModel(name:widget.documentSnapshot.data()['Name'] ),
      );
    } else if (widget.documentSnapshot.data()['Role'] == 'notVerified') {
      return NotVerifiedScreen();
    } else if (widget.documentSnapshot.data()['Role'] == 'parent') {
      return ParentNavigationScreen(
        parentModel: ParentModel(
          uid: widget.uid,
          name: widget.documentSnapshot.data()['Name'],
          regNumber: widget.documentSnapshot.data()['Registration_Number'],
        ),
      );
    } else if (widget.documentSnapshot.data()['Role'] == 'checkStudent') {
      return CheckStudentExists(
        parentModel:  ParentModel(
          name: widget.documentSnapshot.data()['Name'],
          regNumber: widget.documentSnapshot.data()['Registration_Number'],
        ),
        uid: widget.documentSnapshot.id
      );
    }
    return LoaderScreen();
  }
}
