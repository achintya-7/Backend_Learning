import 'package:banking_app/feature/auth/controller/login_controller.dart';
import 'package:banking_app/feature/auth/controller/signup_controller.dart';
import 'package:get/get.dart';

class AuthBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(LoginController());
    Get.put(SignUpController());
  }
}
