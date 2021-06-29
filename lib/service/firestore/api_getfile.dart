import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:utc2_staff/models/firebase_file.dart';
import 'package:http/http.dart' as http;

class FirebaseApiGetFile {
  static Future<List<String>> _getDownloadLinks(List<Reference> refs) =>
      Future.wait(refs.map((ref) => ref.getDownloadURL()).toList());

  static Future<List<FirebaseFile>> listAll(String path) async {
    final ref = FirebaseStorage.instance.ref(path);
    final result = await ref.listAll();

    final urls = await _getDownloadLinks(result.items);

    return urls
        .asMap()
        .map((index, url) {
          final ref = result.items[index];
          final name = ref.name;
          final file = FirebaseFile(ref: ref, name: name, url: url);

          return MapEntry(index, file);
        })
        .values
        .toList();
  }

  static Future downloadFile(Reference ref) async {
    var status = await Permission.storage.status;
    // String url = await ref.getDownloadURL();

    Response response = await http.get(Uri.parse(
        'https://firebasestorage.googleapis.com/v0/b/utc2-ea569.appspot.com/o/files%2F1000-f3.5-iso%20Hi1-18mm.JPG?alt=media&token=defda0ab-6f3e-4a96-96e5-b1517466aed8'));
    if (status.isDenied) {
      await Permission.storage.request();
      final file = File('/storage/emulated/0/Download/${ref.name}');
      await file.writeAsBytes(response.bodyBytes);
    } else {
      final file = File('/storage/emulated/0/Download/${ref.name}');
      await file.writeAsBytes(response.bodyBytes);
    }
  }
}
