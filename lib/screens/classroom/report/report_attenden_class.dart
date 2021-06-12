import 'package:flutter/material.dart';
import 'package:utc2_staff/screens/classroom/report/info_atten.dart';
import 'package:utc2_staff/service/firestore/class_database.dart';
import 'package:utc2_staff/service/firestore/teacher_database.dart';
import 'package:utc2_staff/utils/utils.dart';

class ReportAttendenClass extends StatefulWidget {
  final Teacher teacher;
  final Class classUtc;

  ReportAttendenClass({this.teacher, this.classUtc});
  @override
  _ReportAttendenClassState createState() => _ReportAttendenClassState();
}

class _ReportAttendenClassState extends State<ReportAttendenClass> {
  Widget textHeader(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget textRow(String title) {
    return Text(
      title,
      textAlign: TextAlign.center,
      softWrap: true,
      maxLines: 2,
      overflow: TextOverflow.clip,
      style: TextStyle(color: ColorApp.black),
    );
  }

  Widget headerTable() {
    return Container(
      color: Colors.blue,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(flex: 1, child: textHeader('STT')),
          Expanded(flex: 4, child: textHeader('Họ và tên')),
          Expanded(flex: 3, child: textHeader('Mã sinh viên')),
          Expanded(flex: 2, child: textHeader('Lớp')),
          Expanded(flex: 3, child: textHeader('Điểm danh')),
        ],
      ),
    );
  }

  Widget rowTable(
    int stt,
    String name,
    String msv,
    String className,
    bool isCheck,
  ) {
    return Container(
      color: stt.isEven
          ? ColorApp.lightGrey.withOpacity(.2)
          : Colors.blue.withOpacity(.08),
      margin: EdgeInsets.only(bottom: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(flex: 1, child: textRow(stt.toString())),
          Expanded(flex: 4, child: textRow(name)),
          Expanded(flex: 3, child: textRow(msv)),
          Expanded(flex: 2, child: textRow(className)),
          Expanded(
              flex: 3,
              child: TextButton.icon(
                onPressed: () {
                  _showBottomSheet(context, widget.classUtc, widget.teacher);
                },
                label: Text('Chi tiết'),
                icon: Icon(
                  isCheck ? Icons.check : Icons.close,
                  size: 15,
                  color: isCheck ? Colors.lightGreen : ColorApp.red,
                ),
              )),
        ],
      ),
    );
  }

  String time = '09-07-2021';
  String attenden = 'Tất cả';
  _showBottomSheet(BuildContext context, Class _class, Teacher teacher) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            color: Color.fromRGBO(0, 0, 0, 0.001),
            child: DraggableScrollableSheet(
              initialChildSize: 0.5,
              minChildSize: 0.2,
              maxChildSize: 0.95,
              builder: (_, controller) {
                return Container(
                    child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20.0),
                      topRight: const Radius.circular(20.0),
                    ),
                  ),
                  child: Column(
                    children: [
                      Center(
                          child: Container(
                        margin: EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: ColorApp.grey,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(3),
                            topRight: const Radius.circular(3),
                          ),
                        ),
                        height: 3,
                        width: 50,
                      )),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Center(
                          child: Text(
                            'Chi tiết điểm danh',
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      Divider(
                        thickness: 0.5,
                        height: 5,
                      ),
                      Expanded(
                          child: InfoAteen(
                              widget.teacher, widget.classUtc, controller)),
                    ],
                  ),
                ));
              },
            ),
          ),
        );
      },
    );
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
            onPressed: () async {},
            icon: Image.asset(
              'assets/icons/pdf.png',
              width: 20,
            ),
            label: Text('In báo cáo'),
          ),
        ],
      ),
      body: Container(
          width: size.width,
          height: size.height,
          color: Colors.white,
          padding: EdgeInsets.all(size.width * 0.03),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Filter(
                    title: 'Đợt điểm danh',
                    value: time,
                    item: [
                      '09-04-2021',
                      '09-07-2021',
                      '21-03-2021',
                    ],
                    function: (val) {
                      setState(() {
                        time = val;
                      });
                    },
                    isSearch: false,
                  ),
                  Filter(
                    title: 'Lọc',
                    value: attenden,
                    item: [
                      'Tất cả',
                      'Có mặt',
                      'Vắng',
                    ],
                    function: (val) {
                      setState(() {
                        attenden = val;
                      });
                    },
                    isSearch: true,
                  ),
                ],
              ),
              Expanded(
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return Container(
                          height: size.height,
                          width: size.width * 1.2,
                          child: Column(
                            children: [
                              headerTable(),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                height: size.height * 2 / 3,
                                decoration: BoxDecoration(
                                    border:
                                        Border(bottom: BorderSide(width: 2))),
                                child: ListView.builder(
                                    itemCount: 30,
                                    itemBuilder: (context, index) {
                                      return rowTable(
                                        (index + 1),
                                        'Trần Quốc Khánh',
                                        "5851071033",
                                        "CNTT.k58",
                                        index.isEven,
                                      );
                                    }),
                              ),
                            ],
                          ),
                        );
                      }))
            ],
          )),
    );
  }
}

class Filter extends StatelessWidget {
  final String title;
  final String value;
  final List<String> item;
  final Function function;
  final bool isSearch;

  Filter({this.title, this.value, this.item, this.function, this.isSearch});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Text(title + ':   '),
          DropdownButton<String>(
            value: value,
            items: item.map((String value) {
              return new DropdownMenuItem<String>(
                value: value,
                child: Row(
                  mainAxisAlignment: isSearch
                      ? MainAxisAlignment.spaceAround
                      : MainAxisAlignment.center,
                  children: [
                    isSearch
                        ? Icon(
                            value == 'Tất cả'
                                ? null
                                : value == 'Có mặt'
                                    ? Icons.check
                                    : Icons.close,
                            size: 15,
                            color: value == 'Tất cả'
                                ? null
                                : value == 'Có mặt'
                                    ? Colors.lightGreen
                                    : ColorApp.red,
                          )
                        : Container(),
                    new Text(
                      value,
                      style: TextStyle(color: ColorApp.mediumBlue),
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: (newValue) {
              function(newValue);
            },
          )
        ],
      ),
    );
  }
}
