import 'package:cloud_firestore/cloud_firestore.dart';

class ScheduleDatabase {
  Future<void> createSchedule(Map<String, String> dataSchedule,
      String idTeacher, String idSchedule) async {
    await FirebaseFirestore.instance
        .collection('Teacher')
        .doc(idTeacher)
        .collection('Schedule')
        .doc(idSchedule)
        .set(dataSchedule);
  }

  Future<void> createTaskOfSchedule(Map<String, String> dataTaskOfSchedule,
      String idTeacher, String idSchedule, String idTaskOfSchedule) async {
    await FirebaseFirestore.instance
        .collection('Teacher')
        .doc(idTeacher)
        .collection('Schedule')
        .doc(idSchedule)
        .collection('TaskOfSchedule')
        .doc(idTaskOfSchedule)
        .set(dataTaskOfSchedule);
  }

  static Future<void> deleteSchedule(
      String idTeacher, String idSchedule) async {
    await FirebaseFirestore.instance
        .collection('Teacher')
        .doc(idTeacher)
        .collection('Schedule')
        .doc(idSchedule)
        .delete();
  }

  static Future<void> updateSchedule(
      String idTeacher, String idSchedule, Map<String, String> data) async {
    FirebaseFirestore.instance
        .collection('Teacher')
        .doc(idTeacher)
        .collection('Schedule')
        .doc(idSchedule)
        .update(data);
  }

  Future<void> deleteTaskOfSchedule(
      String idTeacher, String idSchedule, String idTaskOfSchedule) async {
    await FirebaseFirestore.instance
        .collection('Teacher')
        .doc(idTeacher)
        .collection('Schedule')
        .doc(idSchedule)
        .collection('TaskOfSchedule')
        .doc(idTaskOfSchedule)
        .delete();
  }

  static getScheduleData(String idTeacher) async {
    List<Schedule> list = [];
    var data = await FirebaseFirestore.instance
        .collection('Teacher')
        .doc(idTeacher)
        .collection('Schedule')
        .get();
    list = data.docs.map((e) => Schedule(e)).toList();
  
    return list;
  }

  static getTaskOfScheduleData(String idTeacher, String idSchedule) async {
    List<TaskOfSchedule> list = [];
    var data = await FirebaseFirestore.instance
        .collection('Teacher')
        .doc(idTeacher)
        .collection('Schedule')
        .doc(idSchedule)
        .collection('TaskOfSchedule')
        .get();
    list = data.docs.map((e) => TaskOfSchedule(e)).toList();

    return list;
  }
}

class Schedule {
  String idSchedule, idTeacher, titleSchedule, timeStart, timeEnd, note;
  Schedule(QueryDocumentSnapshot<Map<String, dynamic>> json) {
    this.idSchedule = json['idSchedule'];
    this.idTeacher = json['idTeacher'];
    this.titleSchedule = json['titleSchedule'];
    this.timeStart = json['timeStart'];
    this.timeEnd = json['timeEnd'];
    this.note = json['note'];
  }
}

class TaskOfSchedule {
  String idSchedule,
      idTask,
      titleSchedule,
      titleTask,
      timeStart,
      timeEnd,
      idRoom,
      note,
      statusAttend;
  TaskOfSchedule(QueryDocumentSnapshot<Map<String, dynamic>> json) {
    this.idSchedule = json['idSchedule'];
    this.idTask = json['idTask'];
    this.titleTask = json['titleTask'];
    this.timeStart = json['timeStart'];
    this.timeEnd = json['timeEnd'];
    this.note = json['note'];
    this.idRoom = json['idRoom'];
    this.statusAttend = json['statusAttend'];
  }
}