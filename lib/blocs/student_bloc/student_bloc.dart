import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:utc2_staff/service/firestore/student_database.dart';

part 'student_event.dart';
part 'student_state.dart';

class StudentBloc extends Bloc<StudentEvent, StudentState> {
  StudentBloc() : super(StudentInitial());
  List<Student> listStudent = [];
  List<StudentOff> listStudentOff = [];
  @override
  Stream<StudentState> mapEventToState(
    StudentEvent event,
  ) async* {
    switch (event.runtimeType) {
     
      case GetListStudentOfClassEvent:
        yield LoadingStudentState();
        listStudentOff =
            await StudentDatabase.getListStudentsOfClass(event.props[0]);

        if (listStudentOff.isNotEmpty) {
          listStudent = await StudentDatabase.getListStudentsData();
          List<Student> newLit = [];
          Student a;
          for (var e in listStudentOff) {
            a = listStudent.where((i) => i.id == e.id).toList().first;
            newLit.add(a);
          }
          yield LoadedStudentState(newLit);
        } else
          yield LoadErrorStudentState('Chưa có sinh viên nào tham gia vào lớp');
        break;
      case GetListStudentEvent:
        yield LoadingStudentState();
        listStudent = await StudentDatabase.getListStudentsData();

        if (listStudent.isNotEmpty)
          yield LoadedStudentState(listStudent);
        else
          yield LoadErrorStudentState('Chưa có sinh viên nào tham gia vào App');
        break;
      case FilterListStudentEvent:
        yield LoadingStudentState();
        String khoa = event.props[0];
        String lop = event.props[1];
        String heDaoTao = event.props[2];
        List<Student> newList = [];
        String none = 'Tất cả';
        try {
          for (int i = 0; i < listStudent.length; i++) {
            //1
            if (heDaoTao != none && khoa == none && lop == none) {
              if (listStudent[i]
                  .heDaoTao
                  .toLowerCase()
                  .contains(heDaoTao.toLowerCase()))
                newList.add(listStudent[i]);
            }
            //2
            else if (heDaoTao == none && khoa != none && lop == none) {
              if (listStudent[i].khoa.trim().split(' ')[1] ==
                  khoa.trim().split(' ')[1]) {
                newList.add(listStudent[i]);
              }
            }
            //3
            else if (heDaoTao == none && khoa == none && lop != none) {
              if (listStudent[i].lop.trim() == lop.trim()) {
                newList.add(listStudent[i]);
              }
            }
            //1 2
            else if (heDaoTao != none && khoa != none && lop == none) {
              if (listStudent[i].khoa.trim().split(' ')[1] ==
                      khoa.trim().split(' ')[1] &&
                  listStudent[i]
                      .heDaoTao
                      .toLowerCase()
                      .contains(heDaoTao.toLowerCase())) {
                newList.add(listStudent[i]);
              }
            }
            //2 3
            else if (heDaoTao == none && khoa != none && lop != none) {
              if (listStudent[i].khoa.trim().split(' ')[1] ==
                      khoa.trim().split(' ')[1] &&
                  listStudent[i].lop.trim() == lop.trim()) {
                newList.add(listStudent[i]);
              }
            } //1 3
            else if (heDaoTao != none && khoa == none && lop != none) {
              if (listStudent[i]
                      .heDaoTao
                      .toLowerCase()
                      .contains(heDaoTao.toLowerCase()) &&
                  listStudent[i].lop.trim() == lop.trim()) {
                newList.add(listStudent[i]);
              }
            } //1 2 3
            else if (heDaoTao != none && khoa != none && lop != none) {
              if (listStudent[i].khoa.trim().split(' ')[1] ==
                      khoa.trim().split(' ')[1] &&
                  listStudent[i].lop.trim() == lop.trim() &&
                  listStudent[i]
                      .heDaoTao
                      .toLowerCase()
                      .contains(heDaoTao.toLowerCase())) {
                newList.add(listStudent[i]);
              }
            } else {
              newList.add(listStudent[i]);
            }
          }
          yield LoadedStudentState(newList);
        } catch (e) {
          yield LoadErrorStudentState(
              'Chưa có sinh viên nào có kết quả phù hợp');
        }
        break;
      default:
    }
  }
}
