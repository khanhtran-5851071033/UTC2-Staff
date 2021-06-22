import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:utc2_staff/models/firebase_file.dart';
import 'package:utc2_staff/service/firestore/api_getfile.dart';

class ImagePage extends StatelessWidget {
  final FirebaseFile file;

  const ImagePage({Key key, this.file}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isImage = ['.jpeg', '.jpg', '.png', '.PNG'].any(file.name.contains);

    return Scaffold(
      appBar: AppBar(
        title: Text(file.name),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.file_download),
            onPressed: () async {
              await FirebaseApiGetFile.downloadFile(file.ref);

              final snackBar = SnackBar(
                content: Text('Downloaded ${file.name}'),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: isImage
          ? Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: CachedNetworkImageProvider(file.url),
              )),
            )
          : Center(
              child: Text(
                'Cannot be displayed',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
    );
  }
}
