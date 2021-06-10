import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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
                  showAlertDialog(context);
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

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Thoát"),
      style: ButtonStyle(
          tapTargetSize: MaterialTapTargetSize.padded,
          shadowColor: MaterialStateProperty.all<Color>(Colors.lightBlue),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Colors.blue)))),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton.icon(
      icon: Icon(
        Icons.check,
        size: 13,
      ),
      label: Text("Xác nhận"),
      style: ButtonStyle(
          tapTargetSize: MaterialTapTargetSize.padded,
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue),
          shadowColor: MaterialStateProperty.all<Color>(Colors.lightBlue),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: ColorApp.lightGrey, width: 2)))),
      onPressed: () async {},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      insetPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      title: Center(child: Text('Chi tiết điểm danh')),
      content: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white, ColorApp.lightGrey])),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(4),
                  child: CircleAvatar(
                    backgroundColor: ColorApp.lightGrey,
                    backgroundImage: CachedNetworkImageProvider(
                        'https://lh3.googleusercontent.com/a/AATXAJz3f95XAgjw2BkmaR53xLtc4wV8Q2dOY-5JXKrd=s96-c'),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Trần Quốc Khánh',
                        style: TextStyle(
                            color: ColorApp.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '5851071033',
                        softWrap: true,
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                        style: TextStyle(color: ColorApp.black, fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text('Hạn điểm danh : '), Text('10:50 - 21-07-2021')],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Có mặt lúc : ',
                ),
                Text('10:50')
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Vị trí : ',
                ),
                Expanded(
                    child: Text(
                        'dsadsadsadsaddddddddddddddddddddđxxxxxxxxxxxxxxxxxxsadsadsadda'))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tọa độ : ',
                ),
                Expanded(child: Text('106.665565,10.66866'))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Trạng thái : ',
                ),
                Expanded(child: Text('Thành công'))
              ],
            ),
          ],
        ),
      ),
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
