class UserModel {
  final String uid;
  final String email;

  UserModel({this.email, this.uid});
}

class StudentModel {
  final String name;
  final String regNumber;
  final String department;
  final String course;
  final String semester;

  StudentModel(
      {this.department, this.course, this.semester, this.regNumber, this.name});
}

class TeacherModel {
  final String name;
  final String department;
  final String email;

  TeacherModel({this.name, this.department, this.email});
}

class ParentModel {
  final String name;
  final String regNumber;
  final String uid;

  ParentModel({
    this.name,
    this.regNumber,
    this.uid,
  });
}

class AdminModel {
  final String name;

  AdminModel({ this.name});
}

class AnnouncementModel {
  final String subject;
  final String announcement;

  AnnouncementModel({this.subject, this.announcement});
}

class AttendanceStatusModel {
  final String name;
  final String status;
  AttendanceStatusModel({this.name, this.status});
}

class TeacherVerificationModel {
  final String name;
  final String role;

  TeacherVerificationModel({this.name, this.role});
}
