import 'dart:async';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart';
import 'package:utc2_staff/service/firestore/class_database.dart';
import 'package:utc2_staff/service/firestore/student_database.dart';
import 'package:utc2_staff/service/firestore/teacher_database.dart';
import 'package:utc2_staff/service/pdf/pdf_api.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';

class PdfParagraphApi {
  static Future<File> generate(
    Teacher teacher,
    Class classUtc,
    List<Student> listStudent,
  ) async {
    final pdf = Document();
    var customFont =
        Font.ttf(await rootBundle.load('font/OpenSans-Regular.ttf'));
    var customFontBold =
        Font.ttf(await rootBundle.load('font/OpenSans-Bold.ttf'));
    final imageSVG = await rootBundle.loadString('assets/images/logoUTC.SVG');
    final imageSVG1 =
        await rootBundle.loadString('assets/images/bannerUTC.svg');

    final List<List<dynamic>> list = [];
    int i = 0;
    for (var item in listStudent) {
      ++i;
      list.add([i, item.id, item.name, item.lop]);
    }

    pdf.addPage(
      MultiPage(
        build: (context) => <Widget>[
          buildCustomHeader(imageSVG1),
          
          SizedBox(height: 0.5 * PdfPageFormat.cm),
          title(customFont),
          buildCustomInfo(customFont, imageSVG, classUtc, teacher),
          title1(customFont),
          Table.fromTextArray(
            headers: ['STT', 'MSV', 'Họ Tên', 'Lớp', 'Điểm TP'],
            data: list,
            border: null,
            cellStyle: TextStyle(
                fontWeight: FontWeight.normal,
                font: customFont,
                color: PdfColors.black),
            headerStyle: TextStyle(
                fontWeight: FontWeight.bold,
                font: customFont,
                color: PdfColors.white),
            headerDecoration: BoxDecoration(color: PdfColors.blue400),
            cellHeight: 30,
            cellAlignments: {
              0: Alignment.center,
              1: Alignment.center,
              2: Alignment.center,
              3: Alignment.center,
              4: Alignment.center,
              5: Alignment.center,
            },
          ),
          Divider(thickness: .5),
          SizedBox(height: 0.5 * PdfPageFormat.cm),
          textCheck(teacher.name, customFont, customFontBold),
        ],
        footer: (context) {
          final text = 'Trang ${context.pageNumber} of ${context.pagesCount}';
          return Container(
            alignment: Alignment.centerRight,
            margin: EdgeInsets.only(top: 1 * PdfPageFormat.cm),
            child: Text(
              text,
              style: TextStyle(color: PdfColors.black),
            ),
          );
        },
      ),
    );
    return PdfApi.saveDocument(name: '${classUtc.name}.pdf', pdf: pdf);
  }

  static Widget buildCustomHeader(String imageSVG1) => Container(
        width: 21 * PdfPageFormat.cm,
        padding: EdgeInsets.only(bottom: 3 * PdfPageFormat.mm),
        decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(width: 3, color: PdfColors.grey200)),
        ),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SvgImage(svg: imageSVG1, width: 200, height: 30),
              buildLink()
            ]),
      );

  static Widget buildCustomInfo(
          Font customFont, String logo, Class classUtc, Teacher teacher) =>
      Container(
        width: 21 * PdfPageFormat.cm,
        padding: EdgeInsets.only(bottom: 3 * PdfPageFormat.mm),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                textInfo(
                    'Giảng viên phụ trách: ', teacher.name ?? '', customFont),
                SizedBox(height: 0.2 * PdfPageFormat.cm),
                textInfo('Email : ', teacher.email ?? '', customFont),
                SizedBox(height: 0.2 * PdfPageFormat.cm),
                textInfo('Tên lớp : ', classUtc.name ?? '', customFont),
                SizedBox(height: 0.2 * PdfPageFormat.cm),
                textInfo('Mã lớp : ', classUtc.id ?? '', customFont),
                SizedBox(height: 0.2 * PdfPageFormat.cm),
                textInfo('Mô tả : ', classUtc.note ?? '', customFont),
                SizedBox(height: 0.2 * PdfPageFormat.cm),
                textInfo(
                    'Ngày tạo : ',
                    DateFormat('HH:mm - dd-MM-yyyy').format(
                            DateFormat("yyyy-MM-dd HH:mm:ss")
                                .parse(classUtc.date)) ??
                        '',
                    customFont),
              ]),
              Column(children: [
                qrCode(logo, classUtc.id),
              ])
            ]),
      );

  static Widget buildLink() => UrlLink(
        destination: 'https://utc2.edu.vn/',
        child: Text(
          'https://utc2.edu.vn/',
          style: TextStyle(
            decoration: TextDecoration.underline,
            color: PdfColors.blue,
          ),
        ),
      );

  static Widget textInfo(String title, String value, Font customFont) =>
      Row(children: [
        Text(
          title,
          style: TextStyle(color: PdfColors.black, font: customFont),
        ),
        Text(
          value,
          style: TextStyle(color: PdfColors.black, font: customFont),
        ),
      ]);

  static Widget textCheck(
    String name,
    Font customFont,
    Font customFontBold,
  ) =>
      Container(
          width: 21 * PdfPageFormat.cm,
          child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(
              'Hồ Chí Minh, ngày ' +
                  DateTime.now().day.toString() +
                  ' tháng ' +
                  DateTime.now().month.toString() +
                  ' năm ' +
                  DateTime.now().year.toString(),
              style: TextStyle(
                color: PdfColors.black,
                font: customFont,
              ),
            ),
            
            SizedBox(height: 0.5 * PdfPageFormat.cm),
            Text(
              'Người xác nhận          ',
              style: TextStyle(
                color: PdfColors.black,
                font: customFont,
              ),
            ),
            SizedBox(height: 1 * PdfPageFormat.cm),
            Text(
              name + '          ',
              style: TextStyle(
                  color: PdfColors.black,
                  font: customFontBold,
                  fontWeight: FontWeight.bold),
            ),
          ]));

  static Widget title(Font customFont) => Container(
        alignment: Alignment.center,
        width: 21 * PdfPageFormat.cm,
        child: Paragraph(
          text: 'Thông tin lớp học'.toUpperCase(),
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, font: customFont),
        ),
      );
  static Widget title1(Font customFont) => Container(
        alignment: Alignment.center,
        width: 21 * PdfPageFormat.cm,
        child: Paragraph(
          text: 'Danh sách sinh viên',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, font: customFont),
        ),
      );

  static Widget qrCode(String logo, String idClass) =>
      Stack(alignment: Alignment.center, children: [
        Container(
          height: 70,
          width: 70,
          child: BarcodeWidget(
            barcode: Barcode.qrCode(),
            data: idClass,
          ),
        ),
        SvgImage(svg: logo, width: 15, height: 15),
      ]);
}
