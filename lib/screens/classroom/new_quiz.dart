import 'package:flutter/material.dart';
import 'package:utc2_staff/screens/classroom/quiz_screen.dart';
import 'package:utc2_staff/service/firestore/quiz_database.dart';
import 'package:utc2_staff/utils/utils.dart';

class NewQuiz extends StatefulWidget {
  final String idTeacher;

  const NewQuiz({Key key, this.idTeacher}) : super(key: key);
  @override
  _NewQuizState createState() => _NewQuizState();
}

class _NewQuizState extends State<NewQuiz> {
  showAlertDialog(
    BuildContext context,
    String idTeacher,
    String idQuiz,
    int idQuestion
  ) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Thoát"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Kết thúc"),
      onPressed: () async {
        QuizDatabase.deleteQuiz(idTeacher, idQuiz);

        Navigator.pop(context);
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Bài Test chưa hoàn thành bạn có muốn kết thúc?"),
      content: Text('Dừng ở câu số '+idQuestion.toString()),
      actions: [
        continueButton,
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _questionController = TextEditingController();
  TextEditingController _answerCorrectController = TextEditingController();
  TextEditingController _answer1Controller = TextEditingController();
  TextEditingController _answer2Controller = TextEditingController();
  TextEditingController _answer3Controller = TextEditingController();
  int _selectedTime = 10;
  QuizDatabase _quizDatabase = new QuizDatabase();
  int idQuestion = 0;
  String idQuiz = generateRandomString(5);
  @override
  void dispose() {
    _titleController.dispose();
    _questionController.dispose();
    _answerCorrectController.dispose();
    _answer1Controller.dispose();
    _answer2Controller.dispose();
    _answer3Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            color: ColorApp.lightGrey,
            onPressed: () {
              idQuestion != 0
                  ? showAlertDialog(context, widget.idTeacher, idQuiz,idQuestion)
                  : Navigator.pop(context);
            },
            icon: Icon(
              Icons.close_rounded,
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
                width: size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Form(
                      key: _formKey1,
                      child: TextFormField(
                        controller: _titleController,
                        validator: (val) => val.isEmpty ? 'Nhập chủ đề' : null,
                        decoration: InputDecoration(
                          hintText: 'Chủ đề bài Test',
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.schedule_rounded,
                          color: Colors.blue,
                          size: 16,
                        ),
                        Text('   Thời gian Test:   '),
                        DropdownButton<int>(
                          value: _selectedTime,
                          items: <int>[10, 15, 20, 30, 45, 60].map((int value) {
                            return new DropdownMenuItem<int>(
                              value: value,
                              child: new Text(value.toString() + '  Phút  '),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedTime = newValue;
                            });
                          },
                        ),
                        Spacer(),
                        Text('Số câu: '),
                        Text(idQuestion.toString())
                      ],
                    ),
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
                          controller: _questionController,
                          validator: (val) =>
                              val.isEmpty ? 'Nhập câu hỏi' : null,
                          autofocus: true,
                          style: TextStyle(
                              fontSize: 20, color: ColorApp.mediumBlue),
                          decoration: InputDecoration(
                              // border: InputBorder.none,
                              isCollapsed: true,
                              hintText:
                                  'Câu hỏi ' + (idQuestion + 1).toString(),
                              hintStyle: TextStyle(
                                  fontSize: 16, color: ColorApp.black)),
                        ),
                        TextFormField(
                          controller: _answerCorrectController,
                          validator: (val) =>
                              val.isEmpty ? 'Nhập câu trả lời đúng' : null,
                          style: TextStyle(fontSize: 20, color: Colors.red),
                          decoration: InputDecoration(
                              // border: InputBorder.none,
                              isCollapsed: true,
                              hintText: 'A --> Đán áp đúng',
                              hintStyle:
                                  TextStyle(fontSize: 16, color: ColorApp.red)),
                        ),
                        TextFormField(
                          controller: _answer1Controller,
                          validator: (val) => val.isEmpty
                              ? 'Nhập ít nhất 1 câu trả lời sai'
                              : null,
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
                          controller: _answer2Controller,
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
                          controller: _answer3Controller,
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
                                onPressed: () async {
                                  if (_formKey1.currentState.validate()) {
                                    if (idQuestion == 0) {
                                      if (_formKey.currentState.validate()) {
                                        Map<String, String> dataQuiz = {
                                          'idQuiz': idQuiz,
                                          'idTeacher': widget.idTeacher,
                                          'titleQuiz':
                                              _titleController.text.trim(),
                                          'timePlay': _selectedTime.toString(),
                                          'dateCreate':
                                              DateTime.now().toString(),
                                          'totalQuestion':
                                              (idQuestion + 1).toString()
                                        };
                                        _quizDatabase.createQuiz(
                                            dataQuiz, widget.idTeacher, idQuiz);

                                        Map<String, String> dataQuestion = {
                                          'idQuiz': idQuiz,
                                          'idQuestion':
                                              (idQuestion + 1).toString(),
                                          'question':
                                              _questionController.text.trim(),
                                          'answerCorrect':
                                              _answerCorrectController.text
                                                  .trim(),
                                          'answer2':
                                              _answer1Controller.text.trim(),
                                          'answer3':
                                              _answer2Controller.text.trim(),
                                          'answer4':
                                              _answer3Controller.text.trim(),
                                        };
                                        _quizDatabase.createQuestion(
                                            dataQuestion,
                                            widget.idTeacher,
                                            idQuiz,
                                            (idQuestion).toString());
                                        Navigator.pop(context);
                                      }
                                    } else {
                                      Map<String, String> dataQuiz = {
                                        'idQuiz': idQuiz,
                                        'idTeacher': widget.idTeacher,
                                        'titleQuiz':
                                            _titleController.text.trim(),
                                        'timePlay': _selectedTime.toString(),
                                        'dateCreate': DateTime.now().toString(),
                                        'totalQuestion':
                                            (idQuestion).toString()
                                      };
                                      QuizDatabase.updateQuiz(
                                          widget.idTeacher, idQuiz, dataQuiz);
                                      Navigator.pop(context);
                                    }
                                  } else {
                                    
                                  }
                                }),
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
                                    if (idQuestion == 0) {
                                      Map<String, String> dataQuiz = {
                                        'idQuiz': idQuiz,
                                        'idTeacher': widget.idTeacher,
                                      };
                                      _quizDatabase.createQuiz(
                                          dataQuiz, widget.idTeacher, idQuiz);
                                    }

                                    Map<String, String> dataQuestion = {
                                      'idQuiz': idQuiz,
                                      'idQuestion': (idQuestion + 1).toString(),
                                      'question':
                                          _questionController.text.trim(),
                                      'answerCorrect':
                                          _answerCorrectController.text.trim(),
                                      'answer2': _answer1Controller.text.trim(),
                                      'answer3': _answer2Controller.text.trim(),
                                      'answer4': _answer3Controller.text.trim(),
                                    };
                                    _quizDatabase.createQuestion(
                                        dataQuestion,
                                        widget.idTeacher,
                                        idQuiz,
                                        (idQuestion + 1).toString());
                                    ++idQuestion;
                                    setState(() {
                                      idQuestion = idQuestion;
                                      _questionController.clear();
                                      _answerCorrectController.clear();
                                      _answer1Controller.clear();
                                      _answer2Controller.clear();
                                      _answer3Controller.clear();
                                    });
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
