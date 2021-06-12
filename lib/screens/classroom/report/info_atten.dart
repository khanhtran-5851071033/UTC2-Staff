import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:utc2_staff/service/firestore/class_database.dart';
import 'package:utc2_staff/service/firestore/teacher_database.dart';
import 'package:utc2_staff/utils/utils.dart';

class InfoAteen extends StatefulWidget {
  final Teacher teacher;
  final Class classUtc;
  final ScrollController controller;
  InfoAteen(this.teacher, this.classUtc, this.controller);

  @override
  _InfoAteenState createState() => _InfoAteenState();
}

class _InfoAteenState extends State<InfoAteen> {
  bool isCheck = true;

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
    return Column(children: [
      Expanded(
          child: ListView.builder(
              controller: widget.controller,
              itemCount: 1,
              itemBuilder: (_, index) {
                return Container(
                  height: size.height,
                  padding: EdgeInsets.all(size.width * 0.03),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.classUtc.id != null
                                      ? 'Mã điểm danh : ' + widget.classUtc.id
                                      : '',
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  widget.classUtc.date != null
                                      ? 'Hạn : ' +
                                          DateFormat('HH:mm - dd-MM-yyyy')
                                              .format(DateFormat(
                                                      "yyyy-MM-dd HH:mm:ss")
                                                  .parse(widget.classUtc.date))
                                      : '',
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                              ],
                            ),
                            //qr
                            Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: ColorApp.blue.withOpacity(0.09),
                                    spreadRadius: 3,
                                    blurRadius: 5,
                                    offset: Offset(
                                        2, 3), // changes position of shadow
                                  ),
                                ],
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                                // border:
                                //     Border.all(color: ColorApp.lightGrey)
                              ),
                              child: QrImage(
                                data: widget.classUtc.id,
                                embeddedImage:
                                    AssetImage('assets/images/logoUTC.png'),
                                version: QrVersions.auto,
                                size: 100,
                                gapless: false,
                                embeddedImageStyle: QrEmbeddedImageStyle(
                                  size: Size(17, 17),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: ColorApp.blue.withOpacity(0.02),
                                  spreadRadius: 3,
                                  blurRadius: 5,
                                  offset: Offset(
                                      -4, 4), // changes position of shadow
                                ),
                              ],
                              gradient: LinearGradient(
                                  stops: [0.2, 0.9],
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomCenter,
                                  colors: [Colors.white, ColorApp.lightGrey]),
                              // color: Colors.green,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: ColorApp.lightGrey, width: 0.1)),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(4),
                                    child: CircleAvatar(
                                      backgroundColor: ColorApp.lightGrey,
                                      backgroundImage:
                                          CachedNetworkImageProvider(
                                              widget.teacher.avatar),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.teacher.name != null
                                            ? 'Sinh viên : ' +
                                                widget.teacher.name
                                            : '',
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        widget.teacher.id != null
                                            ? 'Mã sinh viên : ' +
                                                widget.teacher.id
                                            : '',
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              //zo day
                              SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              //zo day
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          widget.classUtc.date != null
                                              ? 'Có mặt lúc : ' +
                                                  DateFormat(
                                                          'HH:mm - dd-MM-yyyy')
                                                      .format(DateFormat(
                                                              "yyyy-MM-dd HH:mm:ss")
                                                          .parse(widget
                                                              .classUtc.date))
                                              : '',
                                        ),
                                        Icon(
                                          isCheck ? Icons.check : Icons.close,
                                          size: 17,
                                          color: isCheck
                                              ? Colors.lightGreen
                                              : ColorApp.red,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          widget.classUtc.id != null
                                              ? 'Vị trí : ' + widget.classUtc.id
                                              : '',
                                        ),
                                        Icon(
                                          isCheck ? Icons.check : Icons.close,
                                          size: 17,
                                          color: isCheck
                                              ? Colors.lightGreen
                                              : ColorApp.red,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              'Tọa độ : ',
                                            ),
                                            InkWell(
                                                onTap: () {
                                                  _launchInWebViewWithJavaScript(
                                                      'https://www.google.com/maps/place/10.84595710052921, 106.79456090829986');
                                                },
                                                child: Text(
                                                  '10.84595710052921, 106.79456090829986',
                                                  style: TextStyle(
                                                      color: Colors.lightBlue),
                                                ))
                                          ],
                                        ),
                                        Icon(
                                          isCheck ? Icons.check : Icons.close,
                                          size: 17,
                                          color: isCheck
                                              ? Colors.lightGreen
                                              : ColorApp.red,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Trang thái : Thành công',
                                        ),
                                        Icon(
                                          isCheck ? Icons.check : Icons.close,
                                          size: 17,
                                          color: isCheck
                                              ? Colors.lightGreen
                                              : ColorApp.red,
                                        ),
                                      ],
                                    ),
                                  ])
                            ],
                          ),
                        ),
                      ]),
                );
              })),
    ]);
  }
}
