import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collegify/Screens/parent_screen/parent_home/paymentHistory.dart';
import 'package:collegify/database/databaseService.dart';
import 'package:collegify/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:json_string/json_string.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../../shared/components/constants.dart';
import '../../../shared/components/dropDownList.dart';

class FeePaymentScreen extends StatefulWidget {
  final ParentModel parentModel;
  final StudentModel wardModel;
  const FeePaymentScreen({
    Key key,
    @required this.parentModel,
    @required this.wardModel,
  }) : super(key: key);
  @override
  _FeePaymentScreenState createState() => _FeePaymentScreenState();
}

class _FeePaymentScreenState extends State<FeePaymentScreen> {
  Razorpay _razorpay;
  JsonString responseJson;
  String _fee;
  String _selectedSemester;
  int _amount;
  bool _loading = false;
  DateTime dateTime = DateTime.now();
  DatabaseService databaseService = new DatabaseService();
 
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
  void initState() {
    super.initState();
  
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_test_6V7AF1ytCpL2VE',
      'amount': _amount * 100 ?? 'Error Loading, try again',
      'name': '$collegeName',
      'description': 'Semester Fee',
      'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  void _handlePaymentSuccess(
    PaymentSuccessResponse response,
  ) async {
    dynamic result = await DatabaseService(uid: widget.parentModel.uid).addPaymentDetails(
        _selectedSemester, _fee, dateTime.toString(), 'Paid');
    if (result == null)
      Fluttertoast.showToast(
          msg: "SUCCESS: " + response.paymentId, timeInSecForIosWeb: 4);
    else
      Fluttertoast.showToast(
          msg: "Error" + response.paymentId, timeInSecForIosWeb: 4);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message,
        timeInSecForIosWeb: 4);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName, timeInSecForIosWeb: 4);
  }

  Future _getFee(String semester) async {
    try {
      await FirebaseFirestore.instance
          .collection(college)
          .doc(widget.wardModel.department)
          .collection('CourseNames')
          .doc(widget.wardModel.course)
          .collection('Semester')
          .doc(semester)
          .get()
          .then((docs) {
        _fee = docs.data()['Fee'];
        _amount = int.parse(_fee);
      });
      return _fee;
    } on FirebaseException catch (e) {
      return e.message;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    // _getFee(widget.documentSnapshot.data()['Semester']);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black54, //change your color here
        ),
        backgroundColor: Theme.of(context).primaryColorLight,
        title: HeadingText(
          alignment: Alignment.topLeft,
          text: 'Fee Payment',
          size: 18.0,
          color: Colors.black54,
        ),
      ),
      // backgroundColor: HexColor(appPrimaryColour),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Center(
              child: DecoratedCard(
                onTap: () {},
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        HeadingText(
                          alignment: Alignment.centerLeft,
                          text: 'You are paying for :',
                          size: 17.0,
                          color: Theme.of(context).primaryTextTheme.bodyText1.color,
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true)
                                  .push(MaterialPageRoute(
                                builder: (context) => PaymentHistoryScreen(
                                  parentModel: widget.parentModel,
                                  wardModel: widget.wardModel,
                                ),
                              ));
                            },
                            child: Text('Your Payments'))
                      ],
                    ),
                    HeadingText(
                      fontWeight: FontWeight.bold,
                      alignment: Alignment.centerLeft,
                      text: '${widget.wardModel.name}',
                      size: 15.0,
                      color: Theme.of(context).primaryTextTheme.bodyText1.color,
                    ),
                    HeadingText(
                      alignment: Alignment.centerLeft,
                      text: '${widget.wardModel.course.replaceAll('_', ' ')}',
                      size: 15.0,
                      color: Theme.of(context).primaryTextTheme.bodyText1.color,
                    ),
                    HeadingText(
                      alignment: Alignment.centerLeft,
                      text: "Semester",
                      size: 15.0,
                      color: Theme.of(context).primaryTextTheme.bodyText1.color,
                    ),
                    DropDownListForYearData(
                      departmentName: widget.wardModel.department,
                      courseName: widget.wardModel.course,
                      selectedYear: _selectedSemester,
                      onpressed: (val) {
                        setState(() {
                          _selectedSemester = val;
                        });
                      },
                    ),
                    FutureBuilder(
                        future: _getFee(_selectedSemester),
                        builder: (context, snapshot) {
                          if (snapshot.hasData)
                            return Column(
                              children: [
                                Text(
                                  ' ₹' + ' ' + snapshot.data,
                                  style: TextStyle(fontSize: 17.0),
                                ),
                                RoundedButton(
                                  loading: _loading,
                                  text: 'Checkout',
                                  color: Theme.of(context).colorScheme.secondary,
                                  onPressed: () {
                                    openCheckout();
                                  },
                                ),
                              ],
                            );

                          return Text('Select Semester');
                        })
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
