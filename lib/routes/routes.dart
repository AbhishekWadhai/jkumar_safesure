import 'package:get/get.dart';
import 'package:sure_safe/bindings/save_form_data_bindings.dart';
import 'package:sure_safe/routes/routes_string.dart';
import 'package:sure_safe/views/form_page.dart';
import 'package:sure_safe/views/home_page/home_page.dart';
import 'package:sure_safe/views/login_view.dart';
import 'package:sure_safe/views/module_page.dart';
import 'package:sure_safe/views/reporting_page.dart';
import 'package:sure_safe/views/safety_training.dart';
import 'package:sure_safe/views/user_details.dart';

class AppRoutes {
  static final routes = [
    GetPage(name: Routes.loginPage, page: () => LoginView()),
    GetPage(name: Routes.homePage, page: () => HomePage()),
    GetPage(
        name: Routes.formPage,
        page: () => FormPage(),
        binding: SavedFormDataBindings()),
    GetPage(
      name: Routes.modulePage,
      page: () => DynamicModulePage(),
    ),
    GetPage(
      name: Routes.safetyTraining,
      page: () => SafetyTraining(),
    ),
    GetPage(
      name: Routes.reportPage,
      page: () => ReportingPage(),
    ),
    GetPage(name: Routes.userDetailsDataPage, page: () => USerDetailsData()),
  ];
}
