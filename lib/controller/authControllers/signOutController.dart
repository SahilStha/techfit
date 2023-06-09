import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../functionsController/dialogsAndLoadingController.dart';

class SignOutController extends GetxController {
  // Dependency injection
  DialogsAndLoadingController dialogsAndLoadingController =
      Get.put(DialogsAndLoadingController());

  // Sign out from app
  signOut() async {
    //
    try {
      // Show loading
      dialogsAndLoadingController.showLoading();

      // Sign out method
      await FirebaseAuth.instance.signOut();
    } on FirebaseAuthException catch (e) {
      // else, first pop
      Get.back();

      // show error to user
      dialogsAndLoadingController.showError("Error: ${e.code}");
    }
  }
}
