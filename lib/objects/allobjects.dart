class Course {
  int id;
  String course_code;
  String course_name;
  int student_count;
  Course(this.id, this.course_code, this.course_name, this.student_count);
}

class Lecture {
  int id;
  int lecture;
  bool present;
  int course_id;
  String code;
  Lecture(this.id, this.lecture, this.present, this.course_id, this.code);
}