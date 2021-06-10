import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:utc2_staff/screens/classroom/info_detail_class.dart';
import 'package:utc2_staff/service/firestore/class_database.dart';
import 'package:utc2_staff/service/firestore/teacher_database.dart';
import 'package:utc2_staff/service/pdf/pdf_api.dart';
import 'package:utc2_staff/service/pdf/pdf_class_detail.dart';
import 'package:utc2_staff/utils/utils.dart';

class ReportInfoClass extends StatefulWidget {
  final Teacher teacher;
  final Class classUtc;

  ReportInfoClass({this.teacher, this.classUtc});
  @override
  _ReportInfoClassState createState() => _ReportInfoClassState();
}

class _ReportInfoClassState extends State<ReportInfoClass> {
  ScrollController controller = ScrollController();
  Future<void> _launchInWebViewWithJavaScript(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: true,
        enableJavaScript: true,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          color: ColorApp.lightGrey,
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: ColorApp.black,
          ),
        ),
        elevation: 3,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Xem trước',
          style: TextStyle(color: ColorApp.black),
        ),
        actions: [
          TextButton.icon(
            onPressed: () async {
              final pdfFile = await PdfParagraphApi.generate();
              PdfApi.openFile(pdfFile);
            },
            icon: Image.asset(
              'assets/icons/pdf.png',
              width: 20,
            ),
            label: Text('In báo cáo'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          height: size.height,
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              Container(
                width: size.width,
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: size.width / 2,
                      child: Image.network(
                        'https://utc2.edu.vn/upload/company/logo-15725982242.png',
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          _launchInWebViewWithJavaScript(
                              'https://utc2.edu.vn/');
                        },
                        child: Text('https://utc2.edu.vn/'))
                  ],
                ),
              ),
              Divider(
                height: 3,
                thickness: .2,
                color: ColorApp.black,
              ),
              SizedBox(
                height: 15,
              ),
              Center(
                child: Text(
                  'THÔNG TIN LỚP HỌC',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: InfoDetailClass(
                  teacher: widget.teacher,
                  classUtc: widget.classUtc,
                  controller: controller,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}