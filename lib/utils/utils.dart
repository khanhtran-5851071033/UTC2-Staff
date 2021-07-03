import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ColorApp {
  static const Color lightBlue = Color(0xff5095E6);
  static const Color blue = Color(0xff044AFE);
  static const Color mediumBlue = Color(0xff213365);
  static const Color grey = Color(0xffA3B0C8);
  static const Color lightGrey = Color(0xffE7EDF4);
  static const Color black = Color(0xff020822);
  static const Color red = Color(0xffD94A50);
}

String generateRandomString(int len) {
  var r = Random();
  const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
}

bool isImage(String fileName) {
  return [
    '.jpeg',
    '.jpg',
    '.png',
    '.PNG',
    '.JPG',
    '.JPEG',
    '.heic',
    '.HEIC',
    '.tiff',
    '.TIFF',
    '.bmp',
    '.BMP',
  ].any(fileName.contains);
}

bool isLink(String link) {
  return [
    'http://',
    'https://',
  ].any(link.contains);
}

String formatTime(String time) {
  DateTime parseDate = new DateFormat("yyyy-MM-dd HH:mm:ss").parse(time);
  return DateFormat("ddMMyyyy").format(parseDate);
}
