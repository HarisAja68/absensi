import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddPegawaiController extends GetxController {
  TextEditingController nipC = TextEditingController();
  TextEditingController namaC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController passAdminC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> prosesAddPegawai() async {
    if (passAdminC.text.isNotEmpty) {
      try {
        String emailAdmin = auth.currentUser!.email!;

        UserCredential userCredentialAdmin =
            await auth.signInWithEmailAndPassword(
          email: emailAdmin,
          password: passAdminC.text,
        );

        UserCredential pegawaiCredential =
            await auth.createUserWithEmailAndPassword(
          email: emailC.text,
          password: "password",
        );

        if (pegawaiCredential.user != null) {
          String uid = pegawaiCredential.user!.uid;

          await firestore.collection("pegawai").doc(uid).set({
            "nip": nipC.text,
            "name": namaC.text,
            "email": emailC.text,
            "uid": uid,
            'created_at': DateTime.now().toIso8601String(),
          });

          await pegawaiCredential.user!.sendEmailVerification();

          await auth.signOut();

          UserCredential userCredentialAdmin =
              await auth.signInWithEmailAndPassword(
            email: emailAdmin,
            password: passAdminC.text,
          );

          Get.back(); // tutup dialog
          Get.back(); // back to home
          Get.snackbar("berhasil", "berhasil menambah pegawai");
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          Get.snackbar("terjadi kesalahan", "password terlalu singkat");
        } else if (e.code == 'email-already-in-use') {
          Get.snackbar("terjadi kesalahan", "email sudah ada");
        } else if (e.code == 'wrong-password') {
          Get.snackbar("terjadi kesalahan", "password salah");
        } else {
          Get.snackbar("terjadi kesalahan", "${e.code}");
        }
      } catch (e) {
        Get.snackbar("terjadi kesalahan", "tidak dapat menambah pegawai");
      }
    } else {
      Get.snackbar("terjadi kesalahan", "password validasi wajib diisi");
    }
  }

  void addPegawai() async {
    if (nipC.text.isNotEmpty &&
        namaC.text.isNotEmpty &&
        emailC.text.isNotEmpty) {
      Get.defaultDialog(
          title: "validasi admin",
          content: Column(
            children: [
              Text("masukkan password untuk validasi"),
              SizedBox(height: 20),
              TextField(
                controller: passAdminC,
                autocorrect: false,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "password",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            OutlinedButton(
              onPressed: () => Get.back(),
              child: Text("cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                await prosesAddPegawai();
              },
              child: Text("add pegawai"),
            ),
          ]);
    } else {
      Get.snackbar("terjadi kesalahan", "semua data harus diisi");
    }
  }
}
