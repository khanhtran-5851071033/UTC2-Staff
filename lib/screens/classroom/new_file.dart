import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:utc2_staff/models/firebase_file.dart';
import 'package:utc2_staff/screens/classroom/image_page.dart';
import 'package:utc2_staff/service/firestore/api_getfile.dart';
import 'package:utc2_staff/service/firestore/api_upfile.dart';
import 'package:utc2_staff/utils/utils.dart';

class NewFile extends StatefulWidget {
  @override
  _NewFileState createState() => _NewFileState();
}

class _NewFileState extends State<NewFile> {
  UploadTask task;
  File file;
  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;
    final path = result.files.single.path;

    setState(() => file = File(path));
  }

  Future uploadFile() async {
    if (file == null) return;

    final fileName = basename(file.path);
    final destination = 'files/$fileName';

    task = FirebaseApi.uploadFile(destination, file);
    setState(() {});

    if (task == null) return;

    final snapshot = await task.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    print('Download-Link: $urlDownload');
  }

  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data;
            final progress = snap.bytesTransferred / snap.totalBytes;
            final percentage = (progress * 100).toStringAsFixed(2);

            return Text(
              '$percentage %',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            );
          } else {
            return Container();
          }
        },
      );
  Future<List<FirebaseFile>> futureFiles;

  @override
  void initState() {
    super.initState();
    futureFiles = FirebaseApiGetFile.listAll('files/');
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final fileName = file != null ? basename(file.path) : 'No File Selected';
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
          'Tệp đính kèm',
          style: TextStyle(color: ColorApp.black),
        ),
        actions: [
          TextButton(
            onPressed: () {
              uploadFile();
            },
            child: Text("Thêm    ",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          )
        ],
      ),
      body: Container(
        height: size.height,
        width: size.width,
        padding: EdgeInsets.all(size.width * 0.03),
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
          children: [
            task != null ? buildUploadStatus(task) : Container(),
            Text(fileName),
            Container(
              width: size.width,
              child: TextButton.icon(
                onPressed: () {
                  selectFile();
                },
                label: Text(
                  'Chọn file',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                icon: Icon(
                  Icons.attachment,
                  size: 14,
                ),
                style: ButtonStyle(
                    tapTargetSize: MaterialTapTargetSize.padded,
                    shadowColor:
                        MaterialStateProperty.all<Color>(Colors.lightBlue),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: Colors.blue)))),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<FirebaseFile>>(
                future: futureFiles,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Center(child: CircularProgressIndicator());
                    default:
                      if (snapshot.hasError) {
                        return Center(child: Text('Some error occurred!'));
                      } else {
                        final files = snapshot.data;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildHeader(files.length),
                            SizedBox(height: 12),
                            Expanded(
                              child: RefreshIndicator(
                                onRefresh: () async {
                                  futureFiles =
                                      FirebaseApiGetFile.listAll('files/');
                                },
                                child: ListView.builder(
                                  itemCount: files.length,
                                  itemBuilder: (context, index) {
                                    final file = files[index];

                                    return TextButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) =>
                                              ImagePage(file: file),
                                        ));
                                      },
                                      child: Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 5),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            gradient: LinearGradient(
                                                stops: [0.08, 1],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: [
                                                  Colors.white,
                                                  ColorApp.lightGrey
                                                ])),
                                        child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Checkbox(
                                                value: true,
                                                activeColor:
                                                    ColorApp.mediumBlue,
                                                checkColor: Colors.white,
                                                shape: CircleBorder(),
                                                onChanged: (value) {},
                                              ),
                                              CircleAvatar(
                                                backgroundColor:
                                                    ColorApp.lightGrey,
                                                radius: 15,
                                                backgroundImage:
                                                    CachedNetworkImageProvider(
                                                        file.url),
                                              ),
                                              SizedBox(
                                                width: 15,
                                              ),
                                              Expanded(
                                                child: Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  // height: 25,
                                                  child: Text(
                                                    file.name,
                                                  ),
                                                ),
                                              )
                                            ]),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFile(BuildContext context, FirebaseFile file) => ListTile(
        leading: ClipOval(
          child: Image.network(
            file.url,
            width: 52,
            height: 52,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          file.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
            color: Colors.blue,
          ),
        ),
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => null,
        )),
      );

  Widget buildHeader(int length) => ListTile(
        tileColor: Colors.blue,
        leading: Container(
          width: 52,
          height: 52,
          child: Icon(
            Icons.file_copy,
            color: Colors.black,
          ),
        ),
        title: Text(
          '$length Files',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
      );
}
