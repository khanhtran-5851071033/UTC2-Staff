import 'package:cloud_firestore/cloud_firestore.dart';

class TeacherDatabase {
  Future<void> createTeacher(Map<String, String> dataTeacher, String id) async {
    await FirebaseFirestore.instance
        .collection('Teacher')
        .doc(id)
        .set(dataTeacher);
  }

///////////////////////////////////////////////////////////////////////////////
  void attend(String idTeacher, String idSchedule, String idTask,String idAttend,
      String location, String address) {
    var data = {
      'idTaskOfSchedule': idTask.toString(),
      'id': idAttend,
      'status': 'Thành công',
      'dateAttend': DateTime.now().toString(),
      'location': location,
      'address': address,
    };

    FirebaseFirestore.instance
        .collection('Teacher')
        .doc(idTeacher)
        .collection('Schedule')
        .doc(idSchedule.toString())
        .collection('TaskOfSchedule')
        .doc(idTask.toString())
        .collection('TaskAttend')
        .doc(idAttend)
        .update(data);
  }

  void createTeacherAttend(
      String idTeacher, int idSchedule, int idTask, String time) async {
    var idAttend = time;
    var check = await FirebaseFirestore.instance
        .collection('Teacher')
        .doc(idTeacher)
        .collection('Schedule')
        .doc(idSchedule.toString())
        .collection('TaskOfSchedule')
        .doc(idTask.toString())
        .collection('TaskAttend')
        .get();
    var list = check.docs.map((e) => e).toList();

    bool isExist = false;
    for (var item in list) {
      if (item['id'] == idAttend) isExist = true;
    }

    if (!isExist) {
      var data = {
        'idTaskOfSchedule': idTask.toString(),
        'id': idAttend,
        'status': null,
        'dateAttend': null,
        'location': null,
        'address': null,
      };

      FirebaseFirestore.instance
          .collection('Teacher')
          .doc(idTeacher)
          .collection('Schedule')
          .doc(idSchedule.toString())
          .collection('TaskOfSchedule')
          .doc(idTask.toString())
          .collection('TaskAttend')
          .doc(idAttend)
          .set(data);
    }
  }

///////////////////////////////////////////////////////////////////////////////
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
