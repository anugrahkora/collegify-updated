import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AppController extends GetxController {
  Future<DocumentSnapshot> getDocument(String uid) async {
    return await FirebaseFirestore.instance.collection('users').doc(uid).get();
  }

  
}
