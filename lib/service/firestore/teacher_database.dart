import 'package:cloud_firestore/cloud_firestore.dart';

class TeacherDatabase {
  Future<void> createTeacher(Map<String, String> dataTeacher, String id) async {
  
    await FirebaseFirestore.instance
        .collection('Teacher')
        .doc(id)
        .set(dataTeacher);
  }

  Future<void> deleteTeacher(String id) async {
    await FirebaseFirestore.instance.collection('Teacher').doc(id).delete();
  }

  static Future<bool> isRegister(String email) async {
    var data = await FirebaseFirestore.instance
        .collection('Teacher')
        .where('email', isEqualTo: email)
        .get();
    var list = data.docs.map((e) => Teacher(e)).toList();
    if (list.length > 0) {
      return true;
    } else {
      return false;
    }
  }

  static Future<Teacher> getTeacherData(String email) async {
    List<Teacher> list = [];
    var data = await FirebaseFirestore.instance
        .collection('Teacher')
        .where('email', isEqualTo: email)
        .get();
    list = data.docs.map((e) => Teacher(e)).toList();
    return list[0];
  }

  static Future<void> updateTeacherData(
      String msv, Map<String, String> data) async {
    FirebaseFirestore.instance.collection('Teacher').doc(msv).update(data);
  }

  getListTeachersData() async {
    List<Teacher> list = [];
    var data = await FirebaseFirestore.instance.collection('Teacher').get();
    list = data.docs.map((e) => Teacher(e)).toList();
    return list;
  }
}

class Teacher {
  String id, name, token, email, avatar;

  Teacher(QueryDocumentSnapshot<Map<String, dynamic>> json) {
    this.id = json['id'];
    this.name = json['name'];
    this.token = json['token'];
    this.email = json['email'];
    this.avatar = json['avatar'];
  }
}
