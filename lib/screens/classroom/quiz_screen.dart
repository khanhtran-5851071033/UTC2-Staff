import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:utc2_staff/blocs/question_bloc/question_bloc.dart';
import 'package:utc2_staff/blocs/question_bloc/question_event.dart';
import 'package:utc2_staff/blocs/question_bloc/question_state.dart';
import 'package:utc2_staff/service/firestore/quiz_database.dart';
import 'package:utc2_staff/utils/utils.dart';

class QuizSreen extends StatefulWidget {
  final Quiz quiz;
  final String idTeacher;

  QuizSreen({this.quiz, this.idTeacher});
  @override
  _QuizSreenState createState() => _QuizSreenState();
}

class _QuizSreenState extends State<QuizSreen> {
  int selectedRadio;
  bool start = false;

  final interval = const Duration(seconds: 1);

  int timerMaxSeconds = 0;

  int currentSeconds = 0;

  String get timerText =>
      '${((timerMaxSeconds - currentSeconds) ~/ 60).toString().padLeft(2, '0')}: ${((timerMaxSeconds - currentSeconds) % 60).toString().padLeft(2, '0')}';
  Timer _timer;
  startTimeout([int milliseconds]) {
    var duration = interval;
    _timer = Timer.periodic(duration, (timer) {
      setState(() {
        currentSeconds = timer.tick;
        if (timer.tick >= timerMaxSeconds) {
          timer.cancel();
          start = false;
        }
      });
    });
  }

  int totalAnswer = 0;
  QuestionBloc questionBloc = new QuestionBloc();
  @override
  void initState() {
    super.initState();
    selectedRadio = 0;
    timerMaxSeconds = int.parse(widget.quiz.timePlay.toString()) * 60;
    questionBloc = BlocProvider.of<QuestionBloc>(context);
    questionBloc.add(GetQuestionEvent(widget.idTeacher, widget.quiz.idQuiz));
  }

  @override
  void dispose() {
    start ? _timer.cancel() : print('');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Xem trước',
          style: TextStyle(color: ColorApp.black),
        ),
        actions: [
          TextButton.icon(
              onPressed: () async {
                // final pdfFile = await PdfParagraphApi.generate();
                // PdfApi.openFile(pdfFile);
              },
              icon: Image.asset(
                'assets/icons/pdf.png',
                width: 20,
              ),
              label: Text('Tải xuống'))
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(size.width * 0.03),
        height: size.height,
        child: Column(
          children: [
            Container(
              child: QuizTitle(
                title: widget.quiz.titleQuiz,
                time: timerText,
                totalQuestion:
                    totalAnswer.toString() + "/" + widget.quiz.totalQuestion,
                start: () {
                  setState(() {
                    start = true;
                  });
                  startTimeout();
                },
              ),
            ),
            SizedBox(
              height: size.width * 0.03,
            ),
            Expanded(
              child: AnimatedCrossFade(
                secondChild: Container(),
                firstCurve: Curves.easeInOutSine,
                crossFadeState: start
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                duration: Duration(milliseconds: 500),
                firstChild: Container(
                  width: size.width,
                  height: size.height,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: ColorApp.blue.withOpacity(0.05),
                          spreadRadius: 3,
                          blurRadius: 3,
                          offset: Offset(0, 1), // changes position of shadow
                        ),
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: ColorApp.lightGrey)),
                  child: BlocBuilder<QuestionBloc, QuestionState>(
                    builder: (context, state) {
                      if (state is LoadingQuestion)
                        return SpinKitThreeBounce(
                          color: ColorApp.lightBlue,
                        );
                      else if (state is LoadedQuestion) {
                        return RefreshIndicator(
                          onRefresh: () async {
                            questionBloc.add(GetQuestionEvent(
                                widget.idTeacher, widget.quiz.idQuiz));
                          },
                          child: Scrollbar(
                            showTrackOnHover: true,
                            radius: Radius.circular(5),
                            thickness: 5,
                            child: ListView.builder(
                                padding: EdgeInsets.all(size.width * 0.03),
                                itemCount: state.list.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: Question(
                                      number: index,
                                      question: state.list[index].question,
                                      option1: Option(
                                        answer: state.list[index].answerCorrect,
                                        value: 1,
                                        selectedRadio: selectedRadio,
                                        setSelectedRadio: (val) {
                                          setState(() {
                                            selectedRadio = val;
                                          });
                                        },
                                      ),
                                      option2: Option(
                                        answer: state.list[index].answer2,
                                        value: 2,
                                        selectedRadio: selectedRadio,
                                        setSelectedRadio: (val) {
                                          setState(() {
                                            selectedRadio = val;
                                          });
                                        },
                                      ),
                                      option3: state.list[index].answer3 != ''
                                          ? Option(
                                              answer: state.list[index].answer3,
                                              value: 3,
                                              selectedRadio: selectedRadio,
                                              setSelectedRadio: (val) {
                                                setState(() {
                                                  selectedRadio = val;
                                                });
                                              },
                                            )
                                          : Container(),
                                      option4: state.list[index].answer4 != ''
                                          ? Option(
                                              answer: state.list[index].answer4,
                                              value: 4,
                                              selectedRadio: selectedRadio,
                                              setSelectedRadio: (val) {
                                                setState(() {
                                                  selectedRadio = val;
                                                });
                                              },
                                            )
                                          : Container(),
                                    ),
                                  );
                                }),
                          ),
                        );
                      } else if (state is LoadErrorQuestion) {
                        return Center(
                          child: Text(
                            state.error,
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          ),
                        );
                      } else {
                        return SpinKitThreeBounce(
                          color: ColorApp.lightBlue,
                        );
                      }
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Option extends StatelessWidget {
  final String answer;
  final int value;
  final int selectedRadio;
  final Function setSelectedRadio;
  Option({this.selectedRadio, this.value, this.setSelectedRadio, this.answer});

  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        leading: Radio(
          value: value,
          groupValue: selectedRadio,
          activeColor: ColorApp.red,
          onChanged: (val) {
            setSelectedRadio(val);
          },
        ),
        title: Text(answer),
      ),
    );
  }
}

class Question extends StatelessWidget {
  final String question;
  final int number;
  final Widget option1;
  final Widget option2;
  final Widget option3;
  final Widget option4;

  Question(
      {this.question,
      this.number,
      this.option1,
      this.option2,
      this.option3,
      this.option4});
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      padding: EdgeInsets.all(size.width * 0.03),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: ColorApp.lightGrey)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            (number + 1).toString() + '. ' + question,
            style: TextStyle(
                color: ColorApp.black,
                fontSize: 18,
                fontWeight: FontWeight.w600),
          ),
          option1,
          option2,
          option3,
          option4
        ],
      ),
    );
  }
}

class QuizTitle extends StatelessWidget {
  final String title;
  final String time;
  final String totalQuestion;
  final Function start;
  QuizTitle({this.title, this.time, this.totalQuestion, this.start});
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        width: size.width,
        alignment: Alignment.center,
        padding: EdgeInsets.all(size.width * 0.03),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: ColorApp.blue.withOpacity(0.05),
                spreadRadius: 3,
                blurRadius: 3,
                offset: Offset(0, 1), // changes position of shadow
              ),
            ],
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: ColorApp.lightGrey)),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(title),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'Thời gian:  ',
                      style: TextStyle(
                          color: ColorApp.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                      children: <TextSpan>[
                        TextSpan(
                            text: time,
                            style: TextStyle(
                                color: ColorApp.red,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: 'Câu hỏi:  ',
                      style: TextStyle(
                          color: ColorApp.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                      children: <TextSpan>[
                        TextSpan(
                            text: totalQuestion,
                            style: TextStyle(
                                color: ColorApp.red,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  )
                ],
              ),
              ElevatedButton(
                  child: Container(
                    //  margin: EdgeInsets.symmetric(vertical: 10),
                    child: Text("Bắt đầu",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.normal)),
                  ),
                  style: ButtonStyle(
                      tapTargetSize: MaterialTapTargetSize.padded,
                      shadowColor:
                          MaterialStateProperty.all<Color>(Colors.lightBlue),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(ColorApp.mediumBlue),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(color: Colors.transparent)))),
                  onPressed: start),
            ],
          ),
        ));
  }
}
