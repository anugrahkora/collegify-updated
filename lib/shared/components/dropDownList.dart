import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

import 'constants.dart';
import 'loadingWidget.dart';

// dropdown list for listing the all the available universities

//dropdown list for listing all departments under selected college

class DropDownListForDepartmentName extends StatefulWidget {
  final String universityName;
  final String collegeName;
  final String selectedDepartmentName;
  final Function onpressed;
  final String hintText;

  DropDownListForDepartmentName(
      {this.collegeName,
      this.onpressed,
      this.selectedDepartmentName,
      this.universityName,
      this.hintText: 'Select your department'});
  @override
  _DropDownListForDepartmentNameState createState() =>
      _DropDownListForDepartmentNameState();
}

class _DropDownListForDepartmentNameState
    extends State<DropDownListForDepartmentName> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      padding: EdgeInsets.symmetric(
        horizontal: 20,
      ),
      width: size.width * 0.8,
      height: 58.0,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).highlightColor, width: 2.0),
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('myCollege').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Loader(
              size: 20.0,
              spinnerColor: Colors.black54,
            );
          }
          List<DropdownMenuItem> departmentName = [];
          for (int i = 0; i < snapshot.data.docs.length; i++) {
            DocumentSnapshot documentSnapshot = snapshot.data.docs[i];
            departmentName.add(
              DropdownMenuItem(
                child: SizedBox(
                  width: size.width * 0.5,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: HeadingText(
                      text: documentSnapshot.id.replaceAll('_', ' '),
                      size: 13,
                      color:
                            Theme.of(context).primaryTextTheme.bodyText1.color
                    ),
                  ),
                ),
                value: "${documentSnapshot.id}",
              ),
            );
          }

          return DropdownButtonHideUnderline(
            child: DropdownButton(
              elevation: 0,
              hint: HeadingText(
                text: widget.hintText,
                size: 13,
                color: Theme.of(context).primaryTextTheme.bodyText1.color,
              ),
              value: widget.selectedDepartmentName,
              items: departmentName,
              onChanged: widget.onpressed,
            ),
          );
        },
      ),
    );
  }
}

//dropdown list for courses under selected department

class DropDownListForCourseNames extends StatefulWidget {
  final String universityName;
  final String collegeName;
  final String departmentName;
  final String selectedCourseName;
  final Function onpressed;
  final String hintText;

  const DropDownListForCourseNames({
    Key key,
    this.universityName,
    this.collegeName,
    this.selectedCourseName,
    this.onpressed,
    this.departmentName,
    this.hintText = "Select your course",
  }) : super(key: key);
  @override
  _DropDownListForCourseNamesState createState() =>
      _DropDownListForCourseNamesState();
}

class _DropDownListForCourseNamesState
    extends State<DropDownListForCourseNames> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15.0),
      padding: EdgeInsets.symmetric(
        horizontal: 20,
      ),
      width: size.width * 0.8,
      height: 58.0,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).highlightColor, width: 2.0),
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('myCollege')
            .doc('${widget.departmentName}')
            .collection('CourseNames')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Loader(
              size: 20.0,
              spinnerColor: Colors.black54,
            );
          }
          List<DropdownMenuItem> courseName = [];

          for (int i = 0; i < snapshot.data.docs.length; i++) {
            DocumentSnapshot documentSnapshot = snapshot.data.docs[i];
            courseName.add(
              DropdownMenuItem(
                child: SizedBox(
                  width: size.width * 0.5,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: HeadingText(
                      text: documentSnapshot.id.replaceAll('_', ' '),
                      size: 13,
                      color: Theme.of(context).primaryTextTheme.bodyText1.color,
                    ),
                  ),
                ),
                value: "${documentSnapshot.id}",
              ),
            );
          }

          return DropdownButtonHideUnderline(
            child: DropdownButton(
              elevation: 16,
              hint: HeadingText(
                text: widget.hintText,
                size: 13,
                color: Theme.of(context).primaryTextTheme.bodyText1.color,
              ),
              value: widget.selectedCourseName,
              items: courseName,
              onChanged: widget.onpressed,
            ),
          );
        },
      ),
    );
  }
}

//this list takes in a list as arguments
class DropDownList extends StatefulWidget {
  final List<String> list;
  final String selectedItem;
  final Function onpressed;

  const DropDownList({Key key, this.list, this.selectedItem, this.onpressed})
      : super(key: key);

  @override
  _DropDownListState createState() => _DropDownListState();
}

class _DropDownListState extends State<DropDownList> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 20,
      ),
      width: size.width * 0.8,
      height: 58.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(29),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          elevation: 16,
          hint: Text("Select year"),
          value: widget.selectedItem,
          items: widget.list.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style:
                    GoogleFonts.montserrat(color: Colors.black54, fontSize: 14),
              ),
            );
          }).toList(),
          onChanged: widget.onpressed,
        ),
      ),
    );
  }
}

//List of years
class DropDownListForYearData extends StatefulWidget {
  final String universityName;
  final String collegeName;
  final String departmentName;
  final String courseName;
  final String selectedYear;
  final Function onpressed;
  final String hintText;
  const DropDownListForYearData(
      {Key key,
      this.universityName,
      this.collegeName,
      this.departmentName,
      this.onpressed,
      this.courseName,
      this.selectedYear,
      this.hintText = "Select Semester"})
      : super(key: key);
  @override
  _DropDownListForYearDataState createState() =>
      _DropDownListForYearDataState();
}

class _DropDownListForYearDataState extends State<DropDownListForYearData> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(top: 15, bottom: 25.0),
      padding: EdgeInsets.symmetric(
        horizontal: 20,
      ),
      width: size.width * 0.8,
      height: 58.0,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).highlightColor, width: 2.0),
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('myCollege')
            .doc("${widget.departmentName}")
            .collection('CourseNames')
            .doc("${widget.courseName}")
            .collection('Semester')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Loader(
              size: 20.0,
              spinnerColor: Colors.black54,
            );
          }
          List<DropdownMenuItem> yearData = [];
          for (int i = 0; i < snapshot.data.docs.length; i++) {
            DocumentSnapshot documentSnapshot = snapshot.data.docs[i];
            yearData.add(
              DropdownMenuItem(
                child: SizedBox(
                  width: size.width * 0.5,
                  child: HeadingText(
                    text: documentSnapshot.id.replaceAll('_', ' '),
                    size: 13,
                    color: Theme.of(context).primaryTextTheme.bodyText1.color,
                  ),
                ),
                value: "${documentSnapshot.id}",
              ),
            );
          }

          return DropdownButtonHideUnderline(
            child: DropdownButton(
              elevation: 16,
              hint: HeadingText(
                text: widget.hintText,
                size: 13,
                color: Theme.of(context).primaryTextTheme.bodyText1.color,
              ),
              value: widget.selectedYear,
              items: yearData,
              onChanged: widget.onpressed,
            ),
          );
        },
      ),
    );
  }
}

class ImageListView extends StatefulWidget {
  @override
  _ImageListViewState createState() => _ImageListViewState();
}

class _ImageListViewState extends State<ImageListView> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
