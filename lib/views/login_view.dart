import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sure_safe/app_constants/asset_path.dart';

import 'package:sure_safe/app_constants/colors.dart';
import 'package:sure_safe/controllers/login_controller.dart';
import 'package:sure_safe/helpers/sixed_boxes.dart';
import 'package:sure_safe/widgets/progress_indicators.dart';

import '../widgets/custom_textfield.dart';

class LoginView extends StatelessWidget {
  final loginController = Get.put(LoginController());

  LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      sb40,
                      Image.asset(
                        Assets.jKumarLogoBlack,
                        width: 100,
                      ),
                      const SizedBox(height: 20.0),
                      const Text(
                        "SAFETY SURE",
                        style:
                            TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "Login to Continue...",
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 20.0),
                      Form(
                        key: loginController.formKey,
                        child: Column(
                          children: <Widget>[
                            CustomTextField(
                              fieldName: 'Username',
                              controller: loginController.usernameController,
                              labelText: 'Enter Username',
                              validator: loginController.validateUsername,
                            ),
                            const SizedBox(height: 20),
                            Obx(() => CustomTextField(
                                  fieldName: 'Password',
                                  controller: loginController.passwordController,
                                  labelText: 'Enter Password',
                                  isPassword: true,
                                  obscureText:
                                      loginController.isPasswordHidden.value,
                                  onTogglePassword: () {
                                    loginController.isPasswordHidden.toggle();
                                  },
                                  validator: loginController.validatePassword,
                                )),
                            const SizedBox(height: 20),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: GestureDetector(
                                  onTap: () {
                                    print("clicked forget password");
                                    //Get.dialog(ForgotPasswordDialog());
                                  },
                                  child: Text(
                                    "Forgot Password ?",
                                    style: TextStyle(color: AppColors.appMainMid),
                                  )),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.appMainDark),
                                onPressed: loginController.handleLogin,
                                child: const Text(
                                  'Login',
                                  style: TextStyle(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "By clicking continue, you agree to our Terms of Service and Privacy Policy.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Obx(() {
                  return loginController.isLoading.value
                      ? Container(
                          height: MediaQuery.of(context).size.height,
                          color: Colors.grey.withOpacity(0.5),
                          child: const Center(
                            child: CustomProgressIndicator(),
                          ),
                        )
                      : const SizedBox.shrink();
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class ForgotPasswordDialog extends StatelessWidget {
//   final ForgotPasswordController controller =
//       Get.put(ForgotPasswordController());

//   ForgotPasswordDialog({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() => AlertDialog(
//           title: Text(
//             "Forgot Password",
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           content: controller.isLoading.value
//               ? SizedBox(
//                   height: 100,
//                   width: 100,
//                   child: Center(child: CircularProgressIndicator()),
//                 )
//               : Container(
//                   width: MediaQuery.of(context).size.width,
//                   height: 300,
//                   child: SingleChildScrollView(
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         if (!controller.isOtpSent.value) ...[
//                           CustomTextField(
//                             fieldName: "Email",
//                             labelText: "Enter email",
//                             controller: controller.emailController,
//                           ),
//                           SizedBox(height: 16),
//                           Text(
//                             "OTP to reset password will be sent on the email provided by you",
//                             style: TextStyle(fontSize: 12),
//                           ),
//                           SizedBox(height: 16),
//                           ElevatedButton(
//                             onPressed: controller.sendOtp,
//                             child: Text("Generate OTP"),
//                           ),
//                         ] else ...[
//                           CustomTextField(
//                             fieldName: 'OTP',
//                             controller: controller.otpController,
//                             labelText: 'Enter Password',

//                             //validator: loginController.validatePassword,
//                           ),
//                           SizedBox(height: 16),
//                           CustomTextField(
//                             fieldName: 'New Password',
//                             controller: controller.passwordController,
//                             labelText: 'Enter New Password',
//                             isPassword: true,
//                             //validator: loginController.validatePassword,
//                           ),
//                           // TextField(
//                           //   controller: controller.passwordController,
//                           //   obscureText: true,
//                           //   decoration:
//                           //       kTextFieldDecoration("Enter New Password"),
//                           // ),
//                           SizedBox(height: 16),
//                           ElevatedButton(
//                             onPressed: controller.resetPassword,
//                             child: Text("Reset Password"),
//                           ),
//                         ]
//                       ],
//                     ),
//                   ),
//                 ),
//         ));
//   }
// }
