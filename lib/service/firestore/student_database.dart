import 'package:cloud_firestore/cloud_firestore.dart';

class StudentDatabase {
  Future<void> createStudent(Map<String, String> dataStudent, String id) async {
    await FirebaseFirestore.instance
        .collection('Student')
        .doc(id)
        .set(dataStudent);
  }

  Future<void> deleteStudent(String id) async {
    await FirebaseFirestore.instance.collection('Student').doc(id).delete();
  }

  static Future<bool> isRegister(String email) async {
    var data = await FirebaseFirestore.instance
        .collection('Student')
        .where('email', isEqualTo: email)
        .get();
    var list = data.docs.map((e) => Student(e)).toList();
    if (list.length > 0) {
      return true;
    } else {
      return false;
    }
  }

  static Future<Student> getStudentData(String email) async {
    List<Student> list = [];
    var data = await FirebaseFirestore.instance
        .collection('Student')
        .where('email', isEqualTo: email)
        .get();
    list = data.docs.map((e) => Student(e)).toList();

    return list[0];
  }

  static Future<Student> getStudent(String id) async {
    List<Student> list = [];
    var data = await FirebaseFirestore.instance
        .collection('Student')
        .where('id', isEqualTo: id)
        .get();
    list = data.docs.map((e) => Student(e)).toList();

    return list[0];
  }

  static Future<void> updateStudentData(
      String msv, Map<String, String> data) async {
    FirebaseFirestore.instance.collection('Student').doc(msv).update(data);
  }

  static getListStudentsData() async {
    List<Student> list = [];
    var data = await FirebaseFirestore.instance.collection('Student').get();
    list = data.docs.map((e) => Student(e)).toList();
    return list;
  }

  static getListStudentsOfClass(String idClass) async {
    List<StudentOff> list = [];
    var data = await FirebaseFirestore.instance
        .collection('Class')
        .doc(idClass)
        .collection('Student')
        .get();

    list = data.docs.map((e) => StudentOff(e)).toList();
    return list;
  }

  static getStudentsOfClassOfAttend(String idClass, String idPost) async {
    List<StudentAttend> list = [];
    var data = await FirebaseFirestore.instance
        .collection('Class')
        .doc(idClass)
        .collection('Post')
        .doc(idPost)
        .collection('Student')
        
        .get();
    print(data.docs.length);
    list = data.docs.map((e) => StudentAttend(e)).toList();
    return list;
  }

   static getStudentsOfClassOfAttendOfStudent(String idClass, String idPost,String idStudent) async {
    List<StudentAttend> list = [];
    var data = await FirebaseFirestore.instance
        .collection('Class')
        .doc(idClass)
        .collection('Post')
        .doc(idPost)
        .collection('Student')
        .where('idStudent',isEqualTo: idStudent)
        
        .get();
    print(data.docs.length);
    list = data.docs.map((e) => StudentAttend(e)).toList();
    return list;
  }
}

class StudentAttend {
  String id;
  String idPost;
  String idAttend;
  String address;
  String location;
  String timeAttend;
  String status;
  StudentAttend(QueryDocumentSnapshot<Map<String, dynamic>> json) {
    this.id = json['idStudent'];
    this.address = json['address'];
    this.idPost = json['idPost'];
    this.idAttend = json['idAttend'];
    this.location = json['location'];
    this.timeAttend = json['time'];
    this.status = json['status'];
  }
}

class StudentOff {
  String id;
  StudentOff(QueryDocumentSnapshot<Map<String, dynamic>> json) {
    this.id = json['id'];
  }
}

class Student {
  String id,
      name,
      token,
      email,
      avatar,
      birthDate,
      birthPlace,
      heDaoTao,
      lop,
      khoa;

  Student(QueryDocumentSnapshot<Map<String, dynamic>> json) {
    this.id = json['id'];
    this.name = json['name'];
    this.token = json['token'];
    this.email = json['email'];
    this.avatar = json['avatar'];
    this.birthDate = json['birthDate'];
    this.birthPlace = json['birthPlace'];
    this.heDaoTao = json['heDaoTao'];
    this.lop = json['lop'];
    this.khoa = json['khoa'];
  }
}
