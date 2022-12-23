import 'dart:convert';

import 'package:banking_app/constants.dart';
import 'package:banking_app/service/http_object.dart';
import 'package:banking_app/service/http_service.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  RxString status = "".obs;
  RxBool loading = false.obs;

  updateStatus(String s) {
    status.value = s;
  }

  loginRequest(String email, String password) async {
    String url = "$apiUrlLocal/users/login";

    Map<String, dynamic> body = {
      "username": email,
      "password": password,
    };

    String jsonBody = json.encode(body);

    HttpObject httpObject = await HttpService.postResponse(url, jsonBody);

    // * For testing purposes
    // showLoading();
    // await Future.delayed(const Duration(seconds: 1));
    // final random = Random();
    // int index = random.nextInt(3);
    // List<int> body = [200, 404, 200];
    // HttpObject httpObject = HttpObject(statusCode: body[index], body: "Sigma");
    // hideLoading();

    if (httpObject.statusCode == 200) {
      updateStatus("${httpObject.statusCode} : Login Successful");
      Get.offAndToNamed("/home", arguments: httpObject.body);
    } else {
      updateStatus("${httpObject.statusCode} : Login Failed");
      print(httpObject.body);
    }
  }

  showLoading() {
    loading.toggle();
  }

  hideLoading() {
    loading.toggle();
  }
}
