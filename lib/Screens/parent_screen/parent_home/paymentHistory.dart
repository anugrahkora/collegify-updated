import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collegify/models/user_model.dart';
import 'package:collegify/shared/components/constants.dart';
import 'package:collegify/shared/components/loadingWidget.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class PaymentHistoryScreen extends StatefulWidget {
  final ParentModel parentModel;
  final StudentModel wardModel;
  const PaymentHistoryScreen(
      {Key key, @required this.parentModel, @required this.wardModel})
      : super(key: key);

  @override
  _PaymentHistoryScreenState createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black54, //change your color here
        ),
        backgroundColor: Theme.of(context).primaryColorLight,
        title: HeadingText(
          alignment: Alignment.topLeft,
          text: 'Payment History',
          size: 18.0,
          color: Colors.black54,
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
                text: 'No data',
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
                            text: 'Semester ' + '${i + 1}',
                            size: 17.0,
                            color: Theme.of(context).primaryTextTheme.bodyText1.color,
                          ),
                          HeadingText(
                            fontWeight: FontWeight.w500,
                            text: documentSnapshot.data()['Fee'] ?? 'Not added',
                            size: 17.0,
                            color: Theme.of(context).primaryTextTheme.bodyText1.color,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5.0,
                      ),

                      StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(widget.parentModel.uid)
                            .collection('Payments')
                            .doc('${i + 1}')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data.exists)
                              return HeadingText(
                                alignment: Alignment.centerLeft,
                                text: snapshot.data['Status'] ?? '--',
                                size: 17.0,
                                color: Colors.greenAccent,
                              );
                            return HeadingText(
                              alignment: Alignment.centerLeft,
                              text: 'Not Paid',
                              size: 17.0,
                              color: Colors.redAccent,
                            );
                          }
                          return HeadingText(
                            alignment: Alignment.centerLeft,
                            text: 'Loading..',
                            size: 17.0,
                            color: Theme.of(context).primaryTextTheme.bodyText1.color,
                          );
                        },
                      ),
                      // HeadingText(
                      //   alignment: Alignment.centerLeft,
                      //   text: documentSnapshot.data()['Fee'] ?? '---',
                      //   size: 17.0,
                      //   color: Theme.of(context).primaryTextTheme.bodyText1.color,
                      // ),
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
