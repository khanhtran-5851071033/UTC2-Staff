import 'dart:io';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:utc2_staff/service/excel/excel_api.dart';
import 'package:utc2_staff/service/firestore/schedule_teacher.dart';
import 'package:utc2_staff/service/firestore/teacher_database.dart';
import 'package:utc2_staff/utils/utils.dart';

class ExcelTeacherAttendApi {
  static Future<File> generate(Teacher teacher, Schedule schedule,
      List<TaskOfSchedule> listTaskOf, List<TaskAttend> listTaskAttend) async {
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
    sheet.getRangeByName('B2').setText('Giảng viên :');
    sheet.getRangeByName('C2').setText(teacher.name);
    sheet.getRangeByName('B3').setText('Email :');
    final Hyperlink hyperlink1 = sheet.hyperlinks
        .add(sheet.getRangeByName('C3'), HyperlinkType.url, '${teacher.email}');
    hyperlink1.screenTip = 'Send Mail';
    sheet.getRangeByName('B4').setText('Tên lớp :');
    sheet.getRangeByName('C4').setText(schedule.titleSchedule);
    sheet.getRangeByName('B5').setText('Mã lớp :');
    sheet.getRangeByName('C5').setText(schedule.idSchedule);
    sheet.getRangeByName('B6').setText('Mô tả :');
    sheet.getRangeByName('C6').setText(schedule.note);
    sheet.getRangeByName('B7').setText('Thời gian :');
    sheet.getRangeByName('C7').setText(formatTimeSche(schedule.timeStart) +
        ' -> ' +
        formatTimeSche(schedule.timeEnd));
    String image = await Downfile.downloadAndSaveFile(
        'https://api.qrserver.com/v1/create-qr-code/?size=70x70&data=${schedule.idSchedule}',
        schedule.titleSchedule);
    final List<int> imageBytes = File(image).readAsBytesSync();
    sheet.pictures.addStream(3, 5, imageBytes);

    //title
    final Range range1 = sheet.getRangeByName('B10:E10');
    sheet.getRangeByName('B10:E10').merge();
    range1.setText('Bảng Điểm Danh');
    range1.cellStyle.hAlign = HAlignType.center;
    range1.cellStyle.vAlign = VAlignType.center;
    range1.cellStyle.bold = true;
    range1.cellStyle.fontSize = 14;

    final Range range3 = sheet.getRangeByName('B12:D50');
    range3.cellStyle.hAlign = HAlignType.center;
    range3.cellStyle.vAlign = VAlignType.center;

    sheet.getRangeByName('B11:D11').cellStyle = headerStyle(workbook);
    sheet.getRangeByName('C11').columnWidth = 20;
    sheet.getRangeByName('D12:D50').cellStyle.fontColor = '#188038';
    sheet.getRangeByName('D12:D50').cellStyle.bold = true;

    //Data
    final List<ExcelDataRow> dataAttend =
        _buildStudentDataRows(listTaskAttend, listTaskOf);
    sheet.importData(dataAttend, 11, 2);

    String time = formatTime(DateTime.now().toString());
    return ExcelApi.saveDocument(
        name: '${teacher.name + '_diemdanh_'}$time.xlsx', workbook: workbook);
  }

  static Style headerStyle(Workbook workbook) {
    final Style style = workbook.styles.add('Header');
    style.backColor = '#FF5050';
    style.hAlign = HAlignType.center;
    style.vAlign = VAlignType.center;
    //style.fontName = 'Times New Roman';
    style.backColorRgb = Colors.lightBlue;
    style.fontColor = '#FFFFFF';

    workbook.styles.addStyle(style);
    return style;
  }
}

List<ExcelDataRow> _buildStudentDataRows(
    List<TaskAttend> listTask, List<TaskOfSchedule> listTaskOfSchedule) {
  List<ExcelDataRow> excelDataRows = <ExcelDataRow>[];

  excelDataRows = listTask.map<ExcelDataRow>((TaskAttend task) {
    return ExcelDataRow(cells: <ExcelDataCell>[
      ExcelDataCell(
          columnHeader: 'Thứ',
          value: listTaskOfSchedule
              .where((element) => element.idTask == task.idTaskOfSchedule)
              .first
              .note),
      ExcelDataCell(columnHeader: 'Ngày', value: formatTimeSche1(task.id)),
      ExcelDataCell(
          columnHeader: 'Trạng thái',
          value: task.status == 'Thành công' ? '✔' : 'x'),
    ]);
  }).toList();

  return excelDataRows;
}
