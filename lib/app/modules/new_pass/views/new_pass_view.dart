import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/new_pass_controller.dart';

class NewPassView extends GetView<NewPassController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NewPassView'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            autocorrect: false,
            obscureText: true,
            controller: controller.newPassC,
            decoration: InputDecoration(
              labelText: "password baru",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              controller.newPass();
            },
            child: Text("Ubah"),
          ),
        ],
      ),
    );
  }
}
