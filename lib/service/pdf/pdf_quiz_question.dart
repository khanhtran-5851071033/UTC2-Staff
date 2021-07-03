import 'dart:async';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart';
import 'package:utc2_staff/service/firestore/class_database.dart';
import 'package:utc2_staff/service/firestore/quiz_database.dart';
import 'package:utc2_staff/service/firestore/teacher_database.dart';
import 'package:utc2_staff/service/pdf/pdf_api.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:utc2_staff/utils/utils.dart';

class PdfQuizApi {
  static Future<File> generate(
    Teacher teacher,
    Class classUtc,
    Quiz quiz,
    List<Question> listQuestion,
  ) async {
    final pdf = Document();
    var customFont =
        Font.ttf(await rootBundle.load('font/OpenSans-Regular.ttf'));
    var customFontBold =
        Font.ttf(await rootBundle.load('font/OpenSans-Bold.ttf'));
    final imageSVG = await rootBundle.loadString('assets/images/logoUTC.SVG');
    final imageSVG1 =
        await rootBundle.loadString('assets/images/bannerUTC.svg');

    pdf.addPage(
      MultiPage(
        build: (context) => <Widget>[
          buildCustomHeader(imageSVG1),
          SizedBox(height: 0.5 * PdfPageFormat.cm),
          title(customFont),
          buildCustomInfo(customFont, imageSVG, quiz, teacher),
          Container(
            height: 0.5 * PdfPageFormat.cm,
            width: 18 * PdfPageFormat.cm,
            decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(width: 2, color: PdfColors.grey200)),
            ),
          ),
          SizedBox(height: 0.5 * PdfPageFormat.cm),
          title1(customFont, 'Câu hỏi'),
          Container(
              width: 21 * PdfPageFormat.cm,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: List.generate(
                    listQuestion.length,
                    (index) => Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: 18 * PdfPageFormat.cm,
                                child: Text(
                                  (index + 1).toString() +
                                      '. ' +
                                      listQuestion[index].question,
                                  softWrap: true,
                                  style: TextStyle(
                                    color: PdfColors.black,
                                    fontSize: 14,
                                    font: customFontBold,
                                  ),
                                ),
                              ),
                              SizedBox(height: 0.5 * PdfPageFormat.cm),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 18 * PdfPageFormat.cm,
                                      alignment: Alignment.centerLeft,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 18 * PdfPageFormat.cm,
                                            child: Text(
                                              'A. ' +
                                                  listQuestion[index]
                                                      .answerCorrect,
                                              style: TextStyle(
                                                  color: PdfColors.black,
                                                  fontSize: 14,
                                                  font: customFont),
                                            ),
                                          ),
                                          Container(
                                            width: 18 * PdfPageFormat.cm,
                                            child: Text(
                                              'B. ' +
                                                  listQuestion[index].answer2,
                                              softWrap: true,
                                              style: TextStyle(
                                                  color: PdfColors.black,
                                                  fontSize: 14,
                                                  font: customFont),
                                            ),
                                          ),
                                          Container(
                                            width: 18 * PdfPageFormat.cm,
                                            child: Text(
                                              'C. ' +
                                                  listQuestion[index].answer3,
                                              softWrap: true,
                                              style: TextStyle(
                                                  color: PdfColors.black,
                                                  fontSize: 14,
                                                  font: customFont),
                                            ),
                                          ),
                                          Container(
                                            width: 18 * PdfPageFormat.cm,
                                            child: Text(
                                              'D. ' +
                                                  listQuestion[index].answer4,
                                              softWrap: true,
                                              style: TextStyle(
                                                  color: PdfColors.black,
                                                  fontSize: 14,
                                                  font: customFont),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]),
                              SizedBox(height: 0.5 * PdfPageFormat.cm),
                            ])),
              )),
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
          Font customFont, String logo, Quiz quiz, Teacher teacher) =>
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
                textInfo('Tên bài Test: ', quiz.titleQuiz ?? '', customFont),
                SizedBox(height: 0.2 * PdfPageFormat.cm),
                textInfo('Mã Test: ', quiz.idQuiz ?? '', customFont),
                SizedBox(height: 0.2 * PdfPageFormat.cm),
                textInfo('Thời gian Test: ', quiz.timePlay + ' phút' ?? '',
                    customFont),
                SizedBox(height: 0.2 * PdfPageFormat.cm),
                textInfo('Sô câu hỏi: ', quiz.totalQuestion ?? '', customFont),
                SizedBox(height: 0.2 * PdfPageFormat.cm),
                textInfo(
                    'Ngày in : ',
                    DateFormat('HH:mm - dd-MM-yyyy').format(
                            DateFormat("yyyy-MM-dd HH:mm:ss")
                                .parse(DateTime.now().toString())) ??
                        '',
                    customFont),
              ]),
              Column(children: [
                qrCode(logo, quiz.idQuiz),
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

  static Widget title(Font customFont) => Container(
        alignment: Alignment.center,
        width: 21 * PdfPageFormat.cm,
        child: Paragraph(
          text: 'Thông tin bài Test'.toUpperCase(),
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, font: customFont),
        ),
      );

  static Widget title1(Font customFont, String title) => Container(
        alignment: Alignment.center,
        width: 21 * PdfPageFormat.cm,
        child: Paragraph(
          text: title,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, font: customFont),
        ),
      );

  static Widget qrCode(String logo, String idClass) =>
      Stack(alignment: Alignment.center, children: [
        Container(
          height: 80,
          width: 80,
          child: BarcodeWidget(
            barcode: Barcode.qrCode(),
            data: idClass,
          ),
        ),
        SvgImage(svg: logo, width: 15, height: 15),
      ]);
}
