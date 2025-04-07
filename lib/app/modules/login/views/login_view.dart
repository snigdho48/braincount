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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: Get.height * .1,
          children: <Widget>[
           Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Get.width * .1, vertical: 8.0),
             child: Form(
              key: controller.formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: 
             Column(
               children: [
                 Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    
                  ),
                   child: TextFormField(
                    focusNode: controller.emailFocus.value,
                    onFieldSubmitted: (value) {
                      controller.emailFocus.value.unfocus();
                      FocusScope.of(context).requestFocus(controller.passwordFocus.value);
                    },
                    controller: controller.email,
                     decoration: InputDecoration(
                       labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: !controller.emailFocus.value.hasFocus ? BorderSide.none : BorderSide(color: Color.fromARGB(255, 0, 138, 97)),
                        ),

                       
                       errorBorder: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(10),
                         borderSide: BorderSide(color: Colors.red),
                       )
                     ),
                   ),
                 ),
                 Container(
                  margin: EdgeInsets.symmetric(vertical: Get.height * .02),
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
                   padding: const EdgeInsets.all(8.0),
                   child: ElevatedButton(
                     onPressed: () {
                       Get.toNamed(Routes.HOME);
                     },
                     child: Text('Login'),
                   ),
                 ),
               ],
             ),
             ),
           ),
          ],
        ),
      )
    );
  }
}
