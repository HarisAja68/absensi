import 'package:get/get.dart';

import '../controllers/new_pass_controller.dart';

class NewPassBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewPassController>(
      () => NewPassController(),
    );
  }
}
