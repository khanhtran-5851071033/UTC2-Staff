import 'package:flutter/material.dart';
import 'package:utc2_staff/service/pdf/pdf_api.dart';
import 'package:utc2_staff/service/pdf/pdf_class_detail.dart';
import 'package:utc2_staff/utils/utils.dart';

class NewQuiz extends StatefulWidget {
  @override
  _NewQuizState createState() => _NewQuizState();
}

class _NewQuizState extends State<NewQuiz> {
  final _formKey = GlobalKey<FormState>();
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
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            'Bài tập mới',
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
                label: Text('Tải xuống'))
          ],
        ),
        body: Container(
          child: Container(
            height: size.height / 2,
            padding: EdgeInsets.symmetric(
                vertical: size.width * 0.03, horizontal: size.width * 0.03),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextFormField(
                    validator: (val) => val.isEmpty ? 'Nhập câu hỏi' : null,
                    onChanged: (value) {},
                    autofocus: true,
                    style: TextStyle(fontSize: 20, color: ColorApp.mediumBlue),
                    decoration: InputDecoration(
                        // border: InputBorder.none,
                        isCollapsed: true,
                        hintText: 'Câu hỏi 1',
                        hintStyle:
                            TextStyle(fontSize: 16, color: ColorApp.black)),
                  ),
                  TextFormField(
                    validator: (val) =>
                        val.isEmpty ? 'Nhập câu trả lời đúng' : null,
                    onChanged: (value) {},
                    style: TextStyle(fontSize: 20, color: ColorApp.mediumBlue),
                    decoration: InputDecoration(
                        // border: InputBorder.none,
                        isCollapsed: true,
                        hintText: 'A --> Đán áp đúng',
                        hintStyle:
                            TextStyle(fontSize: 16, color: ColorApp.black)),
                  ),
                  TextFormField(
                    validator: (val) =>
                        val.isEmpty ? 'Nhập ít nhất 1 câu trả lời sai' : null,
                    onChanged: (value) {},
                    style: TextStyle(fontSize: 20, color: ColorApp.mediumBlue),
                    decoration: InputDecoration(
                        // border: InputBorder.none,
                        isCollapsed: true,
                        hintText: 'B',
                        hintStyle:
                            TextStyle(fontSize: 16, color: ColorApp.black)),
                  ),
                  TextFormField(
                    onChanged: (value) {},
                    style: TextStyle(fontSize: 20, color: ColorApp.mediumBlue),
                    decoration: InputDecoration(
                        // border: InputBorder.none,
                        isCollapsed: true,
                        hintText: 'C',
                        hintStyle:
                            TextStyle(fontSize: 16, color: ColorApp.black)),
                  ),
                  TextFormField(
                    onChanged: (value) {},
                    style: TextStyle(fontSize: 20, color: ColorApp.mediumBlue),
                    decoration: InputDecoration(
                        // border: InputBorder.none,
                        isCollapsed: true,
                        hintText: 'D',
                        hintStyle:
                            TextStyle(fontSize: 16, color: ColorApp.black)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Text("Hoàn thành",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal)),
                          ),
                          style: ButtonStyle(
                              tapTargetSize: MaterialTapTargetSize.padded,
                              shadowColor: MaterialStateProperty.all<Color>(
                                  Colors.lightBlue),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  ColorApp.mediumBlue),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: BorderSide(
                                          color: Colors.transparent)))),
                          onPressed: () async {}),
                      ElevatedButton(
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Text("Tiếp tục",
                                style: TextStyle(
                                    fontSize: 18,
                                    // letterSpacing: 1,
                                    // wordSpacing: 1,
                                    fontWeight: FontWeight.normal)),
                          ),
                          style: ButtonStyle(
                              tapTargetSize: MaterialTapTargetSize.padded,
                              shadowColor: MaterialStateProperty.all<Color>(
                                  Colors.lightBlue),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  ColorApp.mediumBlue),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: BorderSide(
                                          color: Colors.transparent)))),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              print('validated');
                            }
                          }),
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
