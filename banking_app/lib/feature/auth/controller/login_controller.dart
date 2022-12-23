import 'package:get/get.dart';

class LoginController extends GetxController {
  RxString email = "".obs;

  updateEmail(String s) {
    email.value = s;
  }
}
