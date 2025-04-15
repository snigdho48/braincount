import 'package:braincount/app/modules/custom/appbar.dart';
import 'package:braincount/app/modules/custom/custombg.dart';
import 'package:braincount/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});
  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
        appBar: appBarWidget(context),
        body: backgroundColorLinear(
          child: SizedBox(
            height: Get.height,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: Get.height * .1,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Get.width * .1, vertical: 8.0),
                    child: Form(
                      key: controller.formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Obx(
                        () => Column(
                          children: [
                            SizedBox(
                              height: Get.height * .4,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                spacing: Get.height * .02,
                                children: [
                                  Text('Login',
                                      style: TextStyle(
                                          fontSize: Get.width * .1,
                                          fontWeight: FontWeight.w300,
                                          color: Colors.black87)),
                                  Text('Welcome! Please login to your account.',
                                      style: TextStyle(
                                          fontSize: Get.width * .04,
                                          fontWeight: FontWeight.w300,
                                          color: Colors.black87)),
                                  SizedBox(
                                    height: Get.height * .02,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextFormField(
                                focusNode: controller.emailFocus.value,
                                onFieldSubmitted: (value) {
                                  controller.emailFocus.value.unfocus();
                                  FocusScope.of(context).requestFocus(
                                      controller.passwordFocus.value);
                                },
                                controller: controller.email,
                                decoration: InputDecoration(
                                    labelText: 'Username',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          controller.emailFocus.value.hasFocus
                                              ? BorderSide.none
                                              : BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 0, 138, 97)),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(color: Colors.red),
                                    )),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: Get.height * .02),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextFormField(
                                controller: controller.password,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:
                                        controller.passwordFocus.value.hasFocus
                                            ? BorderSide.none
                                            : BorderSide(
                                                color: Color.fromARGB(
                                                    255, 0, 138, 97)),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.red),
                                  ),
                                  suffixIcon: Icon(Icons.visibility),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundBuilder: (context, states, child) =>
                                      Container(
                                    alignment: Alignment.center,
                                    width: Get.width * .5,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: Get.width * .05),
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 2,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                      gradient: LinearGradient(
                                        begin: Alignment.centerRight,
                                        end: Alignment.topLeft,
                                        colors: [
                                          Color.fromARGB(255, 228, 227, 236),
                                          Color.fromARGB(255, 243, 243, 243),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text('Login',
                                        textAlign: TextAlign.center,
                                        softWrap: true,
                                        style: TextStyle(
                                            fontSize: Get.width * .04,
                                            fontWeight: FontWeight.w300,
                                            color: Colors.black87)),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: controller.login,
                                child: SizedBox.shrink(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
