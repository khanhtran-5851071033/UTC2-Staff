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

class ExcelParagraphApi {
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

    //title
    final Range range1 = sheet.getRangeByName('B1:D1');
    sheet.getRangeByName('B1:D1').merge();
    range1.setText('Danh Sách Điểm Kiểm Tra');
    range1.cellStyle.hAlign = HAlignType.center;
    range1.cellStyle.vAlign = VAlignType.center;
    range1.cellStyle.bold = true;
    range1.cellStyle.fontSize = 14;

    sheet.getRangeByName('A2:X2').cellStyle = headerStyle(workbook);
    sheet.getRangeByName('B2:E2').columnWidth = 20;
    sheet.getRangeByName('A2').columnWidth = 30;

    //Data
    final List<ExcelDataRow> dataStudent = _buildStudentDataRows(listStudent);
    sheet.importData(dataStudent, 2, 1);
    final List<ExcelDataRow> dataTest =
        _buildTestDataRows(listStudent, listPost, listQuiz, listStudentTest);
    sheet.importData(dataTest, 2, 6);

    return ExcelApi.saveDocument(
        name: '${classUtc.name}.excel', workbook: workbook);
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
