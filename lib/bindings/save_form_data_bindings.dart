import 'package:get/get.dart';
import 'package:sure_safe/views/saved_form_data/saved_form_data_controller.dart';

class SavedFormDataBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SavedFormDataController());
  }
}
