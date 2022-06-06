import 'package:firebase_auth/firebase_auth.dart';
import '../database/databaseService.dart';
import '../models/user_model.dart';

//this class is used for all auth services
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserModel _userFromFirebaseUser(User user) {
    return user != null ? UserModel(uid: user.uid, email: user.email) : null;
  }

  // Stream of user containing the uid
  Stream<UserModel> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

//function to peform signout
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      return e.toString();
    }
  }

//function to login user
  Future loginWithEmailpasswd(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

//function to register user with credentials
  Future studentregisterWithEmailpasswd(
    String department,
    String course,
    String semester,
    String name,
    String regNumber,
    String role,
    String email,
    String password,
  ) async {
    //creates student user
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    User user = userCredential.user;

    await DatabaseService(uid: user.uid)
        .updateStudentData(department, course, name, regNumber, semester, role);

    return _userFromFirebaseUser(user);

    //adds the new user data to the database
  }

//teacher register function
  Future teacherregisterWithEmailpasswd(
    String department,
    String name,
    String email,
    String password,
    String role,
  ) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    User user = userCredential.user;

    await DatabaseService(uid: user.uid)
        .updateTeacherData(department, name, email, role);
    return _userFromFirebaseUser(user);
  }

  Future parentRegisterWithEmailPassword(
      String parentName,
      String registrationNumber,
      String role,
      String email,
      String password) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    User user = userCredential.user;
    await DatabaseService(uid: user.uid)
        .updateParentData(parentName, registrationNumber, role);
  }

  Future adminRegisterWithEmailPassword(
      String name, String email, String password) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    User user = userCredential.user;
    await DatabaseService(uid: user.uid)
        .updateAdminData( name);
  }
}
