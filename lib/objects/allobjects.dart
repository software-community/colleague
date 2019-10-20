class Course {
  int id;
  String course_code;
  String course_name;
  int student_count;
  String studentCode;
  String taCode;
  Course(this.id, this.course_code, this.course_name, this.student_count,
      this.studentCode, this.taCode);
}

class Lecture {
  int id;
  int lecture;
  bool present;
  int course_id;
  String code;
  Lecture(this.id, this.lecture, this.present, this.course_id, this.code);
}

class LectureProff {
  int id;
  int course;
  String time;
  String code;
  String type;
  LectureProff(this.id, this.course, this.time, this.code, this.type);
}
