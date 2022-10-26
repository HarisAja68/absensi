import 'package:absensi/app/routes/app_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class NewPassController extends GetxController {
  TextEditingController newPassC = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;

  void newPass() async {
    if (newPassC.text.isNotEmpty) {
      if (newPassC.text != "password") {
        try {
          String email = auth.currentUser!.email!;

          await auth.currentUser!.updatePassword(newPassC.text);
          await auth.signOut();

          await auth.signInWithEmailAndPassword(
            email: email,
            password: newPassC.text,
          );

          Get.offAllNamed(Routes.LOGIN);
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            Get.snackbar("terjadi kesalahan", "password minimal 6 karakter");
          }
        } catch (e) {
          Get.snackbar(
              "terjadi kesalahan", "tidak dapat merubah password baru");
        }
      } else {
        Get.snackbar(
            "terjadi kesalahan", "password tidak boleh seperti yang dulu");
      }
    } else {
      Get.snackbar("terjadi kesalahan", "password wajib diisi");
    }
  }
}
