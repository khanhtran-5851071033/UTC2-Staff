import 'package:flutter/material.dart';
import 'package:utc2_staff/screens/classroom/quiz_screen.dart';
import 'package:utc2_staff/utils/utils.dart';

class NewQuiz extends StatefulWidget {
  @override
  _NewQuizState createState() => _NewQuizState();
}

class _NewQuizState extends State<NewQuiz> {
  final _formKey = GlobalKey<FormState>();
  int _selectedTime = 10;
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
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => QuizSreen()));
              },
              label: Text('Xem trước  '),
              icon: Icon(
                Icons.visibility_rounded,
                size: 16,
              ),
            )
          ],
        ),
        body: Container(
          child: Column(
            //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(size.width * 0.03),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 30,
                      child: CircleAvatar(
                        backgroundColor: Colors.blue.withOpacity(.1),
                        child: Icon(
                          Icons.schedule_rounded,
                          color: Colors.blue,
                          size: 16,
                        ),
                      ),
                    ),
                    Text('   Thời gian Test:  '),
                    DropdownButton<int>(
                      value: _selectedTime,
                      items: <int>[10, 15, 20, 30, 45, 60].map((int value) {
                        return new DropdownMenuItem<int>(
                          value: value,
                          child: new Text(value.toString() + ' Phút'),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedTime = newValue;
                        });
                      },
                    ),
                    Spacer(),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(size.width * 0.03),
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
                          validator: (val) =>
                              val.isEmpty ? 'Nhập câu hỏi' : null,
                          onChanged: (value) {},
                          autofocus: true,
                          style: TextStyle(
                              fontSize: 20, color: ColorApp.mediumBlue),
                          decoration: InputDecoration(
                              // border: InputBorder.none,
                              isCollapsed: true,
                              hintText: 'Câu hỏi 1',
                              hintStyle: TextStyle(
                                  fontSize: 16, color: ColorApp.black)),
                        ),
                        TextFormField(
                          validator: (val) =>
                              val.isEmpty ? 'Nhập câu trả lời đúng' : null,
                          onChanged: (value) {},
                          style: TextStyle(fontSize: 20, color: Colors.red),
                          decoration: InputDecoration(
                              // border: InputBorder.none,
                              isCollapsed: true,
                              hintText: 'A --> Đán áp đúng',
                              hintStyle:
                                  TextStyle(fontSize: 16, color: ColorApp.red)),
                        ),
                        TextFormField(
                          validator: (val) => val.isEmpty
                              ? 'Nhập ít nhất 1 câu trả lời sai'
                              : null,
                          onChanged: (value) {},
                          style: TextStyle(
                              fontSize: 20, color: ColorApp.mediumBlue),
                          decoration: InputDecoration(
                              // border: InputBorder.none,
                              isCollapsed: true,
                              hintText: 'B',
                              hintStyle: TextStyle(
                                  fontSize: 16, color: ColorApp.black)),
                        ),
                        TextFormField(
                          onChanged: (value) {},
                          style: TextStyle(
                              fontSize: 20, color: ColorApp.mediumBlue),
                          decoration: InputDecoration(
                              // border: InputBorder.none,
                              isCollapsed: true,
                              hintText: 'C',
                              hintStyle: TextStyle(
                                  fontSize: 16, color: ColorApp.black)),
                        ),
                        TextFormField(
                          onChanged: (value) {},
                          style: TextStyle(
                              fontSize: 20, color: ColorApp.mediumBlue),
                          decoration: InputDecoration(
                              // border: InputBorder.none,
                              isCollapsed: true,
                              hintText: 'D',
                              hintStyle: TextStyle(
                                  fontSize: 16, color: ColorApp.black)),
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
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            ColorApp.mediumBlue),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
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
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            ColorApp.mediumBlue),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
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
              ),
            ],
          ),
        ));
  }
}
