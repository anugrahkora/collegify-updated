import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collegify/shared/components/constants.dart';
import 'package:firebase_core/firebase_core.dart';

class DatabaseService {
  final String uid;

  DatabaseService({
    this.uid,
  });

  //references of users
  final CollectionReference userCollectionReference =
      FirebaseFirestore.instance.collection('users');
//setting student data
  Future updateStudentData(String department, String course, String name,
      String regNumber, String semester, String role) async {
    return await userCollectionReference.doc(uid).set({
      'Department': department,
      'Course': course,
      'Semester': semester,
      'Name': name,
      'Registration_Number': regNumber,
      'Role': role
    });
  }

  Future updateStudentSemester(
    String studentUID,
    String newSemester,
  ) async {
    return await userCollectionReference.doc(studentUID).update({
      'Semester': newSemester,
    });
  }

  //setting teacher data

  Future updateTeacherData(
      String department, String name, String email, String role) async {
    try {
      return await userCollectionReference.doc(uid).set({
        'Email': email,
        'Department': department,
        'Name': name,
        'Role': role,
      });
    } catch (e) {
      rethrow;
    }
  }

  //setting parent data

  Future updateParentData(
      String parentName, String registrationNumber, String role) async {
    try {
      return await userCollectionReference.doc(uid).set({
        'Uid': uid,
        'Name': parentName,
        'Registration_Number': registrationNumber,
        'Role': role,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future verifyParent(
    String parentUID,
  ) async {
    return await userCollectionReference.doc(parentUID).update({
      'Role': 'parent',
    });
  }

  Future updateAdminData(String name) async {
    return await userCollectionReference.doc(uid).set({
      'Name': name,
      'Role': 'admin',
    });
  }

  Future checkStudentExists(
    String university,
    String college,
    String department,
    String course,
    String semester,
    String registrationNumber,
    String wardName,
  ) async {
    var docReference = await userCollectionReference
        .where('University', isEqualTo: university)
        .where('College', isEqualTo: college)
        .where('Department', isEqualTo: department)
        .where('Course', isEqualTo: course)
        .where('Semester', isEqualTo: semester)
        .where('Registration_Number', isEqualTo: registrationNumber)
        .where('Name', isEqualTo: wardName)
        .get();
    return docReference.docs.isNotEmpty;
  }

  // adding new department

  Future addNewDepartment(String departmentName) async {
    final DocumentReference newDepartmentDocument =
        FirebaseFirestore.instance.collection(college).doc('$departmentName');
    return await newDepartmentDocument.set({"Department": departmentName});
  }

  //add new college under a given university

  Future addNewCourse(String departmentName, String courseName) async {
    final DocumentReference newCourseDocument = FirebaseFirestore.instance
        .collection(college)
        .doc('$departmentName')
        .collection('CourseNames')
        .doc('$courseName');
    return await newCourseDocument.set({"Course": courseName});
  }

  // add new year
  Future addNewYear(
      String departmentName, String courseName, String semester) async {
    final DocumentReference newYearDocument = FirebaseFirestore.instance
        .collection(college)
        .doc('$departmentName')
        .collection('CourseNames')
        .doc('$courseName')
        .collection('Semester')
        .doc('$semester');
    return await newYearDocument.set({"Semester": semester});
  }

  Future addFee(String departmentName, String courseName, String semester,
      String fee) async {
    final DocumentReference newFeeDocument = FirebaseFirestore.instance
        .collection(college)
        .doc('$departmentName')
        .collection('CourseNames')
        .doc('$courseName')
        .collection('Semester')
        .doc('$semester');
    return await newFeeDocument.set({
      'Fee': fee,
    });
  }

  Future postStudentAnnouncement(
      String department,
      String courseName,
      String semester,
      String from,
      String date,
      String title,
      String body) async {
    try {
      final DocumentReference addStudentAnnouncement = FirebaseFirestore
          .instance
          .collection(college)
          .doc(department)
          .collection('CourseNames')
          .doc(courseName)
          .collection('Semester')
          .doc(semester)
          .collection('AnnouncementStudent')
          .doc(date);
      return await addStudentAnnouncement.set({
        'From': from,
        'Title': title,
        'Body': body,
        'Date': date.substring(0, 11),
      });
    } catch (e) {
      rethrow;
    }
  }

  Future deleteStudentAnnouncement(String department, String courseName,
      String semester, String date) async {
    final DocumentReference deleteStudentAnnouncement = FirebaseFirestore
        .instance
        .collection(college)
        .doc(department)
        .collection('CourseNames')
        .doc(courseName)
        .collection('Semester')
        .doc(semester)
        .collection('AnnouncementStudent')
        .doc(date);
    return await deleteStudentAnnouncement.delete();
  }

  Future postParentAnnouncement(
      String department,
      String courseName,
      String semester,
      String from,
      String date,
      String title,
      String body) async {
    try {
      final DocumentReference addStudentAnnouncement = FirebaseFirestore
          .instance
          .collection(college)
          .doc(department)
          .collection('CourseNames')
          .doc(courseName)
          .collection('Semester')
          .doc(semester)
          .collection('AnnouncementParent')
          .doc(date);
      return await addStudentAnnouncement.set({
        'From': from,
        'Title': title,
        'Body': body,
        'Date': date.substring(0, 11),
      });
    } catch (e) {
      rethrow;
    }
  }

  Future deleteParentAnnouncement(String department, String courseName,
      String semester, String date) async {
    final DocumentReference deleteStudentAnnouncement = FirebaseFirestore
        .instance
        .collection(college)
        .doc(department)
        .collection('CourseNames')
        .doc(courseName)
        .collection('Semester')
        .doc(semester)
        .collection('AnnouncementParent')
        .doc(date);
    return await deleteStudentAnnouncement.delete();
  }

  Future postAdminAnnouncement(
      String from, String date, String title, String body) async {
    final DocumentReference addStudentAnnouncement =
        FirebaseFirestore.instance.collection('adminAnnouncement').doc(date);
    return await addStudentAnnouncement.set({
      'From': from,
      'Title': title,
      'Body': body,
      'Date': date,
    });
  }

  Future deleteAdminAnnouncement(String date) async {
    final DocumentReference addStudentAnnouncement =
        FirebaseFirestore.instance.collection('adminAnnouncement').doc(date);
    return await addStudentAnnouncement.delete();
  }

  Future addModule(String departmentName, String courseName, String semester,
      String className, String moduleName, String description) async {
    final DocumentReference newModule = FirebaseFirestore.instance
        .collection(college)
        .doc('$departmentName')
        .collection('CourseNames')
        .doc('$courseName')
        .collection('Semester')
        .doc('$semester')
        .collection('Classes')
        .doc(className)
        .collection('Modules')
        .doc(moduleName);
    return await newModule.set({
      'Module': moduleName,
      'Description': description,
    });
  }

  Future<bool> checkIfModuleExists(String departmentName, String courseName,
      String semester, String className, String moduleName) async {
    // Get reference to Firestore collection
    var collectionRef = FirebaseFirestore.instance
        .collection(college)
        .doc('$departmentName')
        .collection('CourseNames')
        .doc('$courseName')
        .collection('Semester')
        .doc('$semester')
        .collection('Classes')
        .doc(className)
        .collection('Modules');

    var doc = await collectionRef.doc(moduleName).get();
    return doc.exists;
  }

  Future deleteModule(
    String departmentName,
    String courseName,
    String semester,
    String className,
    String moduleName,
  ) async {
    final DocumentReference deleteModule = FirebaseFirestore.instance
        .collection(college)
        .doc(departmentName)
        .collection('CourseNames')
        .doc(courseName)
        .collection('Semester')
        .doc(semester)
        .collection('Classes')
        .doc(className)
        .collection('Modules')
        .doc(moduleName);
    return await deleteModule.delete();
  }

  // assign new class names to teacher
  Future assignClassNames(
      String course, String className, String semester) async {
    final DocumentReference newClassDocument = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('Classes')
        .doc(className);
    return await newClassDocument.set({
      'Course': course,
      'ClassName': className,
      'Semester': semester,
    });
  }

  Future removeAddedClass(
    String departmentName,
    String courseName,
    String className,
    String semester,
    String name,
  ) async {
    try {
      final DocumentReference removeClassDocument = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('Classes')
          .doc(className);
      await removeClassDocument.delete();
      final DocumentReference newClassDocument = FirebaseFirestore.instance
          .collection('myCollege')
          .doc('$departmentName')
          .collection('CourseNames')
          .doc('$courseName')
          .collection('Semester')
          .doc('$semester')
          .collection('Classes')
          .doc(className);
      await newClassDocument.delete();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

//add new class in courses
  Future addNewClass(String departmentName, String courseName, String className,
      String semester, String teacherName) async {
    final DocumentReference newClassDocument = FirebaseFirestore.instance
        .collection('myCollege')
        .doc('$departmentName')
        .collection('CourseNames')
        .doc('$courseName')
        .collection('Semester')
        .doc('$semester')
        .collection('Classes')
        .doc(className);
    return await newClassDocument.set({
      'ClassesName': className,
      'TeacherName': teacherName,
    });
  }
  //verify teachers

  Future verifyTeachers(
    String uid,
  ) async {
    final DocumentReference updateTeacherDocument =
        FirebaseFirestore.instance.collection('users').doc(uid);
    updateTeacherDocument.update({
      'Role': 'teacher',
    });
  }

  //create an array of the student names in the semester document of each courses

  Future markAttendancePresent(
    String departmentName,
    String courseName,
    String className,
    String semester,
    String date,
    String name,
    String rollNumber,
  ) async {
    final DocumentReference markAttendancePresentDocument = FirebaseFirestore
        .instance
        .collection(college)
        .doc(departmentName)
        .collection('CourseNames')
        .doc('$courseName')
        .collection('Semester')
        .doc(semester)
        .collection('Classes')
        .doc(className)
        .collection('Attendance')
        .doc(date);
    await markAttendancePresentDocument.set({'Date': date});

    return await markAttendancePresentDocument
        .collection('Status')
        .doc(rollNumber)
        .set({'Name': name, 'Status': 'Present'});
  }

  Future markAttendanceAbsent(
    String departmentName,
    String courseName,
    String className,
    String semester,
    String date,
    String name,
    String rollNumber,
  ) async {
    final DocumentReference markAttendanceAbsentDocument = FirebaseFirestore
        .instance
        .collection(college)
        .doc(departmentName)
        .collection('CourseNames')
        .doc(courseName)
        .collection('Semester')
        .doc(semester)
        .collection('Classes')
        .doc(className)
        .collection('Attendance')
        .doc(date);
    await markAttendanceAbsentDocument.set({'Date': date});

    return await markAttendanceAbsentDocument
        .collection('Status')
        .doc(rollNumber)
        .set({'Name': name, 'Status': 'Absent'});
  }

  Future addNewExam(
      String departmentName,
      String courseName,
      String className,
      String semester,
      String date,
      String examName,
      String totalMarks,
      String impNotes,
      String fromTime,
      String toTime) async {
    try {
      final DocumentReference createNewExamDocument = FirebaseFirestore.instance
          .collection(college)
          .doc('$departmentName')
          .collection('CourseNames')
          .doc('$courseName')
          .collection('Semester')
          .doc('$semester')
          .collection('Classes')
          .doc(className)
          .collection('Exams')
          .doc(date);
      return await createNewExamDocument.set({
        'ExamName': examName,
        'TotalMarks': totalMarks,
        'Notes': impNotes,
        'From': fromTime,
        'To': toTime,
      });
    } on FirebaseException catch (e) {
      return e.message;
    }
  }

  Future deleteAddedExam(String department, String courseName, String semester,
      String className, String examID,) async {
    final DocumentReference deleteAddedExam = FirebaseFirestore.instance
        .collection(college)
        .doc(department)
        .collection('CourseNames')
        .doc(courseName)
        .collection('Semester')
        .doc(semester)
        .collection('Classes')
        .doc(className)
        .collection('Exams')
        .doc(examID);

    return await deleteAddedExam.delete();
  }

  Future addNewQuestion(
      String departmentName,
      String courseName,
      String className,
      String semester,
      String date,
      String docID,
      String question,
      String mark) async {
    try {
      final DocumentReference createNewExamDocument = FirebaseFirestore.instance
          .collection(college)
          .doc('$departmentName')
          .collection('CourseNames')
          .doc('$courseName')
          .collection('Semester')
          .doc('$semester')
          .collection('Classes')
          .doc(className)
          .collection('Exams')
          .doc(docID)
          .collection('Questions')
          .doc(date);
      return await createNewExamDocument
          .set({'Question': question, 'Mark': mark});
    } on FirebaseException catch (e) {
      return e.message;
    }
  }

  Future deleteAddedQuestion(String department, String courseName,
      String semester, String className, String examID, String date) async {
    final DocumentReference deleteAddedQuestion = FirebaseFirestore.instance
        .collection(college)
        .doc(department)
        .collection('CourseNames')
        .doc(courseName)
        .collection('Semester')
        .doc(semester)
        .collection('Classes')
        .doc(className)
        .collection('Exams')
        .doc(examID)
        .collection('Questions')
        .doc(date);
    return await deleteAddedQuestion.delete();
  }

  Future addNewAnswer(
      String departmentName,
      String courseName,
      String className,
      String semester,
      String examID,
      String questionID,
      String rollNumber,
      String name,
      String answer,
      String date) async {
    try {
      final DocumentReference createNewAnswerDocument = FirebaseFirestore
          .instance
          .collection('myCollege')
          .doc('$departmentName')
          .collection('CourseNames')
          .doc('$courseName')
          .collection('Semester')
          .doc('$semester')
          .collection('Classes')
          .doc(className)
          .collection('Exams')
          .doc(examID)
          .collection('Questions')
          .doc(questionID)
          .collection('Answer')
          .doc(rollNumber);
      return await createNewAnswerDocument.set({
        'Name': name,
        'Date': date,
        'Marks': 'Not assigned',
        'Answer': answer
      });
    } on FirebaseException catch (e) {
      return e.message;
    }
  }

  Future assignMarkToAnswer(
      String departmentName,
      String courseName,
      String className,
      String semester,
      String examID,
      String questionID,
      String rollNumber,
      String mark) async {
    final DocumentReference assignMarkToAnswerDocument = FirebaseFirestore
        .instance
        .collection(college)
        .doc('$departmentName')
        .collection('CourseNames')
        .doc('$courseName')
        .collection('Semester')
        .doc('$semester')
        .collection('Classes')
        .doc(className)
        .collection('Exams')
        .doc(examID)
        .collection('Questions')
        .doc(questionID)
        .collection('Answer')
        .doc(rollNumber);
    return await assignMarkToAnswerDocument.update({
      'Marks': mark,
    });
  }

  Future<bool> checkIfClassDocExists(String uid, String className) async {
    try {
      // Get reference to Firestore collection
      var collectionRef = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('Classes');

      var doc = await collectionRef.doc(className).get();
      return doc.exists;
    } catch (e) {
      throw e;
    }
  }

  Future<bool> checkIfAttendanceDocExists(
      String university,
      String college,
      String department,
      String course,
      String semester,
      String className,
      String date) async {
    try {
      // Get reference to Firestore collection
      var collectionRef = FirebaseFirestore.instance
          .collection('college')
          .doc(university)
          .collection('CollegeNames')
          .doc(college)
          .collection('DepartmentNames')
          .doc(department)
          .collection('CourseNames')
          .doc(course)
          .collection('Semester')
          .doc(semester)
          .collection('Classes')
          .doc(className)
          .collection('Attendance');

      var doc = await collectionRef.doc(date).get();
      return doc.exists;
    } catch (e) {
      throw e;
    }
  }

  Future<bool> checkIfAnswerDocExists(
    String department,
    String course,
    String semester,
    String className,
    String examID,
    String questionID,
    String rollNumber,
  ) async {
    try {
      // Get reference to Firestore collection
      var collectionRef = FirebaseFirestore.instance
          .collection('myCollege')
          .doc(department)
          .collection('CourseNames')
          .doc(course)
          .collection('Semester')
          .doc(semester)
          .collection('Classes')
          .doc(className)
          .collection('Exams')
          .doc(examID)
          .collection('Questions')
          .doc(questionID)
          .collection('Answer');

      var doc = await collectionRef.doc(rollNumber).get();
      return doc.exists;
    } catch (e) {
      throw e;
    }
  }

  Future addPaymentDetails(
      String semester, String amount, String date, String status) async {
    try {
      final DocumentReference addPaymentDetails = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('Payments')
          .doc(semester);

      await addPaymentDetails.set({
        'Amount': amount,
        'Date': date,
        'Status': status,
      });
      return null;
    } catch (e) {
      return e.toString();
    }
  }
}
