import 'package:flutter/material.dart';
import 'package:utc2_staff/utils/utils.dart';

class InviteStudentScreen extends StatefulWidget {
  @override
  _InviteStudentScreenState createState() => _InviteStudentScreenState();
}

class _InviteStudentScreenState extends State<InviteStudentScreen> {
  List user = [
    {
      'avatar':
          'https://images.pexels.com/photos/1987042/pexels-photo-1987042.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
      'title': '5851071033',
      'isComplete': false
    },
    {
      'avatar':
          'https://images.unsplash.com/photo-1622060458125-8c9ae7d5f84d?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80',
      'title': '5851071033',
      'isComplete': false
    },
    {
      'avatar':
          'https://images.pexels.com/photos/1987042/pexels-photo-1987042.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
      'title': '5851071033',
      'isComplete': true
    },
    {
      'avatar':
          'https://images.pexels.com/photos/1987042/pexels-photo-1987042.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
      'title': '5851071033',
      'isComplete': false
    },
    {
      'avatar':
          'https://images.pexels.com/photos/1987042/pexels-photo-1987042.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
      'title': '5851071033',
      'isComplete': false
    },
    {
      'avatar':
          'https://images.unsplash.com/photo-1622060458125-8c9ae7d5f84d?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80',
      'title': '5851071033',
      'isComplete': false
    },
    {
      'avatar':
          'https://images.pexels.com/photos/1987042/pexels-photo-1987042.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
      'title': '5851071033',
      'isComplete': false
    },
    {
      'avatar':
          'https://images.unsplash.com/photo-1622060458125-8c9ae7d5f84d?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80',
      'title': '5851071033',
      'isComplete': false
    },
    {
      'avatar':
          'https://images.pexels.com/photos/1987042/pexels-photo-1987042.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
      'title': '5851071033',
      'isComplete': true
    },
    {
      'avatar':
          'https://images.pexels.com/photos/1987042/pexels-photo-1987042.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
      'title': '5851071033',
      'isComplete': false
    },
    {
      'avatar':
          'https://images.pexels.com/photos/1987042/pexels-photo-1987042.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
      'title': '5851071033',
      'isComplete': false
    },
    {
      'avatar':
          'https://images.unsplash.com/photo-1622060458125-8c9ae7d5f84d?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80',
      'title': '5851071033',
      'isComplete': false
    },
  ];
  bool isAll = false;
  String generation = "Chính quy";
  String course;
  String nameClass;
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
              Icons.close_rounded,
              color: ColorApp.black,
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            'Danh sách sinh viên',
            style: TextStyle(color: ColorApp.black),
          ),
          actions: [
            TextButton.icon(
                onPressed: () {},
                icon: Icon(
                  Icons.add_circle,
                  size: 15,
                ),
                label: Text(
                  'Mời',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                )),
            SizedBox(
              width: 15,
            )
          ]),
      body: Container(
        height: size.height,
        padding: EdgeInsets.all(size.width * 0.03),
        child: Column(
          children: [
            Container(
                width: size.width,
                padding: EdgeInsets.all(size.width * 0.03),
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: ColorApp.blue.withOpacity(0.05),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: Offset(0, 1), // changes position of shadow
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    Filter(
                      title: 'Hệ đào tạo',
                      value: generation,
                      item: ['All', 'Chính quy', 'Vừa học Vừa làm', 'Cao học'],
                      function: (val) {
                        setState(() {
                          generation = val;
                        });
                      },
                    ),
                    Filter(
                      title: 'Khóa',
                      value: course,
                      item: ['Khóa k58', 'Khóa k59', 'Khóa 60', 'Khóa 61'],
                      function: (val) {
                        setState(() {
                          course = val;
                        });
                      },
                    ),
                    Filter(
                      title: 'Lớp',
                      value: nameClass,
                      item: ['All', 'Chính quy', 'Vừa học Vừa làm', 'Cao học'],
                      function: (val) {
                        setState(() {
                          nameClass = val;
                        });
                      },
                    ),
                  ],
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Transform.scale(
                  scale: 0.8,
                  child: Checkbox(
                    value: isAll,
                    shape: CircleBorder(),
                    activeColor: ColorApp.mediumBlue,
                    checkColor: ColorApp.lightGrey,
                    onChanged: (value) {
                      setState(() {
                        for (int i = 0; i < user.length; i++) {
                          user[i]['isComplete'] = value;
                        }
                        isAll = value;
                      });
                    },
                  ),
                ),
                Text('Tất cả (' + user.length.toString() + ")"),
              ],
            ),
            Expanded(
              child: Container(
                width: size.width,
                padding: EdgeInsets.all(size.width * 0.03),
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: ColorApp.blue.withOpacity(0.05),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: Offset(0, 1), // changes position of shadow
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: ListView.builder(
                  itemCount: user.length,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: index.isEven
                              ? ColorApp.lightBlue.withOpacity(.05)
                              : ColorApp.lightGrey.withOpacity(.2)),
                      child: Row(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Transform.scale(
                                scale: 0.8,
                                child: Checkbox(
                                  value: user[index]['isComplete'],
                                  activeColor: ColorApp.mediumBlue,
                                  checkColor: ColorApp.lightGrey,
                                  shape: CircleBorder(),
                                  onChanged: (value) {
                                    setState(() {
                                      setState(() {
                                        user[index]['isComplete'] = value;
                                      });
                                    });
                                  },
                                ),
                              ),
                              Text(
                                (index + 1).toString(),
                                style: TextStyle(
                                    fontSize: 9,
                                    color: user[index]['isComplete']
                                        ? Colors.transparent
                                        : ColorApp.blue),
                              )
                            ],
                          ),
                          Container(
                            width: 35,
                            decoration: BoxDecoration(
                                color: ColorApp.lightGrey,
                                shape: BoxShape.circle),
                            padding: EdgeInsets.all(2),
                            child: CircleAvatar(
                              radius: 20.0,
                              backgroundImage:
                                  NetworkImage(user[index]['avatar']),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Khánh Trần'),
                                Text(
                                  user[index]['title'],
                                  style: TextStyle(
                                      color: ColorApp.black.withOpacity(.8),
                                      fontSize: 16,
                                      wordSpacing: 1.2,
                                      letterSpacing: 0.2),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Filter extends StatelessWidget {
  final String title;
  final String value;
  final List<String> item;
  final Function function;

  Filter({this.title, this.value, this.item, this.function});

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
                child: new Text(
                  value,
                  style: TextStyle(color: ColorApp.mediumBlue),
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
