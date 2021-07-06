import 'dart:io';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:utc2_staff/service/excel/excel_api.dart';
import 'package:utc2_staff/service/firestore/class_database.dart';
import 'package:utc2_staff/service/firestore/post_database.dart';
import 'package:utc2_staff/service/firestore/quiz_database.dart';
import 'package:utc2_staff/service/firestore/student_database.dart';
import 'package:utc2_staff/service/firestore/teacher_database.dart';
import 'package:utc2_staff/service/firestore/test_student_database.dart';
import 'package:utc2_staff/utils/utils.dart';

class ExcelTestApi {
  static Future<File> generate(
      Teacher teacher,
      Class classUtc,
      List<Student> listStudent,
      List<Post> listPost,
      List<Quiz> listQuiz,
      List<StudentTest> listStudentTest) async {
    
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];
    sheet.enableSheetCalculations();
    final Range range2 = sheet.getRangeByName('B1:E1');
    sheet.getRangeByName('B1:E1').merge();
    range2.setText('THÔNG TIN LỚP HỌC');
    range2.cellStyle.hAlign = HAlignType.center;
    range2.cellStyle.vAlign = VAlignType.center;
    range2.cellStyle.bold = true;
    range2.cellStyle.fontSize = 14;
    //thong tin giang vien
    sheet.getRangeByName('B2').setText('GV phụ trách :');
    sheet.getRangeByName('C2').setText(teacher.name);
    sheet.getRangeByName('B3').setText('Email GV :');
    final Hyperlink hyperlink1 = sheet.hyperlinks
        .add(sheet.getRangeByName('C3'), HyperlinkType.url, '${teacher.email}');
    hyperlink1.screenTip = 'Send Mail';
    sheet.getRangeByName('B4').setText('Tên lớp :');
    sheet.getRangeByName('C4').setText(classUtc.name);
    sheet.getRangeByName('B5').setText('Mã lớp :');
    sheet.getRangeByName('C5').setText(classUtc.id);
    sheet.getRangeByName('B6').setText('Mô tả :');
    sheet.getRangeByName('C6').setText(classUtc.note);
    sheet.getRangeByName('B7').setText('Ngày tạo :');
    sheet.getRangeByName('C7').setText(formatTimeAnttend(classUtc.date));
    String image = await Downfile.downloadAndSaveFile(
        'https://api.qrserver.com/v1/create-qr-code/?size=100x100&data=${classUtc.id}',
        classUtc.name);
    final List<int> imageBytes = File(image).readAsBytesSync();
    sheet.pictures.addStream(2, 5, imageBytes);

    //title
    final Range range1 = sheet.getRangeByName('B10:E10');
    sheet.getRangeByName('B10:E10').merge();
    range1.setText('Danh Sách Kiểm Tra');
    range1.cellStyle.hAlign = HAlignType.center;
    range1.cellStyle.vAlign = VAlignType.center;
    range1.cellStyle.bold = true;
    range1.cellStyle.fontSize = 14;

    final Range range3 = sheet.getRangeByName('F12:M100');
    range3.cellStyle.hAlign = HAlignType.center;
    range3.cellStyle.vAlign = VAlignType.center;
    range3.cellStyle.bold = true;

    sheet.getRangeByName('A11:X11').cellStyle = headerStyle(workbook);
    sheet.getRangeByName('B11:X11').columnWidth = 20;
    sheet.getRangeByName('A11').columnWidth = 30;

    //Data
    final List<ExcelDataRow> dataStudent = _buildStudentDataRows(listStudent);
    sheet.importData(dataStudent, 11, 1);
    final List<ExcelDataRow> dataTest =
        _buildTestDataRows(listStudent, listPost, listQuiz, listStudentTest);
    sheet.importData(dataTest, 11, 6);

    String time = formatTime(DateTime.now().toString());
    return ExcelApi.saveDocument(
        name: '${classUtc.name + '_diemtest_'}$time.xlsx', workbook: workbook);
  }

  static Style headerStyle(Workbook workbook) {
    final Style style = workbook.styles.add('Header');
    style.backColor = '#FF5050';
    style.hAlign = HAlignType.center;
    style.vAlign = VAlignType.center;
    style.fontName = 'Times New Roman';
    style.backColorRgb = Colors.lightBlue;
    style.fontColor = '#FFFFFF';

    workbook.styles.addStyle(style);
    return style;
  }
}

List<ExcelDataRow> _buildStudentDataRows(List<Student> listStudent) {
  List<ExcelDataRow> excelDataRows = <ExcelDataRow>[];

  excelDataRows = listStudent.map<ExcelDataRow>((Student student) {
    return ExcelDataRow(cells: <ExcelDataCell>[
      ExcelDataCell(columnHeader: 'Tên sinh viên', value: student.name),
      ExcelDataCell(columnHeader: 'Mã sinh viên', value: student.id),
      ExcelDataCell(
        columnHeader: 'Lớp',
        value: student.lop,
      ),
      ExcelDataCell(
        columnHeader: 'Ngày sinh',
        value: student.birthDate,
      ),
      ExcelDataCell(
        columnHeader: 'Nơi sinh',
        value: student.birthPlace,
      ),
    ]);
  }).toList();

  return excelDataRows;
}

List<ExcelDataRow> _buildTestDataRows(
    List<Student> listStudent,
    List<Post> listPost,
    List<Quiz> listQuiz,
    List<StudentTest> listStudentTest) {
  List<ExcelDataRow> excelDataRows = <ExcelDataRow>[];

  excelDataRows = listStudent.map<ExcelDataRow>((Student dataRow) {
    return ExcelDataRow(
        cells: List.generate(
            listQuiz.length,
            (index) => ExcelDataCell(
                columnHeader: listQuiz[index].titleQuiz,
                value: listStudentTest
                        .where((element) =>
                            element.idStudent == dataRow.id &&
                            element.idQuiz == listPost[index].idQuiz &&
                            element.idPost == listPost[index].id)
                        .isNotEmpty
                    ? listStudentTest
                        .where((element) =>
                            element.idStudent == dataRow.id &&
                            element.idQuiz == listPost[index].idQuiz &&
                            element.idPost == listPost[index].id)
                        .first
                        .score
                    : '0')));
  }).toList();

  return excelDataRows;
}
