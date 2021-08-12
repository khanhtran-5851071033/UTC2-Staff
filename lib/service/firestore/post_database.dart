import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:utc2_staff/models/firebase_file.dart';

class PostDatabase {
  Future<void> createPost(
      Map<String, String> dataPost, String idClass, String idPost) async {
    await FirebaseFirestore.instance
        .collection('Class')
        .doc(idClass)
        .collection('Post')
        .doc(idPost)
        .set(dataPost);
  }

  Future<void> createFileInPost(Map<String, String> dataPost, String idClass,
      String idPost, FirebaseFile file) async {
    await FirebaseFirestore.instance
        .collection('Class')
        .doc(idClass)
        .collection('Post')
        .doc(idPost)
        .collection('File')
        .doc(file.name)
        .set({
      'url': file.url,
      'idPost': idPost,
      'name': file.name,
      'ref': file.ref.toString()
    });
  }

  Future<void> deletePost(String idClass, String idPost) async {
    await FirebaseFirestore.instance
        .collection('Class')
        .doc(idClass)
        .collection('Post')
        .doc(idPost)
        .delete();
  }

  getClassData(String idClass) async {
    List<Post> list = [];
    var data = await FirebaseFirestore.instance
        .collection('Class')
        .doc(idClass)
        .collection('Post')
        .get();
    list = data.docs.map((e) => Post(e)).toList();
    return list;
  }

  getPostByDate(String idClass, String timeAttend) async {
    List<Post> list = [];
    var data = await FirebaseFirestore.instance
        .collection('Class')
        .doc(idClass)
        .collection('Post')
        .where('timeAtten', arrayContains: timeAttend)
        .get();
    list = data.docs.map((e) => Post(e)).toList();
    return list[0];
  }
}

class Post {
  String id,
      idClass,
      title,
      content,
      date,
      name,
      avatar,
      idAtten,
      timeAtten,
      idQuiz,
      quizContent,
      location,
      address;
  List file;

  Post(QueryDocumentSnapshot<Map<String, dynamic>> json) {
    this.id = json['id'];
    this.idClass = json['idClass'];
    this.title = json['title'];
    this.content = json['content'];
    this.date = json['date'];
    this.name = json['name'];
    this.avatar = json['avatar'];
    this.idAtten = json['idAtten'];
    this.timeAtten = json['timeAtten'];
    this.idQuiz = json['idQuiz'];
    this.quizContent = json['quizContent'];
    this.location = json['location'];
    this.address = json['address'];
  }
}
