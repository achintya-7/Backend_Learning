// ignore_for_file: avoid_print

import 'dart:io';

import 'package:banking_app/service/http_object.dart';
import 'package:http/http.dart' as http;

class HttpService {
  static Future<HttpObject> getResponse(String url) async {
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return HttpObject(body: response.body, statusCode: response.statusCode);
      } else {
        return HttpObject(body: null, statusCode: response.statusCode);
      }
    } on HttpException catch (e) {
      print(e);
      return HttpObject(body: null, statusCode: 500);
    }
  }

  static Future<HttpObject> postResponse(String url, String body) async {
    print("Started");
    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );
      if (response.statusCode == 200) {
        return HttpObject(body: response.body, statusCode: response.statusCode);
      } else {
        return HttpObject(body: response.body, statusCode: response.statusCode);
      }
    } on HttpException catch (e) {
      print(e);
      return HttpObject(body: null, statusCode: 500);
    }
  }
}
