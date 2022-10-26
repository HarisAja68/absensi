import 'package:absensi/app/routes/app_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  void login() async {
    if (emailC.text.isNotEmpty && passC.text.isNotEmpty) {
      try {
        UserCredential userCredential = await auth.signInWithEmailAndPassword(
            email: emailC.text, password: passC.text);

        // print(userCredential);

        if (userCredential.user != null) {
          if (userCredential.user!.emailVerified == true) {
            if (passC.text == "password") {
              Get.offAllNamed(Routes.NEW_PASS);
            } else {
              Get.offAllNamed(Routes.HOME);
            }
          } else {
            Get.defaultDialog(
              title: "akun belum verifikasi",
              middleText: "silahkan anda verifikasi email terlebih dahulu",
              actions: [
                OutlinedButton(
                  onPressed: () => Get.back(),
                  child: Text("cancel"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await userCredential.user!.sendEmailVerification();
                      Get.back();
                      Get.snackbar(
                          "sukses dikirim", "email verifikasi sudah terkirim");
                    } catch (e) {
                      Get.snackbar("terjadi kesalahan",
                          "tidak dapat mengirim email verifikasi");
                    }
                  },
                  child: Text("Kirim ulang"),
                ),
              ],
            );
          }
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          Get.snackbar("terjadi kesalahan", "email tidak terdaftar");
        } else if (e.code == 'wrong-password') {
          Get.snackbar("terjadi kesalahan", "password salah");
        }
      } catch (e) {
        Get.snackbar("terjadi kesalahan", "Tidak dapat login");
      }
    } else {
      Get.snackbar("terjadi kesalahan", "email dan password harus diisi");
    }
  }
}
